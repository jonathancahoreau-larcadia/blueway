# Backend Blueway

## Migrations de base de données

Alembic utilise la variable `DATABASE_URL` et le pilote Psycopg 3. Depuis le
dossier `backend` :

```bash
export DATABASE_URL='postgresql+psycopg://blueway:mot-de-passe@localhost:55432/blueway'
alembic upgrade head
```

Créer une nouvelle migration :

```bash
alembic revision -m "description du changement"
```

Annuler la dernière migration :

```bash
alembic downgrade -1
```

La migration initiale exécute les fichiers SQL de
`app/infrastructure/database/migrations`. Les migrations suivantes peuvent
utiliser les opérations Alembic (`op.create_table`, `op.create_index`, etc.) ou
du SQL brut pour les fonctions et triggers PL/pgSQL.

Pour une base locale qui possède déjà le schéma créé par l'ancien outil, ne
rejouez pas la migration initiale. Après avoir vérifié que son schéma correspond
au fichier `001_schema.up.sql`, marquez-la comme appliquée :

```bash
alembic stamp 20260917_0001
```
