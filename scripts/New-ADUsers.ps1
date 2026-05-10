<#
.SYNOPSIS
    Crée des utilisateurs Active Directory en masse depuis un fichier CSV.

.DESCRIPTION
    Lit un fichier CSV et crée les comptes utilisateurs dans les OUs appropriées.

.EXAMPLE
    .\New-ADUsers.ps1 -CsvPath ".\users.csv"

.NOTES
    Auteur  : Cedric Somkwe
    Domaine : novaenterprise.com

    Format du CSV attendu :
    GivenName,Surname,SamAccountName,Department,Title
    Jean,Dupont,jdupont,DEP_IT,Technicien
    Marie,Martin,mmartin,DEP_HR,RH Manager
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$CsvPath,

    [string]$DomainDNS = "novaenterprise.com",

    [Parameter(HelpMessage = "Mot de passe initial des comptes créés")]
    [SecureString]$DefaultPassword = (Read-Host -AsSecureString "Mot de passe initial pour les nouveaux comptes")
)

$DNSRoot    = ($DomainDNS -split "\." | ForEach-Object { "DC=$_" }) -join ","
$BasePath   = "OU=NOVA_CORP,$DNSRoot"

Import-Module ActiveDirectory

$users = Import-Csv -Path $CsvPath

foreach ($u in $users) {
    $ouPath = "OU=$($u.Department),OU=OU_Users,$BasePath"
    $upn    = "$($u.SamAccountName)@$DomainDNS"

    try {
        New-ADUser `
            -GivenName            $u.GivenName `
            -Surname              $u.Surname `
            -Name                 "$($u.GivenName) $($u.Surname)" `
            -SamAccountName       $u.SamAccountName `
            -UserPrincipalName    $upn `
            -Title                $u.Title `
            -Department           $u.Department `
            -Path                 $ouPath `
            -AccountPassword      $DefaultPassword `
            -ChangePasswordAtLogon $true `
            -Enabled              $true

        Write-Host "[OK] Créé : $($u.SamAccountName) dans $ouPath" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERREUR] $($u.SamAccountName) : $_" -ForegroundColor Red
    }
}

Write-Host "`nImportation terminée." -ForegroundColor Cyan
