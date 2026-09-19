# Socle FastAPI

Depuis la racine du dépôt, avec les dépendances de `backend/requirements.txt`
installées dans un environnement virtuel :

```bash
PYTHONPATH=backend uvicorn app.main:app --host 127.0.0.1 --port 8000
PYTHONPATH=backend pytest backend/tests/api backend/tests/unit
```

`GET /health` retourne `200 {"status":"ok"}` sans accès à PostgreSQL.
`GET /health/ready` exécute `SELECT 1` et retourne :

- `200 {"status":"ready","database":"ok"}` si PostgreSQL répond ;
- `503 {"status":"not_ready","database":"unavailable"}` si la configuration
  manque ou si PostgreSQL est indisponible.

Exporter `DATABASE_URL` dans l'environnement avant toute opération DB. Le
lancement direct ne charge pas automatiquement `.env` ; Docker Compose fournit
déjà cette variable au backend. Aucun secret ne doit être commité.
`app.config.settings.get_settings()` centralise cette lecture et
`Settings.require_database_url()` signale explicitement une valeur absente.
Le démarrage de FastAPI et `/health` restent utilisables sans cette variable.

## Connexions et dépendances

`app.infrastructure.database.connection.database_connection()` est le contexte
commun aux accès PostgreSQL. Il ouvre une connexion avec un délai de connexion
de trois secondes. En mode transactionnel, le contexte psycopg valide la
transaction en cas de succès ou l'annule en cas d'exception. La fermeture est
garantie même si la validation échoue.
Les erreurs remontent à l'appelant. Aucune connexion globale n'est conservée.

Le conteneur `app.dependencies.container` fournit `get_database_connection` via
`Depends` pour les futures fabriques de repositories et `get_database_ready`
pour le diagnostic. La dépendance fournit puis ferme la connexion sans valider
implicitement une transaction ; une future écriture devra gérer sa transaction
avant la réponse HTTP. Les tests peuvent remplacer `get_settings` ou ces providers
avec `app.dependency_overrides`. Les futurs routers recevront leurs services
depuis ce conteneur ; le domaine et l'application restent indépendants de
FastAPI et de psycopg.

Les futurs routers métier seront inclus dans `app.api.router.router`, dont le
préfixe est `/api/v1`, avant son inclusion dans `main.py`. Aucun endpoint métier
n'est créé ; `/api/v1` seul ne fournit donc pas encore de réponse métier.

## Validation PostgreSQL

La suite API/unitaire simule les accès DB et fonctionne sans serveur externe.
Pour une validation réelle, avec un PostgreSQL accessible et `DATABASE_URL`
exportée, appeler `/health/ready` sur le serveur lancé ci-dessus.

La suite existante `pytest backend/tests/database` exige
`BLUEWAY_TEST_ADMIN_URL` et le droit de créer une base temporaire. Elle crée sa
propre base, applique les migrations existantes et la supprime après les tests.
Ne jamais remplacer ce mécanisme par une réinitialisation de la base partagée.

Convention validée avec Brice pour les futurs repositories : qualifier
explicitement les tables (`blueway.nom_table`). Le backend ne définit aucun
`search_path` permanent. Le `SET LOCAL search_path = blueway, public` des
migrations reste limité à leur exécution. Le readiness vérifie la disponibilité
de PostgreSQL, pas l'état des migrations ni des tables.
