# Règles de contribution — Maritime BlueWay

## Organisation des branches

Le projet utilise deux branches principales :

- `main` : version stable du projet utilisée notamment pour la présentation du MVP.
- `dev` : branche d'intégration contenant les fonctionnalités validées avant leur passage sur `main`.

Le développement doit être réalisé dans des branches de travail créées à partir de `dev`.

## Workflow

Le workflow du projet est :

`feature/*` → `dev` → `main`

Une fonctionnalité ne doit jamais être développée directement sur `main` ou `dev`.

## Branche `main`

`main` représente la version stable du projet.

Règles :

- Aucun développement direct sur `main`.
- Aucun push direct sur `main`.
- Les modifications arrivent sur `main` uniquement via une Pull Request.
- Une Pull Request vers `main` doit normalement provenir de `dev`.
- `main` doit rester dans un état fonctionnel et présentable.

## Branche `dev`

`dev` est la branche d'intégration commune.

Règles :

- Aucun développement direct sur `dev`.
- Aucun push direct sur `dev`.
- Chaque fonctionnalité ou correction possède sa propre branche.
- Les changements sont intégrés dans `dev` via une Pull Request.
- Une Pull Request doit être relue par au moins un autre membre de l'équipe avant son merge.

## Branches de travail

Les branches de travail sont créées depuis `dev`.

Convention de nommage :

- `feature/...` : nouvelle fonctionnalité
- `fix/...` : correction d'un bug
- `docs/...` : documentation
- `refactor/...` : restructuration du code sans changement fonctionnel
- `test/...` : ajout ou modification de tests
- `chore/...` : maintenance, configuration ou outils

Exemples :

`feature/maritime-map`

`feature/user-authentication`

`fix/map-loading`

`docs/api-documentation`

## Avant de commencer une tâche

Mettre `dev` à jour :

```bash
git switch dev
git pull origin dev
```

Puis créer une branche :

```bash
git switch -c feature/nom-de-la-fonctionnalite
```

## Une fois le travail terminé

Créer les commits puis envoyer la branche sur GitHub :

```bash
git add .
git commit -m "feat: description de la fonctionnalité"
git push -u origin feature/nom-de-la-fonctionnalite
```

Créer ensuite une Pull Request :

`feature/...` → `dev`

La Pull Request doit être relue par au moins un autre membre de l'équipe avant le merge.

## Passage en version stable

Lorsque la version présente dans `dev` est considérée comme stable :

`dev` → Pull Request → `main`

Aucune branche `feature/*` ne doit être fusionnée directement dans `main`.

## Règle générale

Les trois membres de l'équipe — Jonathan, Vadim et Brice — suivent le même workflow.

Personne ne développe directement sur `main` ou `dev`, y compris le propriétaire du dépôt.