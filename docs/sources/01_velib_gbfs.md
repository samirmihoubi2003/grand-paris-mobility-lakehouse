# 01 — Source primaire : Vélib' Métropole GBFS

**Source officielle :** [Vélib' Métropole — Open Data GBFS](https://www.velib-metropole.fr/donnees-open-data-gbfs-du-service-velib-metropole)

**Consultation documentaire :** 2026-11-14. Les données elles-mêmes sont dynamiques.

## 1. Points d'accès annoncés par l'opérateur

- **États des stations :** [station_status.json](https://velib-metropole-opendata.smovengo.cloud/opendata/Velib_Metropole/station_status.json)
- **Informations sur les stations :** [station_information.json](https://velib-metropole-opendata.smovengo.cloud/opendata/Velib_Metropole/station_information.json)

La documentation de l'opérateur annonce un format JSON, un accès sans clé, une fréquence de mise à jour d'environ une minute et une référence à **GBFS 1.0**. Le format exact des réponses, leur version et leur disponibilité devront être vérifiés par une requête réelle avant de mettre en place l'ingestion.

## 2. Variables documentées (exemples)

| Champ | Signification | Précaution |
|---|---|---|
| `station_id` | Identifiant de station | Conserver l'identifiant sans perte d'information lors de la normalisation. |
| `last_reported` | Date/heure du dernier état communiqué par la station | Peut différer de l'heure de collecte ou être ancien. |
| `num_bikes_available` | Nombre de vélos disponibles | Ne correspond pas au nombre de locations. |
| `num_docks_available` | Nombre de bornes disponibles | À interpréter avec l'état opérationnel de la station. |
| `is_installed`, `is_renting`, `is_returning` | Indicateurs opérationnels | Vérifier les types, valeurs et cas particuliers dans la réponse réelle. |
| `lat`, `lon`, `capacity`, `name` | Métadonnées de station | Proviennent du point d'accès `station_information`. |

## 3. Provenance à conserver pour chaque collecte

- Identifiant d'exécution : `collector_run_id`.
- Horodatage de collecte en UTC : `ingested_at_utc`.
- URL interrogée, code de statut HTTP et en-tête `Date` s'il est disponible.
- Horodatages et métadonnées d'origine fournis par la source, sans les remplacer silencieusement.
- Version du code et empreinte de contrôle (*checksum*) du contenu brut, si pertinente.
- Résultat des contrôles de qualité : `valid`, `suspect` ou `invalid`, avec une justification explicite.

**Distinction essentielle :** l'heure de collecte ne doit pas être confondue avec l'heure à laquelle la station a effectivement signalé son état.

## 4. Restrictions d'interprétation

Une station peut être réapprovisionnée, vidée, indisponible ou corrigée sans que les trajets individuels soient connus. Il ne faut donc pas convertir les variations de vélos disponibles en « voyages observés ».

De même, un historique antérieur à nos collectes ne peut pas être reconstruit à partir du seul point d'accès instantané `station_status.json`.

## 5. Distribution et reproductibilité

Les conditions de réutilisation et les éventuelles limites d'accès doivent être vérifiées avant d'inclure des instantanés bruts dans un dépôt public.

Par défaut, les données collectées restent hors de Git. Le dépôt publiera d'abord le code, le protocole de collecte, les schémas, les tests et, lorsqu'elles auront été mesurées, des statistiques agrégées vérifiables.
