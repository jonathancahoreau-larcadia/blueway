# Service de base de données BlueWay

Ce lot implémente uniquement PostgreSQL/PostGIS et ses migrations. Le code se trouve dans
`backend/app/infrastructure/database`, conformément à l'emplacement infrastructure du backend.
Aucun serveur FastAPI, worker FCM, stockage de photos ou frontend n'est créé.

La référence est le document fourni ` Technical-Documentation-escali.docx`. Le
[schéma PDF corrigé](BlueWay_Database_Schema.pdf) conserve les dix tables, les 99 champs et
les 14 clés étrangères. Les trois renvois aux pages absentes 12–13 ont été remplacés et
les règles détaillées sont maintenant incluses aux pages 4–5.
[Le rapport de comparaison](document-comparison.json) contient les empreintes des sources
et le décompte vérifié pour chaque table. Le Word n'a pas été modifié.

## Démarrer uniquement la base

Depuis la racine du dépôt, avec Docker Compose et Python 3.9 ou plus :

```sh
python3 -m venv .venv
.venv/bin/pip install -r backend/app/infrastructure/database/requirements.txt
export BLUEWAY_DB_PASSWORD='un-mot-de-passe-local-a-vous'
docker compose -f compose.database.yml -p blueway-database up -d --wait
export DATABASE_URL='postgresql://blueway:un-mot-de-passe-local-a-vous@127.0.0.1:55432/blueway'
.venv/bin/python backend/app/infrastructure/database/migrate.py up
```

Encoder le mot de passe dans l'URL s'il contient des caractères réservés.
Compose accepte aussi un fichier `.env` ignoré par Git ; un fichier local a été créé
pour la validation. Il contient le mot de passe et le port, jamais les données métier.
Le port est limité à `127.0.0.1`. L'image est figée par digest et utilise `linux/amd64`
(émulation Docker sur Mac Apple Silicon). Le volume `blueway_database` conserve les données.
Les migrations sont explicites, indépendantes de l'initialisation du volume.

```sh
docker compose -f compose.database.yml -p blueway-database stop
```

`up -d --wait` redémarre le service en conservant les données. Ne pas utiliser `down -v`
pour un simple arrêt : cela supprime le volume.

## Migrations

`001_schema.up.sql` active PostGIS et crée les dix tables dans le schéma `blueway`.
L'application doit qualifier ses tables (`blueway.reports`) ou configurer son
`search_path` sur `blueway,public`. `public` contient l'extension PostGIS.
Une table technique `blueway_meta.schema_migrations`, séparée des dix tables métier,
stocke les versions et empreintes SHA-256.

Le lanceur sérialise les migrations par verrou transactionnel, refuse une migration
appliquée modifiée ou manquante, et applique les nouvelles migrations dans une transaction.
Un deuxième `up` ne modifie rien. Une erreur annule DDL et journal ensemble.
Ne jamais modifier une migration déjà appliquée : ajouter une nouvelle paire `.up.sql` / `.down.sql`.

Le rollback supprime les données métier de cette migration et exige un indicateur explicite :

```sh
.venv/bin/python backend/app/infrastructure/database/migrate.py down --allow-data-loss
```

Il conserve PostGIS et le journal technique. Les objets sont supprimés explicitement,
sans `DROP SCHEMA ... CASCADE`, afin de ne pas effacer silencieusement des dépendances externes.

## Contraintes couvertes

- Types et nullabilité des 99 champs, dix PK, 14 FK, unicités simples et composites.
- Valeurs autorisées, défauts documentés, versions positives, tentatives non négatives.
- Mesures finies, GPS 0–50 m, azimut et cap dans `[0,360[`, hauteur positive, bornes des mesures facultatives.
- Métadonnées JPEG : taille 1–500000 octets et `image/jpeg` ; état uploaded avec clé, taille, MIME et date.
- Géographies `Point,4326` non vides, GiST sur les deux colonnes requises, quatre index de recherche complémentaires.
- Expiration égale à observation + 24 heures, durée d'origine immuable, auteur requis à l'insertion puis nullable uniquement après suppression du compte.
- Deux enfants obligatoires en mode photo et aucun en mode manuel : contrôle différé au commit, y compris déplacement ou suppression d'un enfant.
- Le contrôle différé valide l'état final de la transaction : un rapport photo conserve ses deux lignes enfants, un rapport manuel n'en conserve aucune.
- Notifications pending avec prochaine tentative ; sent avec date d'acceptation.
- Propriétaire et UUID d'installation immuables. Audit avec administrateur actif, cible unique adaptée et motif non vide, puis contenu immuable et liens effaçables par suppression du parent.
- CASCADE pour les dépendances ; SET NULL pour les auteurs et les quatre liens d'audit.

L'unicité textuelle reste sensible à la casse : le Word ne demande pas `citext`.
Aucune borne supplémentaire sur l'inclinaison et aucun filtre d'âge des positions ne sont ajoutés.
Les colonnes `report_version` ne référencent pas `reports.version`, ce qui préserve l'historique.
Les horodatages et UUID sont fournis par l'appelant, sauf les défauts explicitement documentés.

## Frontière du service

Le backend à venir devra créer rapport, sélection des destinataires, historique et tâches
avec **la même connexion et la même transaction** ; les FK ne peuvent pas prouver qu'un
ensemble de destinataires est complet. De même, une opération de modération et son audit
doivent être enregistrés ensemble par le service appelant. Les contrôles d'identité,
la fenêtre d'observation à la publication, l'incrément de version lors des modifications,
les lectures GPS plus récentes, le décodage JPEG/EXIF, le stockage Scaleway et FCM restent
à implémenter dans leurs services respectifs. Ce lot ne prétend pas les implémenter.

Le rôle propriétaire utilisé localement sert aux migrations. Le futur rôle applicatif
ne doit pas être propriétaire ni avoir les droits DDL, TRUNCATE ou désactivation des triggers.
Les contrôles de ligne ne protègent pas d'un administrateur PostgreSQL.

## Tests reproductibles

```sh
.venv/bin/pip install -r backend/tests/database/requirements.txt
export BLUEWAY_TEST_ADMIN_URL='postgresql://blueway:un-mot-de-passe-local-a-vous@127.0.0.1:55432/blueway'
.venv/bin/pytest backend/tests/database -q
```

Le rôle de test doit pouvoir créer une base. Chaque exécution crée une base aléatoire
`blueway_test_<uuid>` puis supprime uniquement cette base ; elle ne réinitialise jamais
la base indiquée dans l'URL. La CI exécute ces mêmes tests sur PostGIS et publie le rapport JUnit.
Voir [les preuves de validation](validation.md).
