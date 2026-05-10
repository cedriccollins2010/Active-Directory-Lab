# 🏢 Active Directory Lab — NovaEnterprise

> Lab pratique de déploiement et configuration d'un environnement Active Directory en entreprise simulée.

![Windows Server](https://img.shields.io/badge/Windows_Server-2019%2F2022-0078D4?style=flat&logo=windows)
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-5391FE?style=flat&logo=powershell)
![Status](https://img.shields.io/badge/Status-Actif-green)
![Domain](https://img.shields.io/badge/Domain-novaenterprise.com-green)

---

## 📋 Table des matières

1. [Vue d'ensemble](#vue-densemble)
2. [Prérequis](#prérequis)
3. [Architecture du lab](#architecture-du-lab)
4. [Étapes du lab](#étapes-du-lab)
5. [Scripts PowerShell](#scripts-powershell)
6. [Structure OU](#structure-ou)
7. [Améliorations futures](#améliorations-futures)

---

## 🔭 Vue d'ensemble

Ce lab simule le déploiement d'une infrastructure Active Directory pour une entreprise fictive **NovaEnterprise**.  
L'objectif est de couvrir les compétences clés d'un administrateur système Windows :

- ✅ Configuration de l'hyperviseur Proxmox et de ses réseaux virtuels
- ✅ Configuration réseau, DHCP Failover et DNS
- ✅ Installation et promotion de plusieurs Domain Controllers
- ✅ Création d'une structure OU professionnelle
- ✅ Gestion des utilisateurs et groupes AD
- ✅ Politiques de sécurité via GPO
- ✅ Administration à distance (RSAT, Windows Admin Center)
- ✅ Partage de fichiers et permissions NTFS
- ✅ Déploiement Sysprep et automatisation post-image

---

## ⚙️ Prérequis

| Composant | Détails |
|-----------|---------|
| OS Serveur | Windows Server 2019 ou 2022 |
| OS Client | Windows 10 ou 11 |
| RAM (recommandé) | 8 Go minimum (16 Go idéal) |
| Hyperviseur | Proxmox VE, VirtualBox, VMware ou Hyper-V |
| IP DC1 (statique) | `192.168.253.128` |
| IP DC2 (statique) | `192.168.253.132` |
| Domaine | `novaenterprise.com` |
| Outils admin | RSAT, Windows Admin Center (WAC) |

---

## 🗺️ Architecture du lab

```
┌────────────────────────────────────────────────────────┐
│                   novaenterprise.com                   │
│                                                        │
│   ┌────────────────┐          ┌────────────────┐       │
│   │ DC1 (Serveur)  │          │ DC2 (Serveur)  │       │
│   │ 192.168.253.128│          │ 192.168.253.132│       │
│   │ DNS + AD + DHCP│◄────────►│ DNS + AD + DHCP│       │
│   └───────┬────────┘          └───────┬────────┘       │
│           │                           │                │
│           └─────────────┬─────────────┘                │
│                         │                              │
│                  ┌──────┴───────┐                      │
│                  │  CL1 (Client)│                      │
│                  │ Windows 10/11│                      │
│                  └──────────────┘                      │
└────────────────────────────────────────────────────────┘
```

---

## 📚 Étapes du lab

| # | Étape | Fichier | Statut |
|---|-------|---------|--------|
| 00 | Préparation Proxmox & VMs | [00-proxmox-setup.md](docs/00-proxmox-setup.md) | ✅ |
| 01 | Configuration réseau & RDP | [01-network-config.md](docs/01-network-config.md) | ✅ |
| 02 | Installation AD DS & promotion DC | [02-ad-ds-installation.md](docs/02-ad-ds-installation.md) | ✅ |
| 03 | Configuration DNS côté client | [03-dns-client-config.md](docs/03-dns-client-config.md) | ✅ |
| 04 | Jonction au domaine | [04-domain-join.md](docs/04-domain-join.md) | ✅ |
| 05 | Installation RSAT | [05-rsat-tools.md](docs/05-rsat-tools.md) | ✅ |
| 06 | Structure OU entreprise | [06-ou-structure.md](docs/06-ou-structure.md) | ✅ |
| 07 | Sécurité via GPO | [07-gpo-security.md](docs/07-gpo-security.md) | ✅ |
| 08 | Windows Admin Center | [08-windows-admin-center.md](docs/08-windows-admin-center.md) | ✅ |
| 09 | Dossiers partagés & NTFS | [09-shared-folders.md](docs/09-shared-folders.md) | ✅ |
| 10 | Sysprep & déploiement | [10-sysprep-deployment.md](docs/10-sysprep-deployment.md) | ✅ |
| 11 | Serveur secondaire (DC2) | [11-secondary-server-deployment.md](docs/11-secondary-server-deployment.md) | ✅ |
| 12 | Configuration Serveur DHCP | [12-dhcp-configuration.md](docs/12-dhcp-configuration.md) | ✅ |

---

## ⚡ Scripts PowerShell

| Script | Description |
|--------|-------------|
| [`New-OUStructure.ps1`](scripts/New-OUStructure.ps1) | Crée toute la structure OU automatiquement |
| [`New-ADUsers.ps1`](scripts/New-ADUsers.ps1) | Création d'utilisateurs en masse à partir d'un CSV |
| [`Set-GPOBaseline.ps1`](scripts/Set-GPOBaseline.ps1) | Applique les GPO de sécurité de base |

---

## 🗂️ Structure OU

```
novaenterprise.com
└── NOVA_CORP
    ├── OU_Admins        → Comptes administrateurs
    ├── OU_Users
    │   ├── DEP_IT
    │   ├── DEP_Sales
    │   └── DEP_HR
    ├── OU_Groups        → Groupes de sécurité
    ├── OU_Computers
    │   ├── WKS_Desktops
    │   └── WKS_Laptops
    └── OU_Servers       → Serveurs membres
```

---

## Améliorations futures

- [ ] Schémas réseau avec draw.io
- [ ] Intégration avec Microsoft Entra ID (Azure AD Connect)
- [ ] Configuration WDS / MDT pour déploiement PXE
- [ ] GPO de baseline CIS Benchmark complète
- [ ] Monitoring avec Windows Admin Center + alertes

---

## 👤 Auteur

**Cedric Somkwe** — `csomkwe@novaenterprise.com`  
Lab personnel d'apprentissage en administration système Windows.
