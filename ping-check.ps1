# ==============================================================================
# PROJEKT: Ping Check (Advanced Network Monitoring Tool)
# AUTOR: Daniel Gerald Unrath
# ==============================================================================

$TargetFile = Join-Path $PSScriptRoot "targets.txt"
$FallbackTargets = @("127.0.0.1", "8.8.8.8", "192.168.1.1")
$Intervall = 5
$Timeout = 1
$LogDatei = Join-Path $PSScriptRoot "monitor_log.csv"
$OnlyStateChanges = $true

if (Test-Path $TargetFile) {
    $NetzwerkZiele = Get-Content $TargetFile | Where-Object { $_ -match '\S' }
} else {
    Write-Host "WARNUNG: targets.txt fehlt -> Fallback wird verwendet" -ForegroundColor Yellow
    $NetzwerkZiele = $FallbackTargets
}

$LetzteStatus = @{}

if (!(Test-Path $LogDatei)) {
    try {
        "Timestamp,Host,Status,ResponseTime_ms" | Out-File $LogDatei -Encoding utf8 -ErrorAction Stop
    }
    catch {
        Write-Error "Kritischer Fehler: Log-Datei konnte nicht initialisiert werden: $_"
        exit
    }
}

Clear-Host
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "            Ping Check Tool             " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Geladene Ziele : $($NetzwerkZiele.Count)" -ForegroundColor Gray
Write-Host "Prüfintervall  : $Intervall s" -ForegroundColor Gray
Write-Host "Log-Pfad       : $LogDatei" -ForegroundColor Gray
Write-Host "`nBeenden mit [STRG + C]`n" -ForegroundColor Yellow

while ($true) {
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogBuffer = @()

    foreach ($Ziel in $NetzwerkZiele) {
        try {
            $PingParams = @{
                ComputerName = $Ziel
                Count        = 1
                ErrorAction  = "Stop"
            }

            if ($PSVersionTable.PSVersion.Major -ge 6) {
                $PingParams["TimeoutSeconds"] = $Timeout
            }

            $Ping = Test-Connection @PingParams
            $Status = "ONLINE"

            if ($null -ne $Ping.ResponseTime) {
                $ResponseTime = $Ping.ResponseTime
            } elseif ($null -ne $Ping.Latency) {
                $ResponseTime = $Ping.Latency
            } else {
                $ResponseTime = 0
            }
        }
        catch {
            $Status = "OFFLINE"
            $ResponseTime = "N/A"
        }

        $AlterStatus = $LetzteStatus[$Ziel]
        $StatusChanged = ($AlterStatus -ne $Status)
        $LetzteStatus[$Ziel] = $Status

        if ($Status -eq "ONLINE") {
            Write-Host "[$Timestamp] $Ziel -> ONLINE ($ResponseTime ms)" -ForegroundColor Green
        } else {
            Write-Host "[$Timestamp] $Ziel -> OFFLINE" -ForegroundColor Red
            if ($StatusChanged) {
                Write-Host "!!! ALERT: $Ziel ist jetzt OFFLINE !!!" -ForegroundColor Yellow
            }
        }

        if (-not $OnlyStateChanges -or $StatusChanged) {
            $LogBuffer += "$Timestamp,$Ziel,$Status,$ResponseTime"
        }
    }

    if ($LogBuffer.Count -gt 0) {
        try {
            $LogBuffer | Out-File -Append -Encoding utf8 -FilePath $LogDatei -ErrorAction Stop
        }
        catch {
            Write-Host "[$Timestamp] WARNUNG: Schreiben fehlgeschlagen: $_" -ForegroundColor Red
        }
    }

    Start-Sleep -Seconds $Intervall
}