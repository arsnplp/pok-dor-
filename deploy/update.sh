#!/usr/bin/env bash
# Met à jour le site sur le VPS depuis GitHub (à lancer en root sur le VPS).
set -euo pipefail
WEBROOT="/var/www/poke-dore.fr"
git -C "$WEBROOT" pull --ff-only
chown -R www-data:www-data "$WEBROOT"
if ! cmp -s "$WEBROOT/deploy/poke-dore.fr.conf" /etc/nginx/sites-available/poke-dore.fr; then
  echo "Config nginx modifiée dans le dépôt : à réappliquer à la main (certbot a enrichi la version installée)."
fi
echo "Site à jour."
