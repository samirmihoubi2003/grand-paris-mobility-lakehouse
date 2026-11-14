# 01 — Source primaire : Vélib' Métropole GBFS

**Source officielle :** https://www.velib-metropole.fr/donnees-open-data-gbfs-du-service-velib-metropole  
**Consultation documentaire :** 2026-11-14. Les données elles-mêmes sont dynamiques.

## Points d'accès annoncés par l'opérateur

- États des stations : `https://velib-metropole-opendata.smovengo.cloud/opendata/Velib_Metropole/station_status.json`
- Information stations : `https://velib-metropole-opendata.smovengo.cloud/opendata/Velib_Metropole/station_information.json`

La page indique un format JSON, un accès sans clé, une fréquence annoncée de mise à jour d'environ une minute, et se réfère à **GBFS 1.0**. Les formats réellement observés devront être validés par un test et une sauvegarde de métadonnées au lancement de l'ingestion.

## Variables documentées (exemples)

| Champ | Sens | Précaution |
|---|---|---|
| `station_id` | Identifiant de station | Chaîne/entier selon payload, canoniser sans perdre d'information |
| `last_reported` | Date/heure de dernier état station | Peut être différente de la collecte et parfois ancienne |
| `num_bikes_available` | Nombre de vélos disponibles | N'est pas un nombre de locations |
| `num_docks_available` | Bornes libres | Peut dépendre de l'état opérationnel |
| `is_installed`, `is_renting`, `is_returning` | État opérationnel | Vérifier les valeurs réelles et cas spéciaux |
| `lat`, `lon`, `capacity`, `name` | Métadonnées de station | Information provenant de `station_information` |

## Provenance à conserver pour chaque lot collecté

- `collector_run_id` et `ingested_at_utc`.
- URL et statut de la requête, date HTTP si disponible.
- Horodatages de publication/source originaux, sans remplacer silencieusement les valeurs.
- Version du code et checksum du payload si pertinent.
- Politique de qualité : invalide, suspect, utilisable ; conserver la raison du rejet.

## Restrictions d'interprétation

Une station peut être réapprovisionnée, vidée, indisponible ou corrigée sans que l'on connaisse les trajets. Ne pas convertir des variations de stocks en voyages observés. On ne peut pas non plus reconstruire un historique antérieur à nos collectes à partir du seul endpoint d'état instantané.

## Distribution des données

Les conditions de réutilisation doivent être vérifiées avant d'inclure des snapshots bruts dans un dépôt public. Par défaut, les dossiers de données sont exclus de Git ; publier d'abord scripts et statistiques agrégées vérifiables.
