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

## Prototype caméra et capteurs — BLU-55

L’écran de prototype permet de :

- afficher l’aperçu de la caméra arrière ;
- demander et expliquer les permissions nécessaires ;
- afficher la position GPS et sa précision ;
- bloquer la capture lorsque la précision GPS dépasse 50 mètres ;
- mesurer l’azimut par rapport au nord vrai ;
- calculer l’inclinaison de la visée avec le pitch et le roulis ;
- afficher l’altitude et sa précision verticale ;
- figer les mesures associées au moment de la capture.

### Validation sur iPhone physique

Les essais ont confirmé :

- un aperçu et une capture fonctionnels ;
- une précision GPS horizontale d’environ 6 mètres pendant le test ;
- un azimut qui évolue avec l’orientation du téléphone ;
- une inclinaison cohérente vers le ciel, l’horizon et le sol ;
- une altitude de 44,9 mètres avec une incertitude de ±30 mètres ;
- le blocage de la capture lorsque la localisation précise est désactivée.

### Limites connues

- l’azimut est sensible aux perturbations magnétiques et à la calibration ;
- l’inclinaison a été vérifiée à main levée, sans support d’angle étalonné ;
- les conventions des capteurs doivent encore être validées sur Android physique ;
- la précision verticale est insuffisante pour utiliser seule l’altitude dans un calcul de position ;
- iOS fournit une altitude liée au niveau moyen de la mer, tandis qu’Android fournit généralement une altitude relative à l’ellipsoïde WGS84 ;
- la photo du prototype reste dans le stockage temporaire de l’application.
