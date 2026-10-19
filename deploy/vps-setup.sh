#!/usr/bin/env bash
# Installation initiale du VPS pour poke-dore.fr (Ubuntu/Debian, à lancer en root).
# Usage : CERTBOT_EMAIL=vous@exemple.fr bash vps-setup.sh
set -euo pipefail

DOMAIN="poke-dore.fr"
WEBROOT="/var/www/$DOMAIN"
REPO="https://github.com/arsnplp/pok-dor-.git"

echo "== 1. Paquets"
apt-get update
apt-get install -y nginx certbot python3-certbot-nginx git ufw

echo "== 2. Dossier du site : clone (ou mise à jour) du dépôt"
if [ ! -d "$WEBROOT/.git" ]; then
  git clone "$REPO" "$WEBROOT"
else
  git -C "$WEBROOT" pull --ff-only
fi
chown -R www-data:www-data "$WEBROOT"
find "$WEBROOT" -type d -exec chmod 755 {} \;
find "$WEBROOT" -type f -exec chmod 644 {} \;

echo "== 3. Nginx"
cp "$WEBROOT/deploy/$DOMAIN.conf" "/etc/nginx/sites-available/$DOMAIN"
ln -sf "/etc/nginx/sites-available/$DOMAIN" "/etc/nginx/sites-enabled/$DOMAIN"
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx

echo "== 4. Pare-feu"
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw --force enable

echo "== 5. HTTPS (Let's Encrypt) — le DNS doit déjà pointer vers ce VPS"
certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos --redirect -m "${CERTBOT_EMAIL:?Définir CERTBOT_EMAIL}"
systemctl enable --now certbot.timer 2>/dev/null || true

echo
echo "Terminé : https://$DOMAIN"
echo "Mise à jour ultérieure : bash $WEBROOT/deploy/update.sh"
