# ==============================================================================
# PROJEKT: Automatisierter Netzwerk-Ping-Tester
# AUTOR: Daniel Gerald Unrath
# ZWECK: Überprüfung der Erreichbarkeit kritischer Netzwerk-Infrastruktur
# ==============================================================================

# 1. Definition der zu prüfenden IP-Adressen (Array)
$NetzwerkZiele = @(
    "127.0.0.1",       # Localhost (Eigener PC)
    "8.8.8.8",         # Google Public DNS (Internet-Prüfung)
    "192.168.1.1",     # Typische Router-IP (Lokales Netzwerk)
    "10.0.0.99"        # Fiktive IP (Protest für den Offline-Fall)
)

Write-Host "=== Starte automatisierten Infrastruktur-Check ===" -ForegroundColor Cyan
Write-Host "--------------------------------------------------"

# 2. Schleife: Jedes Ziel einzeln prüfen
foreach ($Ziel in $NetzwerkZiele) {

    Write-Host "Pruefe Verbindung zu: $Ziel..." -NoNewline

    # Test-Connection ist das PowerShell-Pendant zum klassischen 'ping'
    # -Count 1 sendet nur ein Paket (spart Zeit)
    # -Quiet liefert exakt $True (online) oder $False (offline) zurück
    $Ergebnis = Test-Connection -ComputerName $Ziel -Count 1 -Quiet

    # 3. Auswertung der Erreichbarkeit (If/Else-Bedingung)
    if ($Ergebnis -eq $True) {
        Write-Host " [ONLINE]" -ForegroundColor Green
    } else {
        Write-Host " [OFFLINE / TIME-OUT]" -ForegroundColor Red
    }
}

Write-Host "--------------------------------------------------"
Write-Host "Infrastruktur-Check beendet." -ForegroundColor Cyan