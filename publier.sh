#!/bin/bash
# Met en ligne le BACKOFFICE (CRM) sur admin.locallegend.fr (depot GitHub "locallegend-admin", GitHub Pages).
# Les sources sont dans /Users/jules/Audit/local-legend-admin (index.html + robots.txt). Rien de secret dedans : la cle Supabase est la cle publique
# du jeu, et toutes les donnees sont protegees cote serveur (is_admin()). Voir /Users/jules/Audit/GUIDE-ADMIN.md pour la mise en place.
# Usage : bash publier.sh
set -e
cd "$(dirname "$0")"
SRC=/Users/jules/Audit/local-legend-admin
REMOTE=https://github.com/meiji-dotcom/locallegend-admin.git
if [ ! -d .git ]; then
  git init -b main
  git remote add origin "$REMOTE"
fi
rsync -a --delete --exclude '.git' --exclude 'publier.sh' --exclude '.nojekyll' --exclude 'CNAME' \
  --include 'index.html' --include 'robots.txt' --include 'circuits.json' --exclude '*' "$SRC/" ./
touch .nojekyll
echo "admin.locallegend.fr" > CNAME # GitHub Pages : le nom de domaine du backoffice
git add -A
# on remplace le dernier envoi au lieu d'en empiler un nouveau
if git rev-parse HEAD >/dev/null 2>&1; then
  git commit --amend -m "Local Legend backoffice" --allow-empty
  git push --force origin HEAD:main
else
  git commit -m "Local Legend backoffice"
  git push -u origin HEAD:main
fi
echo "Envoye. Le site se met a jour en 1 a 2 minutes : https://admin.locallegend.fr"
