# Mise en ligne de poke-dore.fr sur le VPS

Site statique (HTML/CSS, aucun build). Le VPS sert directement le dépôt cloné dans `/var/www/poke-dore.fr`.

## 1. DNS (chez le registrar de poke-dore.fr)

| Type | Nom | Valeur |
|------|-----|--------|
| A | @ | IP du VPS |
| A | www | IP du VPS |

Attendre quelques minutes que ça se propage (`dig +short poke-dore.fr`).

## 2. Pousser le code sur GitHub

Le script clone `https://github.com/arsnplp/pok-dor-.git`. Les dernières modifications (nouveau domaine) doivent être commitées et poussées avant.

## 3. Sur le VPS (en root)

```bash
curl -fsSL https://raw.githubusercontent.com/arsnplp/pok-dor-/main/deploy/vps-setup.sh -o vps-setup.sh
CERTBOT_EMAIL=vous@exemple.fr bash vps-setup.sh
```

Le script installe nginx + certbot, clone le site, active la config, ouvre le pare-feu et obtient le certificat HTTPS (avec redirection http → https et www → sans www).

## 4. Mises à jour suivantes

Après un `git push` depuis le Mac :

```bash
bash /var/www/poke-dore.fr/deploy/update.sh
```

## Vérifications

- `curl -I https://poke-dore.fr` → `200`
- `curl -I https://www.poke-dore.fr` → `301` vers `https://poke-dore.fr/`
- `curl -I http://poke-dore.fr` → `301` vers HTTPS
- `https://poke-dore.fr/deploy/README.md` → `404`
