# Projekt: Virtuelle Testumgebung mit Windows Server 2022

## Zweck
Aufbau einer isolierten Infrastruktur unter Hyper-V zur gefahrlosen Simulation von administrativen Kernaufgaben. Dieses Projekt demonstriert den Umgang mit Server-Virtualisierung, Active Directory (AD DS) und PowerShell-Automatisierung.

## Systemarchitektur
* **Hypervisor:** Microsoft Hyper-V
* **Netzwerk:** Privater virtueller Switch (isoliert vom physischen Host-Netzwerk)
* **Gast-System:** Windows Server 2022 (Domain Controller)
* **Dienste:** Active Directory Domain Services (AD DS), DNS

## Umgesetzte Konfigurationen
1. **Active Directory:** Aufbau einer logischen Struktur mittels Organisationseinheiten (OUs) zur Trennung von Benutzern, Administratoren und Computern.
2. **Server-Hardening (Gruppenrichtlinien / GPOs):**
   * Erzwingung von komplexen Kennwörtern (mindestens 12 Zeichen).
   * Automatische Bildschirmsperre nach 5 Minuten Inaktivität.
   * Deaktivierung von USB-Massenspeichern über administrative Vorlagen.
3. **Automatisierung:** Massenanlage von Benutzern über ein eigens erstelltes PowerShell-Skript (siehe `AD-Benutzeranlage.ps1`), um Tippfehler bei der manuellen Anlage zu vermeiden.