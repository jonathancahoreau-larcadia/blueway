# blueway

## Développement

Depuis le dossier `mobile/` :

```bash
flutter pub get
flutter devices
flutter run -d <device-id>
```

Remplacer `<device-id>` par l’identifiant affiché par `flutter devices`.

## Configuration de l’API

Lorsque le backend sera disponible :

```bash
flutter run -d <device-id> --dart-define=API_BASE_URL=https://adresse-du-backend/
```

Remplacer l’URL par celle du backend accessible depuis l’appareil.

L’écran des signalements utilise actuellement des données fictives.
Le service HTTP est préparé et testé, mais n’est pas encore connecté à cet écran.

## Vérifications

```bash
flutter analyze
flutter test
```
