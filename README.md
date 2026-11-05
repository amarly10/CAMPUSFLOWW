# CampusFlow

## Lancer le projet
1. Dézipper le dossier, puis ouvrir un terminal dedans.
2. Générer les dossiers Android / iOS / Web (ne touche pas à `lib/`) :
   ```
   flutter create .
   ```
3. Installer les packages et lancer sur l'émulateur :
   ```
   flutter pub get
   flutter run
   ```
4. Enregistrer les dossiers générés :
   ```
   git add .
   git commit -m "Ajout des dossiers plateformes"
   ```

## Contenu
- `lib/main.dart` : thème, écran de titre, Échéances, Détail, Formulaire, mode tablette (≥ 840 dp)
- `assets/images/logo.png` : image déclarée dans `pubspec.yaml`
- Package : `intl` (format des dates)
- Historique Git : voir `git log`
