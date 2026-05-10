# 05 — Installation des Outils RSAT

## Objectif
Installer les outils d'administration à distance (RSAT) sur le PC client pour gérer le serveur sans y être connecté directement.

---

## Qu'est-ce que RSAT ?

**Remote Server Administration Tools (RSAT)** permet d'administrer les services suivants depuis le poste client :
- Active Directory Users and Computers
- Group Policy Management Console (GPMC)
- DNS Manager
- DHCP Manager
- Et bien d'autres...

---

## Méthode 1 — Interface graphique (Windows 10/11)

> **Contexte** : L'ajout via les **Fonctionnalités optionnelles** de Windows est la méthode standard. Elle ne nécessite pas de connexion Internet (les fichiers RSAT sont inclus dans l'image Windows 10/11 depuis la version 1809).

1. Naviguer vers **Settings → System → Optional Features**.
2. Cliquer sur **Add a feature** (ou **View features**).
3. Rechercher `RSAT`.
4. Installer les fonctionnalités minimales requises :
   - ✅ **RSAT: Active Directory Domain Services & Lightweight Directory Services Tools**
   - ✅ **RSAT: Group Policy Management Tools**
   - ✅ **RSAT: DNS Server Tools** *(optionnel)*

---

## Méthode 2 — PowerShell (recommandé)

> **Contexte** : `Add-WindowsCapability` installe les outils RSAT directement depuis Windows Update ou un point de partage WSUS. Cette méthode est idéale pour un déploiement automatisé sur plusieurs postes.

```powershell
# Installer les outils AD DS
Add-WindowsCapability -Online -Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"

# Installer Group Policy Management
Add-WindowsCapability -Online -Name "Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0"

# Installer DNS Tools
Add-WindowsCapability -Online -Name "Rsat.Dns.Tools~~~~0.0.1.0"

# Vérifier l'installation
Get-WindowsCapability -Online | Where-Object { $_.Name -like "Rsat*" -and $_.State -eq "Installed" }
```

---

## Accéder aux outils installés

> **Contexte** : Chaque outil RSAT correspond à une console MMC (`.msc`). Une fois installées, ces consoles permettent d'administrer les services du DC à distance, sans avoir à ouvrir une session directement sur le serveur.

Après installation, accéder aux consoles via **Démarrer → Windows Administrative Tools** ou en exécutant :

| Outil | Commande |
|-------|----------|
| AD Users and Computers | `dsa.msc` |
| Group Policy Management | `gpmc.msc` |
| DNS Manager | `dnsmgmt.msc` |
| AD Sites and Services | `dssite.msc` |

---

## ✅ Validation

- [ ] RSAT AD DS installé
- [ ] RSAT Group Policy installé
- [ ] `dsa.msc` s'ouvre et affiche le domaine `novaenterprise.com`
- [ ] `gpmc.msc` s'ouvre sans erreur
