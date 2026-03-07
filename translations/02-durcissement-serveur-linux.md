# Durcissement de Serveur et de Poste Linux en Environnement à Ressources Limitées

## Pourquoi c'est essentiel au Sénégal

Les infrastructures critiques tournent souvent sur des serveurs Linux anciens ou peu maintenus, pour plusieurs raisons :
- **Connectivité intermittente** : les mises à jour sont retardées.
- **Budget et matériel limités** : pas de budget pour des outils commerciaux ni des redémarrages fréquents.
- **Menaces courantes** : rançongiciels (exemple : l'attaque récente contre la DAF), hameçonnage menant à un accès initial, attaques par force brute sur SSH.

**Objectif :** Réduire la surface d'attaque — sans dépendances lourdes, fonctionne hors ligne après la configuration initiale.

**Distributions cibles** (répandues au Sénégal et dans le secteur public) :
- Debian 11/12 ou Ubuntu LTS (largement utilisées, stables, communauté francophone active).
- Rocky Linux 8/9 ou AlmaLinux (compatibles RHEL, stabilité de niveau entreprise).

**Testez toujours sur une VM hors production en premier !**

---

## 1. Mises à jour et gestion des correctifs

Les correctifs comblent les vulnérabilités connues — faites-le régulièrement, même en mode hors ligne.

**Debian/Ubuntu :**
```bash
sudo apt update && sudo apt full-upgrade -y
sudo apt autoremove --purge
sudo apt autoclean
```

**Rocky/AlmaLinux :**
```bash
sudo dnf update -y
sudo dnf autoremove
sudo dnf clean all
```

**Conseil basse connectivité :**
Utilisez `apt-offline` (Debian/Ubuntu) ou téléchargez les RPM sur une autre machine et transférez-les par clé USB. Planifiez via cron (hebdomadaire si la connectivité le permet) :
```bash
# Exemple cron (éditer /etc/crontab) :
@weekly root apt update && apt upgrade -y
```

**Activer les mises à jour de sécurité automatiques (faible risque sur les serveurs) :**
- **Debian/Ubuntu** : Installez `unattended-upgrades` et configurez `/etc/apt/apt.conf.d/50unattended-upgrades`.
- **Rocky** : Utilisez `dnf-automatic`.

---

## 2. Désactiver les services inutiles (réduire la surface d'attaque)

Lister les services actifs :
```bash
systemctl list-units --type=service
```

Désactiver les risques courants (si non nécessaires — vérifiez d'abord votre charge de travail) :
```bash
sudo systemctl disable --now avahi-daemon      # Découverte mDNS
sudo systemctl disable --now cups              # Impression
sudo systemctl disable --now bluetooth
sudo systemctl mask rpcbind                    # RPC (souvent exploité)
```

**Pour les serveurs web :** Désactivez si inutilisés — `apache2`/`httpd`, `nginx`.

---

## 3. Pare-feu — Refus par défaut, ouverture au minimum

Utilisez l'outil par défaut de la distribution.

**Option A : UFW (Debian/Ubuntu — très simple) :**
```bash
sudo apt install ufw   # si absent
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH          # ou : sudo ufw allow 22/tcp
# Application spécifique : sudo ufw allow 'Apache Full' ou sudo ufw allow 80,443/tcp
sudo ufw enable
sudo ufw status verbose
```

**Option B : firewalld (Rocky/AlmaLinux — plus flexible avec les zones) :**
```bash
sudo dnf install firewalld   # si nécessaire
sudo systemctl enable --now firewalld

# La zone par défaut est généralement 'public'
sudo firewall-cmd --permanent --zone=public --add-service=ssh
# Serveur web : --add-service=http --add-service=https
# Ou par port : --add-port=8080/tcp

# Avancé : zone personnalisée pour réseau interne (multi-interfaces)
sudo firewall-cmd --permanent --new-zone=interne
sudo firewall-cmd --permanent --zone=interne --add-source=192.168.1.0/24
sudo firewall-cmd --permanent --zone=interne --add-service=ssh

sudo firewall-cmd --reload
sudo firewall-cmd --list-all
```

**Conseil :**
Sur ressources très limitées, préférez `ufw` (famille Debian). `firewalld` consomme plus de mémoire mais gère mieux les changements dynamiques (pas de redémarrage nécessaire).

**nftables (remplacement moderne d'iptables) :**
```bash
sudo nft add rule inet filter input tcp dport ssh accept
sudo nft add rule inet filter input drop
```

---

## 4. Durcissement SSH (vecteur d'attaque fréquent)

Éditez `/etc/ssh/sshd_config` (faites une sauvegarde d'abord) :
```
PermitRootLogin no
PasswordAuthentication no          # Privilégiez les clés
PubkeyAuthentication yes
MaxAuthTries 3
LoginGraceTime 30
```

Redémarrez : `sudo systemctl restart sshd`

Utilisez l'authentification par clé et désactivez les mots de passe si possible (générez des clés avec `ssh-keygen -t ed25519`).

Installez Fail2Ban (bloqueur de force brute léger) :
```bash
# Debian/Ubuntu :
sudo apt install fail2ban
# Rocky :
sudo dnf install fail2ban
sudo systemctl enable --now fail2ban
```

---

## 5. Gestion des utilisateurs et des accès

- Créez un utilisateur administrateur non-root pour le travail quotidien.
- Imposez des mots de passe robustes : éditez `/etc/security/pwquality.conf` (`minlen=12`, `dcredit=-1`, etc.).
- Verrouillez les comptes inutilisés : `sudo passwd -l ancien_utilisateur`

---

## 6. Outils d'audit et de surveillance gratuits (faible consommation)

**Lynis** (excellent audit, fonctionne hors ligne après installation) — lancez-le chaque semaine et examinez les recommandations :
```bash
# Debian/Ubuntu :
sudo apt install lynis
# Rocky :
sudo dnf install lynis

sudo lynis audit system
```

**ClamAV** pour un scan antivirus de base (clés USB, fichiers hors ligne).

---

## 7. Contrôle d'accès obligatoire (MAC) — Contrôle d'exécution

Empêche les processus compromis d'accéder à des fichiers ou réseaux non autorisés, même s'ils s'exécutent en root.

### Debian/Ubuntu — AppArmor (activé par défaut, basé sur les chemins, plus simple)

Vérifiez l'état : `aa-status`

Mettre en mode enforcing :
```bash
sudo aa-enforce /etc/apparmor.d/*          # Appliquer tous les profils par défaut
sudo aa-enforce /usr/sbin/apache2          # Exemple pour Apache/Nginx
```

Créer un profil personnalisé :
Utilisez `aa-genprof /chemin/vers/binaire` (mode apprentissage interactif — commencez en complain).
Éditez `/etc/apparmor.d/usr.bin.monapp` et ajoutez les règles :
```
/usr/bin/monapp {
  #include <abstractions/base>
  /etc/monapp/** r,
  /var/log/monapp/** w,
  deny /etc/passwd r,   # Bloquer l'accès aux fichiers sensibles
  network inet stream,
}
```

Rechargez : `sudo apparmor_parser -r /etc/apparmor.d/usr.bin.monapp`
Passez en enforcing : `sudo aa-enforce /etc/apparmor.d/usr.bin.monapp`

### Rocky/AlmaLinux — SELinux (activé par défaut en mode enforcing, basé sur les étiquettes)

Vérifiez : `getenforce` ou `sestatus`

Passer/confirmer le mode enforcing :
```bash
sudo setenforce 1                          # Temporaire
# Permanent : éditez /etc/selinux/config → SELINUX=enforcing
reboot
```

Restaurer les contextes en cas de problème : `sudo restorecon -Rv /var/www`

Consulter les refus : `sudo ausearch -m avc -ts recent`

Politique personnalisée (avancé) : utilisez `audit2allow` pour créer des modules à partir des journaux.

Activer les booléens pour Apache/Nginx/Postfix si nécessaire :
```bash
sudo setsebool -P httpd_can_network_connect 1
```

**Recommandation pour le Sénégal :**
Utilisez le MAC par défaut de la distribution (AppArmor sur la famille Debian pour la simplicité ; SELinux sur Rocky pour un contrôle plus strict). Commencez en mode permissif si vous testez, puis passez en enforcing.

---

## 8. Chiffrement du disque (protection des données au repos)

Essentiel en cas de vol physique, de perte ou de récupération forensique après une intrusion. Utilisez LUKS (intégré, standardisé, faible surcharge avec AES-NI).

**Pourquoi c'est important au Sénégal :** Protège les données sensibles (dossiers citoyens, données financières) en cas de vol ou de perte du matériel. Impact minimal sur les performances avec un CPU moderne.

**À la configuration (recommandé) :** La plupart des installeurs (Debian/Rocky) proposent l'option LUKS + LVM — chiffrez les partitions racine et données.

**Sur un système existant (avancé — sauvegardez d'abord) :**

Pour une nouvelle partition (`/dev/sdb1` par exemple) :
```bash
sudo cryptsetup luksFormat /dev/sdb1          # Définissez une phrase secrète robuste
sudo cryptsetup luksOpen /dev/sdb1 disque_chiffre
sudo mkfs.ext4 /dev/mapper/disque_chiffre
sudo mount /dev/mapper/disque_chiffre /mnt
```

Déverrouillage automatique au démarrage : ajoutez dans `/etc/crypttab` et mettez à jour initramfs (`update-initramfs -u` sur Debian ; `dracut -f` sur Rocky).

**Bonnes pratiques :**
- Phrase secrète longue (20+ caractères) ou fichier de clé (stocké en lieu sûr ou sur clé USB).
- Sauvegarder l'en-tête LUKS : `cryptsetup luksHeaderBackup /dev/sdb1 --header-backup-file entete.backup`
- Chiffrez aussi le swap pour éviter les fuites de données.
- Testez la récupération : redémarrez et déverrouillez manuellement.

**Note sur les ressources limitées :**
La surcharge LUKS est de 5 à 10 % en I/O sur les SSD ; négligeable sur le matériel moderne. À éviter sur des disques très anciens/lents si les performances sont critiques.

---

## Références

- AppArmor : https://wiki.ubuntu.com/AppArmor (guide Debian/Ubuntu)
- SELinux : https://docs.rockylinux.org/guides/security/learning_selinux/
- LUKS/cryptsetup : https://wiki.debian.org/cryptsetup ou `man cryptsetup`
- Benchmarks CIS (PDFs gratuits) : Debian / Rocky Linux
