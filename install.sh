#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME:?HOME manquant}"
APP_ID="com.calibre_ebook.calibre"
MODE="${1:-auto}"
FLATPAK_OK=0; NATIVE_OK=0
if command -v flatpak >/dev/null 2>&1 && flatpak info "$APP_ID" >/dev/null 2>&1; then FLATPAK_OK=1; fi
if command -v calibre >/dev/null 2>&1 || command -v calibre-gui >/dev/null 2>&1 || [[ -x /opt/calibre/calibre ]]; then NATIVE_OK=1; fi
if [[ "$MODE" == auto ]]; then
  if (( FLATPAK_OK )); then MODE=flatpak; elif (( NATIVE_OK )); then MODE=native; else echo "Calibre introuvable : utilise ./install.sh flatpak ou ./install.sh native." >&2; exit 1; fi
fi
case "$MODE" in
  flatpak) (( FLATPAK_OK )) || { echo "Flatpak $APP_ID introuvable." >&2; exit 1; }; CONFIG="${CALIBRE_CONFIG_DIRECTORY:-$HOME_DIR/.var/app/$APP_ID/config/calibre}";;
  native) (( NATIVE_OK )) || { echo "Calibre natif introuvable." >&2; exit 1; }; CONFIG="${CALIBRE_CONFIG_DIRECTORY:-$HOME_DIR/.config/calibre}";;
  *) echo "Usage : ./install.sh [auto|flatpak|native]" >&2; exit 2;;
esac
[[ -d "$ROOT/resources/images" && -f "$ROOT/Codex-Regalis.calibre-palette" && -f "$ROOT/application-icon/codex-regalis-calibre.png" ]] || { echo "Archive incomplète : extrais tous les fichiers." >&2; exit 1; }
DEST="$CONFIG/resources/images"
STATE_ROOT="$HOME_DIR/.local/share/codex-regalis-ultimate"
STAMP="$(date +%Y%m%d-%H%M%S)"
if [[ "$MODE" == flatpak ]]; then STATE="$STATE_ROOT/state-flatpak-$STAMP"; else STATE="$STATE_ROOT/state-native-$STAMP"; fi
mkdir -p "$STATE/backups" "$DEST" "$STATE_ROOT" "$HOME_DIR/.local/share/icons" "$HOME_DIR/.local/share/applications" "$HOME_DIR/.local/bin"
: > "$STATE/tracked-files.txt"; : > "$STATE/existing-files.txt"; : > "$STATE/new-files.txt"
count=0
while IFS= read -r -d '' src; do
  rel="${src#"$ROOT/resources/images/"}"
  dest="$DEST/$rel"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" ]]; then
    mkdir -p "$(dirname "$STATE/backups/$rel")"; cp -p "$dest" "$STATE/backups/$rel"
    printf '%s\n' "$rel" >> "$STATE/existing-files.txt"
  else printf '%s\n' "$rel" >> "$STATE/new-files.txt"; fi
  cp -f "$src" "$dest"; printf '%s\n' "$rel" >> "$STATE/tracked-files.txt"; count=$((count+1))
done < <(find "$ROOT/resources/images" -type f -name '*.png' -print0 | sort -z)
ICON_DIR="$HOME_DIR/.local/share/icons"; ICON_DEST="$ICON_DIR/codex-regalis-calibre.png"
cp -f "$ROOT/application-icon/codex-regalis-calibre.png" "$ICON_DEST"
WRAPPER="$HOME_DIR/.local/bin/codex-regalis-calibre"
if [[ "$MODE" == flatpak ]]; then
cat > "$WRAPPER" <<WRAPPER_EOF
#!/usr/bin/env bash
exec flatpak run --env=CALIBRE_CONFIG_DIRECTORY="$CONFIG" "$APP_ID" "\$@"
WRAPPER_EOF
else
cat > "$WRAPPER" <<WRAPPER_EOF
#!/usr/bin/env bash
export CALIBRE_CONFIG_DIRECTORY="$CONFIG"
if command -v calibre >/dev/null 2>&1; then exec calibre "\$@"; fi
if command -v calibre-gui >/dev/null 2>&1; then exec calibre-gui "\$@"; fi
if [[ -x /opt/calibre/calibre ]]; then exec /opt/calibre/calibre "\$@"; fi
echo "Calibre introuvable." >&2; exit 127
WRAPPER_EOF
fi
chmod +x "$WRAPPER"
DESKTOP="$HOME_DIR/.local/share/applications/codex-regalis-calibre.desktop"
printf '[Desktop Entry]\nType=Application\nName=Calibre — Codex Regalis Ultime\nComment=Bibliothèque chevaleresque de livres numériques\nExec=%s %%U\nIcon=%s\nTerminal=false\nCategories=Office;Literature;\nStartupWMClass=calibre-gui\n' "$WRAPPER" "$ICON_DEST" > "$DESKTOP"
cp -f "$ROOT/Codex-Regalis.calibre-palette" "$STATE_ROOT/Codex-Regalis.calibre-palette"
printf '%s\n' "$CONFIG" > "$STATE/config-dir.txt"
printf '%s\n' "$MODE" > "$STATE/mode.txt"
printf '%s\n' "$DESKTOP" > "$STATE/desktop-path.txt"
printf '%s\n' "$WRAPPER" > "$STATE/wrapper-path.txt"
printf '%s\n' "$ICON_DEST" > "$STATE/icon-path.txt"
printf '%s\n' "$STATE" > "$STATE_ROOT/active-state-dir.txt"
echo "Mode : $MODE"
echo "Dossier de configuration : $CONFIG"
echo "Ressources installées : $count fichiers PNG (icônes, sous-menus, préférences, formats et couvertures)"
echo "Sauvegarde de cette installation : $STATE/backups"
echo "Lanceur : $DESKTOP"
echo
echo "Ferme complètement Calibre, puis relance-le avec ‘Calibre — Codex Regalis Ultime’."
if [[ "$MODE" == flatpak ]]; then echo "Commande de fermeture : flatpak kill $APP_ID"; fi
echo "Importe la palette dans Préférences > Apparence et présentation > Ajuster les couleurs > Importer."
echo "Les polices ne sont pas incluses; utilise install-police-eb-garamond.sh si nécessaire."
