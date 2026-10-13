# Sources & conventions

- Guide officiel de personnalisation Calibre : les ressources statiques peuvent être remplacées dans le dossier de configuration sous `resources/images`; les icônes clair/sombre utilisent les suffixes `-for-light-theme` et `-for-dark-theme`.
  https://github.com/kovidgoyal/calibre/blob/master/manual/customize.rst
- Les noms des icônes de catégories des préférences proviennent des définitions de plugins incluses dans Calibre (`builtins.py`), par exemple `lookfeel.png`, `config.png`, `column.png`, `wizard.png`, `arrow-down.png`, `convert.png`, `arrow-up.png`, `add_book.png`, `save.png`, `sync.png`, `plugboard.png`, `template_funcs.png`, `mail.png`, `network-server.png`, `download-metadata.png`, `reader.png`, `plugins.png`, `tweaks.png`, `keyboard-prefs.png`, `exec.png`.
  https://github.com/kovidgoyal/calibre/blob/master/src/calibre/customize/builtins.py
- Calibre utilise `default_cover.png` pour certaines vues où un livre n'a pas de couverture disponible.
  https://github.com/kovidgoyal/calibre/blob/master/src/calibre/gui2/library/models.py

Le pack est une création indépendante du thème. Il n'est pas officiel et n'est pas affilié à l'équipe Calibre.
