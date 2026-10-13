#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
STATE_ROOT="$HOME/.local/share/codex-regalis-ultimate"
ACTIVE="$STATE_ROOT/active-state-dir.txt"
[[ -f "$ACTIVE" ]] || { echo "Installe d'abord Codex Regalis Ultime avec ./install.sh flatpak." >&2; exit 1; }
STATE="$(cat "$ACTIVE")"
[[ -f "$STATE/config-dir.txt" ]] || { echo "Dossier d'installation introuvable." >&2; exit 1; }
CONFIG="$(cat "$STATE/config-dir.txt")"
STYLE="${1:-}"
case "$STYLE" in
  parchemin) SRC="$ROOT/resources/images"; LABEL="Parchemin royal";;
  acier) SRC="$ROOT/alternatives/Ordre-dAcier/resources/images"; LABEL="Ordre d'Acier";;
  *) echo "Usage : ./select-style.sh [parchemin|acier]" >&2; exit 2;;
esac
[[ -d "$SRC" ]] || { echo "Ressources du style absentes : $SRC" >&2; exit 1; }
DEST="$CONFIG/resources/images"; count=0
while IFS= read -r -d '' file; do rel="${file#"$SRC/"}"; mkdir -p "$(dirname "$DEST/$rel")"; cp -f "$file" "$DEST/$rel"; count=$((count+1)); done < <(find "$SRC" -type f -name '*.png' -print0)
echo "Style appliqué : $LABEL ($count fichiers). Ferme et relance Calibre."
echo "La sauvegarde initiale n'a pas été modifiée; ./uninstall.sh restaure l'état précédent à l'installation."
