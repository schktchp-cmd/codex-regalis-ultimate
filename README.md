# CODEX REGALIS ULTIME — Bazzite / Calibre

Thème chevaleresque : enluminure sur parchemin, blasons, épées croisées, heaumes, sceaux de cire, couronnes, grimoires, châteaux et ornements d'or ancien. Le logo d'application est **repris à l'identique de la version précédente approuvée**.

## Ce que contient cette version

- Un large lot d'icônes PNG avec des noms de ressources Calibre : barre d'outils, menus contextuels, préférences et leurs sous-catégories, lecteur, éditeur, navigation, boîtes de dialogue et actions courantes.
- Variantes Calibre `-for-light-theme.png` et `-for-dark-theme.png`, en plus de la version de base, afin de répondre aux conventions de Calibre 6+; un second set complet **Ordre d'Acier** est inclus comme alternative sélectionnable.
- Un remplacement de `default_cover.png` : couverture héraldique royale pour les livres sans couverture récupérable. Deux couvertures alternatives sont fournies dans `covers/`.
- Un lot d'icônes de formats (`resources/images/mimetypes/`) et d'appareils (`resources/images/devices/`). Les fichiers qui ne correspondent pas au nom d'une ressource dans ta version sont simplement ignorés par Calibre.
- Une palette Calibre `.calibre-palette`, le logo validé en plusieurs tailles, un aperçu et un inventaire CSV.
- Scripts Linux pour installer, faire une sauvegarde complète, désinstaller/annuler l'installation et installer EB Garamond sans `apt` ni privilèges administrateur.

## Installation (Bazzite avec Flatpak)

Depuis le dossier extrait :

```bash
chmod +x install.sh uninstall.sh install-police-eb-garamond.sh audit-installation.sh select-style.sh
./install.sh flatpak
flatpak kill com.calibre_ebook.calibre 2>/dev/null || true
```

Puis ouvre **Calibre — Codex Regalis Ultime** depuis le menu des applications. Le script installe d'abord dans `~/.var/app/com.calibre_ebook.calibre/config/calibre/resources/images` et crée une sauvegarde séparée pour chaque exécution.

Si ton dossier de configuration réel est différent :

```bash
CALIBRE_CONFIG_DIRECTORY='/chemin/affiché-par-Calibre' ./install.sh flatpak
```

### Choisir l'une des deux identités visuelles

Après l'installation, tu peux basculer entre les deux sets complets sans créer une nouvelle sauvegarde :

```bash
./select-style.sh parchemin  # choix principal, enluminure sur parchemin
./select-style.sh acier      # alternative Ordre d'Acier, acier sombre et argent
```

Ferme puis relance Calibre après le changement. Le logo de l'application reste le même dans les deux styles.

## Palette et police

1. Dans Calibre, ouvre **Préférences → Apparence et présentation → Ajuster les couleurs → Importer**, puis sélectionne `Codex-Regalis.calibre-palette`.
2. Pour EB Garamond, lance `./install-police-eb-garamond.sh`, ferme complètement Calibre et relance-le. Sélectionne ensuite EB Garamond dans les préférences de police.

Bazzite n'est pas une distribution Debian : ne lance pas `apt`. Le script de police l'installe uniquement pour ton compte.

## Contrôle et retour arrière

```bash
./audit-installation.sh
./uninstall.sh
```

Le script d'installation conserve les icônes remplacées dans `~/.local/share/codex-regalis-ultimate/`. `uninstall.sh` restaure les fichiers présents avant cette version et retire ceux nouvellement créés. Redémarre Calibre après l'opération.

## Couverture et limites techniques (important)

Calibre documente le remplacement d'une icône en plaçant un PNG au **même chemin et au même nom** sous `resources/images` dans son dossier de configuration. Les icônes des menus et de nombreux sous-panneaux de préférences réutilisent ces ressources, donc les fichiers principaux changent également leur représentation dans ces menus.

Le pack couvre une large sélection de noms de ressources connues et ajoute des icônes de formats courants. Il ne peut pas garantir littéralement chaque icône de chaque version de Calibre, tous les modules tiers, icônes construites dynamiquement à l'exécution, icônes du bureau système ou fichiers de thèmes fournis par des plugins. Ces éléments peuvent utiliser un nom différent ou une ressource externe. Le manifeste `INVENTAIRE-ICONES.csv` indique les fichiers inclus.

`default_cover.png` est l'image de secours utilisée par Calibre quand une couverture de livre manque. C'est distinct de la fonctionnalité qui génère des couvertures à partir des métadonnées : pour celle-ci, utilise l'action **Générer la couverture** ou un modèle de couverture personnalisé. Les alternatives dans `covers/` sont des images à choisir manuellement, elles ne sont pas automatiquement affectées aux livres existants.

## Identité visuelle

- Bleu armoiries : `#162338`
- Bordeaux : `#6F1A2A`
- Or ancien : `#CDA34E`
- Parchemin : `#E7D3A2`
- Acier : `#B1BECA`
- Titres / interface : Cinzel ou EB Garamond ; la police doit être installée séparément.
