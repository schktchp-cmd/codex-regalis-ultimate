#!/usr/bin/env bash
set -euo pipefail
APP_ID="com.calibre_ebook.calibre"
URL='https://raw.githubusercontent.com/google/fonts/main/ofl/ebgaramond/EBGaramond%5Bwght%5D.ttf'
command -v curl >/dev/null 2>&1 || { echo "curl est nécessaire; aucune modification effectuée." >&2; exit 1; }
HOST_DIR="$HOME/.local/share/fonts/codex-regalis-ultimate"
mkdir -p "$HOST_DIR"
FONT="$HOST_DIR/EBGaramond[wght].ttf"
if [[ ! -s "$FONT" ]]; then curl -fL --retry 2 "$URL" -o "$FONT"; fi
if command -v fc-cache >/dev/null 2>&1; then fc-cache -f "$HOST_DIR" >/dev/null 2>&1 || true; fi
if command -v fc-match >/dev/null 2>&1; then echo "Reconnaissance côté système : $(fc-match 'EB Garamond' | head -1)"; fi
if command -v flatpak >/dev/null 2>&1 && flatpak info "$APP_ID" >/dev/null 2>&1; then
  DATA="$HOME/.var/app/$APP_ID/data"; FDIR="$DATA/fonts/codex-regalis-ultimate"; CACHE="$HOME/.var/app/$APP_ID/cache"
  mkdir -p "$FDIR" "$CACHE"; cp -f "$FONT" "$FDIR/EBGaramond[wght].ttf"
  if command -v fc-cache >/dev/null 2>&1; then XDG_DATA_HOME="$DATA" XDG_CACHE_HOME="$CACHE" fc-cache -f "$FDIR" >/dev/null 2>&1 || true; fi
  if command -v flatpak >/dev/null 2>&1; then
    echo "Police copiée pour Calibre Flatpak : $FDIR"
    echo "Contrôle facultatif : flatpak run --command=sh $APP_ID -c \"fc-match 'EB Garamond'\""
  fi
fi
echo "EB Garamond installée pour l'utilisateur. Ferme complètement Calibre, puis rouvre-le."
echo "Dans Calibre : Préférences > Apparence et présentation > Police de l'interface principale."
echo "Si elle n'apparaît pas, vérifie d'abord le nom avec fc-match 'EB Garamond'."
