<#
.SYNOPSIS
    Applique une baseline de sécurité GPO minimale pour le domaine NovaEnterprise.

.DESCRIPTION
    Ce script crée et lie les GPO de sécurité fondamentales :
    - SEC-PasswordPolicy    : Politique de mots de passe (CIS-inspirée)
    - SEC-RestrictRDP       : Restriction de l'accès RDP aux admins IT
    - SEC-ScreenLock        : Verrouillage automatique de session après inactivité
    - SEC-DisableUSB        : Désactivation des périphériques de stockage USB
    - SEC-AuditPolicy       : Activation des journaux d'audit de connexion

.EXAMPLE
    .\Set-GPOBaseline.ps1
    .\Set-GPOBaseline.ps1 -DomainDNS "mondomaine.local" -WhatIf

.NOTES
    Auteur   : Cedric Somkwe
    Domaine  : novaenterprise.com
    Prérequis: Module GroupPolicy, droits Domain Admin
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [string]$DomainDNS = "novaenterprise.com"
)

# ─── Vérification du module GroupPolicy ──────────────────────────────────────
if (-not (Get-Module -ListAvailable -Name GroupPolicy)) {
    Write-Error "Le module GroupPolicy n'est pas disponible. Installer RSAT: Group Policy Management Tools."
    exit 1
}
Import-Module GroupPolicy

$DNSRoot    = ($DomainDNS -split "\." | ForEach-Object { "DC=$_" }) -join ","
$NovaCorpOU = "OU=NOVA_CORP,$DNSRoot"

# ─── Fonction utilitaire ──────────────────────────────────────────────────────
function New-GPOSafe {
    param (
        [string]$Name,
        [string]$Comment = ""
    )
    $existing = Get-GPO -Name $Name -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "  [EXISTE] GPO '$Name' déjà présente." -ForegroundColor DarkYellow
        return $existing
    }
    $gpo = New-GPO -Name $Name -Comment $Comment
    Write-Host "  [CRÉÉ]   GPO '$Name' créée." -ForegroundColor Green
    return $gpo
}

# ─── 1. SEC-PasswordPolicy ────────────────────────────────────────────────────
Write-Host "`n=== GPO : SEC-PasswordPolicy ===" -ForegroundColor Cyan
$gpo = New-GPOSafe -Name "SEC-PasswordPolicy" -Comment "Politique de mots de passe CIS-inspirée"

# Longueur minimale : 12 caractères
Set-GPRegistryValue -Name "SEC-PasswordPolicy" `
    -Key "HKLM\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" `
    -ValueName "MinimumPasswordLength" -Type DWord -Value 12

# Lier la GPO au domaine
New-GPLink -Name "SEC-PasswordPolicy" -Target $DNSRoot -LinkEnabled Yes -ErrorAction SilentlyContinue
Write-Host "  [LIEN]   GPO liée au domaine $DomainDNS" -ForegroundColor Green

# ─── 2. SEC-RestrictRDP ───────────────────────────────────────────────────────
Write-Host "`n=== GPO : SEC-RestrictRDP ===" -ForegroundColor Cyan
$gpo = New-GPOSafe -Name "SEC-RestrictRDP" -Comment "Restreindre l'accès RDP aux administrateurs IT"

New-GPLink -Name "SEC-RestrictRDP" -Target $NovaCorpOU -LinkEnabled Yes -ErrorAction SilentlyContinue
Write-Host "  [LIEN]   GPO liée à NOVA_CORP" -ForegroundColor Green
Write-Host "  [INFO]   Configurer manuellement 'Allow log on through Remote Desktop Services'" -ForegroundColor Yellow
Write-Host "           dans Computer Configuration > Windows Settings > Security Settings > Local Policies > User Rights Assignment" -ForegroundColor Yellow

# ─── 3. SEC-ScreenLock ────────────────────────────────────────────────────────
Write-Host "`n=== GPO : SEC-ScreenLock ===" -ForegroundColor Cyan
$gpo = New-GPOSafe -Name "SEC-ScreenLock" -Comment "Verrouillage automatique après 10 minutes d'inactivité"

# Inactivité écran : 600 secondes (10 min)
Set-GPRegistryValue -Name "SEC-ScreenLock" `
    -Key "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" `
    -ValueName "ScreenSaveTimeOut" -Type String -Value "600"

Set-GPRegistryValue -Name "SEC-ScreenLock" `
    -Key "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" `
    -ValueName "ScreenSaverIsSecure" -Type String -Value "1"

New-GPLink -Name "SEC-ScreenLock" -Target $NovaCorpOU -LinkEnabled Yes -ErrorAction SilentlyContinue
Write-Host "  [LIEN]   GPO liée à NOVA_CORP" -ForegroundColor Green

# ─── 4. SEC-DisableUSB ────────────────────────────────────────────────────────
Write-Host "`n=== GPO : SEC-DisableUSB ===" -ForegroundColor Cyan
$gpo = New-GPOSafe -Name "SEC-DisableUSB" -Comment "Désactiver les périphériques de stockage USB amovibles"

# Désactiver le service de stockage amovible
Set-GPRegistryValue -Name "SEC-DisableUSB" `
    -Key "HKLM\SYSTEM\CurrentControlSet\Services\UsbStor" `
    -ValueName "Start" -Type DWord -Value 4

New-GPLink -Name "SEC-DisableUSB" -Target $NovaCorpOU -LinkEnabled Yes -ErrorAction SilentlyContinue
Write-Host "  [LIEN]   GPO liée à NOVA_CORP" -ForegroundColor Green

# ─── 5. SEC-AuditPolicy ───────────────────────────────────────────────────────
Write-Host "`n=== GPO : SEC-AuditPolicy ===" -ForegroundColor Cyan
$gpo = New-GPOSafe -Name "SEC-AuditPolicy" -Comment "Activation des journaux d'audit de connexion et d'accès"

New-GPLink -Name "SEC-AuditPolicy" -Target $DNSRoot -LinkEnabled Yes -ErrorAction SilentlyContinue
Write-Host "  [LIEN]   GPO liée au domaine $DomainDNS" -ForegroundColor Green
Write-Host "  [INFO]   Configurer manuellement via auditpol.exe ou Security Settings > Advanced Audit Policy" -ForegroundColor Yellow

# ─── Résumé ───────────────────────────────────────────────────────────────────
Write-Host "`n╔══════════════════════════════════════════════════╗" -ForegroundColor White
Write-Host "║   Baseline GPO appliquée. Effectuer un :        ║" -ForegroundColor White
Write-Host "║   gpupdate /force  sur les postes concernés.    ║" -ForegroundColor White
Write-Host "╚══════════════════════════════════════════════════╝`n" -ForegroundColor White
