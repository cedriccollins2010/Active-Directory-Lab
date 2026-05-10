<#
.SYNOPSIS
    Crée la structure complète des Unités d'Organisation (OU) pour NovaEnterprise.

.DESCRIPTION
    Ce script crée automatiquement toute la hiérarchie OU dans Active Directory :
    - OU racine NOVA_CORP
    - Sous-OUs (Admins, Users, Groups, Computers, Servers)
    - Départements sous OU_Users (IT, Sales, HR)
    - Types de postes sous OU_Computers (Desktops, Laptops)
    - Groupe de sécurité G_SEC_IT_Admins

.PARAMETER DomainDNS
    Nom DNS du domaine (défaut: novaenterprise.com)

.EXAMPLE
    .\New-OUStructure.ps1
    .\New-OUStructure.ps1 -DomainDNS "mondomaine.local"

.NOTES
    Auteur  : Cedric Somkwe
    Domaine : novaenterprise.com
    Prérequis : Module ActiveDirectory, droits Domain Admin
#>

[CmdletBinding()]
param (
    [string]$DomainDNS = "novaenterprise.com"
)

# ─── Variables ────────────────────────────────────────────────────────────────
$DNSRoot    = ($DomainDNS -split "\." | ForEach-Object { "DC=$_" }) -join ","
$OU_Racine  = "NOVA_CORP"
$ParentPath = "OU=$OU_Racine,$DNSRoot"

# ─── Vérification du module AD ────────────────────────────────────────────────
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Error "Le module ActiveDirectory n'est pas disponible. Installez RSAT."
    exit 1
}
Import-Module ActiveDirectory

# ─── Fonction utilitaire ──────────────────────────────────────────────────────
function New-OUSafe {
    param (
        [string]$Name,
        [string]$Path,
        [string]$Description = ""
    )
    $fullPath = "OU=$Name,$Path"
    if (Get-ADOrganizationalUnit -Filter { DistinguishedName -eq $fullPath } -ErrorAction SilentlyContinue) {
        Write-Host "  [EXISTE] OU '$Name' déjà présente." -ForegroundColor DarkYellow
    } else {
        New-ADOrganizationalUnit -Name $Name -Path $Path -Description $Description -ProtectedFromAccidentalDeletion $true
        Write-Host "  [CRÉÉ]   OU '$Name' créée dans '$Path'." -ForegroundColor Green
    }
}

# ─── Création OU Racine ───────────────────────────────────────────────────────
Write-Host "`n=== Création de l'OU Racine : $OU_Racine ===" -ForegroundColor Cyan
New-OUSafe -Name $OU_Racine -Path $DNSRoot -Description "OU racine NovaEnterprise"

# ─── Sous-OUs principales ─────────────────────────────────────────────────────
Write-Host "`n=== Création des sous-OUs principales ===" -ForegroundColor Cyan
$SubOUs = @{
    "OU_Admins"    = "Comptes administrateurs"
    "OU_Users"     = "Utilisateurs standards"
    "OU_Groups"    = "Groupes de sécurité"
    "OU_Computers" = "Postes de travail"
    "OU_Servers"   = "Serveurs membres"
}
foreach ($OU in $SubOUs.GetEnumerator()) {
    New-OUSafe -Name $OU.Key -Path $ParentPath -Description $OU.Value
}

# ─── Départements sous OU_Users ───────────────────────────────────────────────
Write-Host "`n=== Création des départements (OU_Users) ===" -ForegroundColor Cyan
$UsersPath = "OU=OU_Users,$ParentPath"
$Depts = @{
    "DEP_IT"    = "Département Informatique"
    "DEP_Sales" = "Département Commercial"
    "DEP_HR"    = "Ressources Humaines"
}
foreach ($Dept in $Depts.GetEnumerator()) {
    New-OUSafe -Name $Dept.Key -Path $UsersPath -Description $Dept.Value
}

# ─── Types de postes sous OU_Computers ────────────────────────────────────────
Write-Host "`n=== Création des types de postes (OU_Computers) ===" -ForegroundColor Cyan
$CompsPath = "OU=OU_Computers,$ParentPath"
$CompTypes = @{
    "WKS_Desktops" = "Ordinateurs de bureau"
    "WKS_Laptops"  = "Ordinateurs portables"
}
foreach ($Type in $CompTypes.GetEnumerator()) {
    New-OUSafe -Name $Type.Key -Path $CompsPath -Description $Type.Value
}

# ─── Groupe de sécurité ───────────────────────────────────────────────────────
Write-Host "`n=== Création du groupe de sécurité ===" -ForegroundColor Yellow
$GroupPath  = "OU=OU_Groups,$ParentPath"
$GroupName  = "G_SEC_IT_Admins"
if (Get-ADGroup -Filter { Name -eq $GroupName } -ErrorAction SilentlyContinue) {
    Write-Host "  [EXISTE] Groupe '$GroupName' déjà présent." -ForegroundColor DarkYellow
} else {
    New-ADGroup `
        -Name          $GroupName `
        -GroupCategory Security `
        -GroupScope    Global `
        -Path          $GroupPath `
        -Description   "Administrateurs IT avec accès privilégié"
    Write-Host "  [CRÉÉ]   Groupe '$GroupName' créé." -ForegroundColor Green
}

# ─── Résumé ───────────────────────────────────────────────────────────────────
Write-Host "`n╔══════════════════════════════════════════╗" -ForegroundColor White
Write-Host "║   Automatisation terminée avec succès !  ║" -ForegroundColor White
Write-Host "╚══════════════════════════════════════════╝`n" -ForegroundColor White
