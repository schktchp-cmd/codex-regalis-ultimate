#!/usr/bin/env bash
set -euo pipefail
APP_ID="com.calibre_ebook.calibre"
CFG="${CALIBRE_CONFIG_DIRECTORY:-$HOME/.var/app/$APP_ID/config/calibre}"
if [[ ! -d "$CFG/resources/images" ]]; then echo "Dossier d'icônes non trouvé : $CFG/resources/images" >&2; exit 1; fi
echo "Configuration : $CFG"
echo "Icônes du pack présentes : $(find "$CFG/resources/images" -type f -name '*.png' | wc -l)"
echo "Fichiers remplacés par Codex Regalis Ultime (si installé via install.sh) :"
STATE="${1:-}"
if [[ -z "$STATE" && -f "$HOME/.local/share/codex-regalis-ultimate/active-state-dir.txt" ]]; then STATE="$(cat "$HOME/.local/share/codex-regalis-ultimate/active-state-dir.txt")"; fi
if [[ -n "$STATE" && -f "$STATE/tracked-files.txt" ]]; then wc -l "$STATE/tracked-files.txt"; else echo "Passe le dossier d'état en argument pour afficher le manifeste de l'installation."; fi
