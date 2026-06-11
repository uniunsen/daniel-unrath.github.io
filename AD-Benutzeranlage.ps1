# ==============================================================================
# PROJEKT: Automatisierte Active-Directory Benutzeranlage
# AUTOR: Daniel Gerald Unrath
# ZWECK: Standardisierte Erstellung von AD-Benutzern zur Fehlervermeidung
# ==============================================================================

# 1. Modul laden, um AD-Befehle nutzen zu koennen
Import-Module ActiveDirectory

# 2. Definition der neuen Mitarbeiter (Array)
$NeueBenutzer = @(
    @{ Vorname = "Max"; Nachname = "Mustermann"; Abteilung = "IT"; Titel = "Systemadministrator" },
    @{ Vorname = "Anna"; Nachname = "Schmidt"; Abteilung = "HR"; Titel = "Personalreferentin" }
)

Write-Host "=== Starte automatisierten AD-Benutzerimport ===" -ForegroundColor Cyan
Write-Host "--------------------------------------------------"

# 3. Schleife: Jeden Benutzer einzeln verarbeiten
foreach ($User in $NeueBenutzer) {
    
    # Generiere den standardisierten Anmeldenamen (z. B. max.mustermann)
    $SamAccountName = ($User.Vorname + "." + $User.Nachname).ToLower()

    Write-Host "Pruefe und erstelle Benutzer: $SamAccountName..." -NoNewline

    # 4. Logische Pruefung: Existiert der Benutzer bereits im AD?
    $Existiert = Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'"

    if ($Existiert) {
        Write-Host " [ÜBERSPRUNGEN - Existiert bereits]" -ForegroundColor Yellow
    } else {
        # 5. Benutzer anlegen (Wird aus Sicherheitsgruenden deaktiviert erstellt)
        # HINWEIS: Der Pfad (OU) muss an die tatsaechliche Testumgebung angepasst werden
        New-ADUser -Name "$($User.Vorname) $($User.Nachname)" `
                   -GivenName $User.Vorname `
                   -Surname $User.Nachname `
                   -SamAccountName $SamAccountName `
                   -Department $User.Abteilung `
                   -Title $User.Titel `
                   -Path "OU=Benutzer,DC=testumgebung,DC=local" `
                   -Enabled $false

        Write-Host " [ERFOLGREICH ANGELEGT]" -ForegroundColor Green
    }
}

Write-Host "--------------------------------------------------"
Write-Host "AD-Import beendet." -ForegroundColor Cyan