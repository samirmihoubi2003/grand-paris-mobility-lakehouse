# 00 — Protocole expérimental préenregistré

**Statut : protocoles à exécuter, résultats non disponibles.** Chaque résultat futur doit référencer un commit Git et les artefacts de mesure.

## Fiche minimale d'une expérience

1. **ID et date UTC :** identifiant stable de l'expérience.
2. **Objectif, question et hypothèse :** ce que l'on cherche à réfuter/valider.
3. **Environnement :** CPU, RAM, OS, versions images, paramètres Docker.
4. **Données :** source, intervalle, volume, filtrage, empreinte SHA-256 si redistribuable.
5. **Protocole :** commande exacte, configuration, nombre de répétitions, conditions warm/cold.
6. **Métriques :** unités explicites, définition exacte, méthode d'échantillonnage.
7. **Résultats :** tableaux/figures générés à partir de logs, dispersion, erreurs.
8. **Limites :** menaces à la validité, tests non réalisés, problèmes de collecte.

## Expérience E01 : qualité et fraîcheur

- Compter les observations reçues, uniques et exploitables par intervalle.
- Calculer l'âge de chaque observation : `ingested_at_utc - source_last_reported_utc`, uniquement si l'horodatage source est exploitable.
- Rapporter les proportions d'enregistrements avec `last_reported` absent/ancien et les temps d'indisponibilité du collecteur.
- Afficher couverture horaire et jours non observés ; ne pas interpoler sans justification.

## Expérience E02 : performance et résilience

- Comparer une implémentation Python batch à une architecture streaming sur **des charges définies et identiques** (replay contrôlé), pas sur deux jours réels incomparables.
- Mesurer `records/s`, latence p50/p95, RAM moyenne/maximale, CPU et récupération après arrêt contrôlé.
- Répéter les mesures et séparer démarrage à froid et régime établi.
- Vérifier au redémarrage les pertes et doublons par identifiant/clé technique.

## Expérience E03 : prédiction à 30 min

- Définir une fenêtre de tolérance pour l'étiquette future avant de regarder les performances.
- Définir une baseline de persistance et un modèle simple avant tout modèle complexe.
- Utiliser des partitions chronologiques, avec séparation anti-fuite des fenêtres chevauchantes.
- Rapporter PR-AUC, rappel à seuil fixé, précision, calibration et support des classes ; précision seule insuffisante en cas de classes rares.
- Comparer **avec** et **sans** variables météo ; les données météo utilisées doivent être réellement disponibles à `t` (prévision ou données historiques publiées à `t`).

## Registre de résultats

Aucune mesure chiffrée n'a encore été réalisée. Le tableau de résultats sera ajouté après les premières exécutions vérifiables.
