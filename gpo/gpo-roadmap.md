# GPO — Notes & Roadmap

## GPO planifiées pour NovaEnterprise

| Nom GPO | Lien OU | Priorité | Statut |
|---------|---------|----------|--------|
| `SEC-RestrictRDP` | `OU_Servers` | 🔴 Haute | 🔲 À faire |
| `SEC-PasswordPolicy` | Domaine entier | 🔴 Haute | 🔲 À faire |
| `SEC-DisableUSB` | `OU_Computers` | 🟡 Moyenne | 🔲 À faire |
| `SEC-ScreenLock` | `OU_Computers` | 🟡 Moyenne | 🔲 À faire |
| `SEC-DisableControlPanel` | `OU_Users` | 🟢 Basse | 🔲 À faire |
| `SEC-AuditPolicy` | Domaine entier | 🟡 Moyenne | 🔲 À faire |
| `DEPLOY-MapNetworkDrives` | `OU_Users` | 🟡 Moyenne | 🔲 À faire |
| `DEPLOY-Wallpaper` | `OU_Computers` | 🟢 Basse | 🔲 À faire |

## Commandes utiles

```powershell
# Voir toutes les GPO du domaine
Get-GPO -All

# Forcer l'application des GPO
gpupdate /force

# Rapport des GPO appliquées
gpresult /r

# Rapport HTML détaillé
gpresult /h C:\gpo-report.html
```

## Ressources

- [CIS Benchmarks pour Windows Server](https://www.cisecurity.org/cis-benchmarks)
- [Microsoft Security Compliance Toolkit](https://www.microsoft.com/en-us/download/details.aspx?id=55319)
