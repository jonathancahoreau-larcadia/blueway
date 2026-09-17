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
## Carte maritime et localisation

La carte utilise :

- le SDK Mapbox pour l’affichage et les interactions ;
- le style MapTiler Ocean pour le fond maritime ;
- Geolocator pour récupérer la position de l’appareil.

### Configuration

Copier le fichier d’exemple :

```bash
cp .env.example.json .env.json
```

Compléter `.env.json` avec les accès Mapbox et MapTiler :

```json
{
  "MAPBOX_ACCESS_TOKEN": "jeton-public-mapbox",
  "MAPTILER_STYLE_URL": "https://api.maptiler.com/maps/ocean-v4/style.json?key=cle-maptiler"
}
```

Le fichier `.env.json` ne doit pas être ajouté à Git.

### Lancement

```bash
flutter run -d <device-id> --dart-define-from-file=.env.json
```

### Localisation

L’écran de carte permet de :

- demander la permission de localisation ;
- afficher la position en degrés, minutes et secondes ;
- recentrer la carte sur la dernière position obtenue ;
- déplacer et zoomer la carte sans modifier la position GPS affichée ;
- expliquer les permissions refusées, le GPS désactivé ou une position indisponible.

Les coordonnées destinées au backend restent en degrés décimaux. Le format DMS sert uniquement à l’affichage.
