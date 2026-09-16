# Validation S1 du service PostgreSQL et PostGIS

Validation locale effectuée le 16 septembre 2026, sur la branche `codex/s1-postgis-schema`,
créée depuis `dev` (`88fdd2c474a860cdfecd512b66c31e74a8725563`).

## Comparaison documentaire

Référence : ` Technical-Documentation-escali.docx`, fournie par l'utilisateur.
Le contrôle des 99 triplets champ/type/clé-nullabilité du PDF contre les dix tableaux Word
n'a trouvé aucune divergence structurelle. Les 14 relations et leurs cardinalités ont
été examinées, ainsi que les règles de suppression et les notes de cycle de vie.
Les abréviations `timestamp`, `double` et `GeoPoint` sont explicitement développées dans
le PDF en `timestamptz`, `double precision` et `geography(Point,4326)`.

Correction : trois renvois erronés aux pages 12–13 remplacés par 4–5 ; ajout des deux pages
manquantes de contraintes. Les cinq pages du PDF final ont été rendues et inspectées.
La comparaison pixel des trois premières pages confirme que seules les zones des
renvois ont changé. Le Word est inchangé. Empreintes et décompte dans
[document-comparison.json](document-comparison.json).

## Exécution locale

- PostgreSQL 17.5, PostGIS 3.5.2, image Docker figée par digest dans Compose.
- Python 3.9, psycopg 3.2.10, pytest 8.4.2 ; CI configurée sur Python 3.12.
- `pytest backend/tests/database -q --junitxml=Docs/database/test-results.xml` : **113 passed in 11.85s**.
- Rapport brut : [test-results.xml](test-results.xml).
- Base de test créée avec un nom aléatoire et supprimée par la fixture.
- Service Compose `blueway-database-database-1` : **Healthy**.
- Migration du service local : `applied 001_schema` ; second passage : aucune migration.
- Catalogue du service : **10 tables métier, 99 colonnes** dans `blueway`.

## Cas vérifiés

| Domaine | Résultat observé |
| --- | --- |
| Dictionnaire | Types, nullabilité, 99 champs, dix PK, 14 FK conformes |
| Valeurs et bornes | États invalides, hors bornes, NaN et infinis rejetés |
| Unicités | Identités, installation, token, photo, idempotence et doublons d'alertes rejetés |
| Géographie | Géométries autres que Point rejetées ; GiST présent et utilisé par EXPLAIN ; seuil de distance vérifié |
| Photo | Enfant manquant, déplacé ou conservé en mode manuel rejeté au commit |
| Upload | Échec puis réussite sur la même ligne accepté ; métadonnées incomplètes rejetées |
| Cascade | Dépendances supprimées ; auteur et liens d'audit passés à NULL ; audit conservé |
| Historique | Ancienne report_version conservée après changement du rapport |
| Audit | Admin et cible requis, raison vide et mutations interdites rejetées |
| Concurrence | Mutations enfants sérialisées ; écriture obsolète REPEATABLE READ rejetée ; migrations concurrentes appliquées une seule fois |
| Migration | up, replay, down, replay down, up ; empreinte altérée rejetée ; migration en erreur annulée sans trace partielle |

Les règles applicatives hors service (notamment sélection exhaustive des alertes,
autorisation Firebase, incrément de version, fichier JPEG réel et opération de modération
avec son audit) ne sont pas annoncées comme validées. Leur frontière est détaillée dans
[README.md](README.md).

## Intégration restante

L'approbation d'un autre membre, la fusion dans `dev` et la validation de cette branche
après fusion restent nécessaires. Les tests locaux ne valent pas approbation humaine.
L'accès Linear nécessite une reconnexion et l'identifiant du ticket S1 n'a pas été fourni ;
aucun ticket n'a été clôturé. La PR doit être liée à ce ticket lorsqu'il sera disponible.
