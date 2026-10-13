#!/usr/bin/env bash
set -euo pipefail
STATE_ROOT="$HOME/.local/share/codex-regalis-ultimate"
STATE="${1:-}"
if [[ -z "$STATE" && -f "$STATE_ROOT/active-state-dir.txt" ]]; then STATE="$(cat "$STATE_ROOT/active-state-dir.txt")"; fi
if [[ -z "$STATE" || ! -d "$STATE" ]]; then echo "Aucun état Codex Regalis Ultime trouvé."; exit 0; fi
CONFIG="$(cat "$STATE/config-dir.txt" 2>/dev/null || true)"
[[ -n "$CONFIG" ]] || { echo "Dossier de configuration inconnu; abandon." >&2; exit 1; }
DEST="$CONFIG/resources/images"
if [[ -f "$STATE/existing-files.txt" ]]; then
  while IFS= read -r rel; do [[ -n "$rel" ]] || continue; backup="$STATE/backups/$rel"; if [[ -f "$backup" ]]; then mkdir -p "$(dirname "$DEST/$rel")"; cp -p "$backup" "$DEST/$rel"; fi; done < "$STATE/existing-files.txt"
fi
if [[ -f "$STATE/new-files.txt" ]]; then
  while IFS= read -r rel; do [[ -n "$rel" ]] || continue; rm -f "$DEST/$rel"; done < "$STATE/new-files.txt"
fi
rm -f "$HOME/.local/share/applications/codex-regalis-calibre.desktop" "$HOME/.local/bin/codex-regalis-calibre"
# Keep approved application icon in place only if another Codex launcher/version may use it; remove it if installed by this pack.
rm -f "$HOME/.local/share/icons/codex-regalis-calibre.png"
if command -v update-desktop-database >/dev/null 2>&1; then update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true; fi
if [[ -f "$STATE_ROOT/active-state-dir.txt" && "$(cat "$STATE_ROOT/active-state-dir.txt")" == "$STATE" ]]; then rm -f "$STATE_ROOT/active-state-dir.txt"; fi
echo "Restauration effectuée depuis : $STATE"
echo "Sauvegardes conservées dans : $STATE/backups"
echo "Redémarre Calibre pour voir le retour arrière."
