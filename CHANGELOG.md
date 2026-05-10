# Changelog — Active Directory Lab NovaEnterprise

Toutes les modifications notables du projet sont documentées ici.
Format basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/).

---

## [1.3.0] — 2026-05-10

### Ajouté
- Documentation du chapitre 00 : Configuration du nœud Proxmox et des réseaux virtuels (Bridge vmbr0)
- Documentation du chapitre 12 : Déploiement et sécurisation du serveur DHCP avec Failover
- Intégration de 39 nouvelles captures d'écran validant la configuration réseau, DHCP et la redondance
- Ajout des étapes de résolution de problèmes réseau (Troubleshooting gateway) dans la documentation Proxmox

### Modifié
- Harmonisation complète du plan d'adressage IP (migration de `192.168.1.x` vers `192.168.253.x`) sur l'ensemble de la documentation
- Refonte du chapitre 11 : Intégration des étapes PowerShell pour le déplacement de l'objet ordinateur et la validation de la réplication (repadmin/nltest)
- Standardisation du ton (retrait des tutoiements informels) dans les chapitres RSAT (05) et Windows Admin Center (08)
- Mise à jour du README : correction des schémas réseau, actualisation des statuts de scripts et ajout des nouveaux chapitres

---

## [1.2.0] — 2026-04-25

### Ajouté
- Documentation complète de la section 09 : Partages de fichiers & permissions NTFS
- Documentation complète de la section 10 : Sysprep & déploiement d'image Windows
- Script `Set-GPOBaseline.ps1` : déploiement automatisé des 5 GPO de sécurité de base
- Fichier `.gitattributes` pour normaliser les fins de ligne entre plateformes
- Images extraites du document de travail et intégrées dans chaque section de documentation

### Modifié
- `New-ADUsers.ps1` : suppression du mot de passe en clair — remplacement par `Read-Host -AsSecureString`
- `users-sample.csv` : enrichi à 7 utilisateurs couvrant les 3 départements (IT, HR, Sales)
- Ton de la documentation revu vers un style technique impersonnel (infinitif)
- `.gitignore` : ajout des fichiers `.docx` et brouillons de travail

---

## [1.1.0] — 2026-04-10

### Ajouté
- Scripts PowerShell : `New-OUStructure.ps1` et `New-ADUsers.ps1`
- Documentation des étapes 06 à 08 : Structure OU, GPO de sécurité, Windows Admin Center
- Fichier `users-sample.csv` pour les tests de création en masse

### Modifié
- README enrichi avec l'architecture réseau et la structure OU

---

## [1.0.0] — 2026-03-15

### Ajouté
- Structure initiale du projet
- Documentation des étapes 01 à 05 : réseau, AD DS, DNS client, jonction domaine, RSAT
- README avec prérequis, architecture et tableau de bord des étapes
