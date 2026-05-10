# 10 — Sysprep & Déploiement d'Image Windows

## Objectif

Préparer une image Windows 10/11 généralisée avec Sysprep, puis automatiser son déploiement sur de nouveaux postes incluant la jonction au domaine `novaenterprise.com`.

---

## Concept

Sysprep (**System Preparation Tool**) permet de généraliser une installation Windows pour la dupliquer sur plusieurs machines sans conflits de SID ou de nom d'hôte. L'image produite peut être capturée avec WIM et déployée via MDT, WDS ou simplement via un support USB.

---

## 1. Préparer le poste source (Golden Image)

Avant d'exécuter Sysprep, s'assurer que :
- Le poste est **hors domaine** (groupe de travail local)
- Toutes les mises à jour sont installées
- Les logiciels à inclure dans l'image sont installés et configurés
- Le compte local `Administrator` est activé

```powershell
# Activer le compte Administrator local
Enable-LocalUser -Name "Administrator"
Set-LocalUser -Name "Administrator" -Password (Read-Host -AsSecureString "Mot de passe Administrator")
```

---

## 2. Exécuter Sysprep

```powershell
# Lancer Sysprep en mode OOBE avec généralisation et arrêt
Start-Process -FilePath "C:\Windows\System32\Sysprep\sysprep.exe" `
    -ArgumentList "/generalize /oobe /shutdown" `
    -Wait
```

> Le système s'éteindra automatiquement. **Ne pas redémarrer manuellement**.

Options disponibles :

| Option        | Description                                           |
|---------------|-------------------------------------------------------|
| `/generalize` | Supprime les informations spécifiques au matériel     |
| `/oobe`       | Prépare Windows pour le premier démarrage utilisateur |
| `/shutdown`   | Arrête le système après la généralisation             |
| `/unattend`   | Utilise un fichier de réponse XML (déploiement avancé)|

---

## 3. Capturer l'image (optionnel — MDT/WDS)

Depuis un environnement WinPE ou MDT, capturer l'image au format WIM :

```powershell
# Exemple de capture avec DISM dans WinPE
dism /Capture-Image `
    /ImageFile:"D:\Images\NovaEnterprise-Base.wim" `
    /CaptureDir:"C:\" `
    /Name:"NovaEnterprise Base Image" `
    /Description:"Image de base Windows 11 - NovaEnterprise" `
    /Compress:fast
```

---

## 4. Automatiser la jonction au domaine post-déploiement

Utiliser un fichier de réponse `unattend.xml` ou un script exécuté au premier démarrage :

```powershell
# Script post-déploiement : jonction automatique au domaine
# À placer dans la clé de registre RunOnce ou via GPO de démarrage

$DomainName   = "novaenterprise.com"
$AdminAccount = "NOVAENTERPRISE\Administrator"
$Credential   = Get-Credential -UserName $AdminAccount -Message "Identifiants d'administration du domaine"

# Renommer le poste selon une convention (ex: WKS-001)
$NewName = "WKS-" + (Get-Random -Minimum 100 -Maximum 999)
Rename-Computer -NewName $NewName -Force

# Joindre le domaine et redémarrer
Add-Computer -DomainName $DomainName -Credential $Credential -Restart -Force
```

---

## 5. Convention de nommage des postes

| Préfixe | Type de machine        | Exemple    |
|---------|------------------------|------------|
| `WKS`   | Poste de travail       | `WKS-042`  |
| `LPT`   | Laptop                 | `LPT-007`  |
| `SRV`   | Serveur membre         | `SRV-FILE` |
| `DC`    | Contrôleur de domaine  | `DC1`      |

---

## Validation

- [ ] Image Sysprep créée et capturée avec succès
- [ ] Déploiement sur une machine test sans erreur
- [ ] Premier démarrage (OOBE) correctement configuré
- [ ] Script post-déploiement : jonction au domaine automatique
- [ ] Poste visible dans `OU_Computers` après déploiement
