# BlueWay mobile

## Développement

Depuis le dossier `mobile/` :

```bash
flutter pub get
flutter devices
flutter run -d <device-id> --dart-define-from-file=.env.json
```

Remplacer `<device-id>` par l’identifiant affiché par `flutter devices`.

## Configuration locale

Créer le fichier local depuis l’exemple :

```bash
cp .env.example.json .env.json
```

Compléter ensuite les trois valeurs :

```json
{
  "MAPBOX_ACCESS_TOKEN": "jeton-public-mapbox",
  "MAPTILER_STYLE_URL": "https://api.maptiler.com/maps/ocean-v4/style.json?key=cle-maptiler",
  "API_BASE_URL": "https://adresse-du-backend/"
}
```

`API_BASE_URL` doit se terminer par `/`. Pour un backend lancé sur le poste de
développement, utiliser :

- Android Emulator : `http://10.0.2.2:8000/`
- simulateur iOS : `http://127.0.0.1:8000/`
- téléphone physique : `http://<adresse-ip-du-poste>:8000/`

Le téléphone physique et le poste doivent être sur le même réseau. Une
modification de `.env.json` nécessite un redémarrage complet de `flutter run`.
Le fichier `.env.json` ne doit jamais être ajouté à Git.

## Authentification et profil — BLU-51

L’application utilise Firebase Authentication avec le fournisseur
e-mail/mot de passe.

Le parcours comprend :

- la création du compte ;
- l’envoi et la vérification automatique de l’adresse e-mail ;
- la connexion et la déconnexion ;
- la transmission du token Firebase au backend ;
- la création d’un profil avec un nom d’utilisateur unique ;
- la récupération du profil existant sans création implicite.

Les fichiers Firebase Android et iOS sont versionnés. Après un clone,
`flutter pub get` suffit pour utiliser la configuration existante.

Firebase CLI et FlutterFire CLI servent uniquement à modifier ou régénérer
cette configuration.

Sur macOS :

```bash
brew install firebase-cli
dart pub global activate flutterfire_cli
gem install xcodeproj
```

Sur Windows :

```powershell
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

Pour régénérer la configuration :

```bash
firebase login
flutterfire configure \
  --project=blueway-dev \
  --platforms=android,ios \
  --android-package-name=fr.blueway.app \
  --ios-bundle-id=fr.blueway.app
```

Le projet de développement est `blueway-dev` et l’identifiant des applications
est `fr.blueway.app`. Les fichiers `.env`, les clés privées Firebase Admin et
les mots de passe ne doivent jamais être ajoutés à Git.

La connexion Google, la connexion Apple et la récupération du mot de passe ne
font pas partie de BLU-51.

## Récupération du mot de passe — BLU-52

Depuis la connexion, « Mot de passe oublié ? » permet de demander un lien de
réinitialisation. L’adresse déjà saisie est préremplie. Firebase envoie le
courriel et héberge la page où l’utilisateur choisit son nouveau mot de passe.
L’application affiche les erreurs de saisie et de réseau, puis permet de
revenir à la connexion.

Aucun mot de passe n’est enregistré dans PostgreSQL. Si le courriel n’arrive
pas, vérifier aussi les courriers indésirables.

## Vérifications

```bash
dart format lib test
flutter analyze
flutter test
```

## Carte maritime et localisation

La carte utilise :

- le SDK Mapbox pour l’affichage et les interactions ;
- le style Mapbox Standard pour le fond ;
- Geolocator pour récupérer la position de l’appareil.

L’écran permet de demander la permission de localisation, d’afficher la
position en degrés décimaux, et de recentrer la carte. Déplacer la carte ne
modifie pas la dernière position GPS affichée.

## Signalement manuel — BLU-54

Depuis la carte, le bouton `+` ouvre un formulaire avec trois catégories et un
commentaire facultatif de 250 caractères maximum. Déplacer la carte sous le
repère choisit la position. La publication envoie le token Firebase à
`POST /api/v1/reports` avec un point GeoJSON `[longitude, latitude]`, la date
du signalement et un `client_report_id` UUID. Un nouvel essai sans modification
réutilise le même identifiant pour éviter les doublons.

L’API locale doit inclure l’endpoint backend de BLU-104 pour tester la
publication sur téléphone ; une ancienne version du backend répondra 404.

## Prototype caméra et capteurs — BLU-55

Le prototype permet de :

- afficher et capturer l’aperçu de la caméra arrière ;
- afficher la position GPS et sa précision ;
- bloquer la capture lorsque la précision dépasse 50 mètres ;
- mesurer l’azimut, l’inclinaison et l’altitude ;
- figer les mesures associées au moment de la capture.

### Limites connues

- l’azimut dépend des perturbations magnétiques et de la calibration ;
- l’inclinaison n’a pas été vérifiée avec un support d’angle étalonné ;
- les conventions des capteurs doivent encore être validées sur Android réel ;
- la précision verticale ne suffit pas seule à calculer une position ;
- la photo reste dans le stockage temporaire de l’application.
