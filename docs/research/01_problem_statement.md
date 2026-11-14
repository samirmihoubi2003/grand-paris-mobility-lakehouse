# 01 — Problématique et hypothèses de recherche

**Statut : protocole proposé, non encore testé.**

## 1. Contexte

Les services de mobilité partagée publient des états des stations via GBFS. Les séries historiques ne sont pas nécessairement publiées telles quelles : un système de collecte crée ses propres observations à intervalles réguliers. Les données peuvent contenir retards, interruptions, mises à jour partielles ou valeurs incohérentes.

## 2. Question principale

> Comment une plateforme de collecte et de traitement de snapshots de disponibilité Vélib' peut-elle garantir traçabilité, fiabilité et reproductibilité, tout en alimentant une prévision temporelle de risque de station vide ?

## 3. Questions secondaires et hypothèses à tester

| Code | Question expérimentale | Hypothèse de travail (non prouvée) | Mesures |
|---|---|---|---|
| RQ1 | Comment le rythme de polling affecte-t-il couverture et fraîcheur ? | Une collecte plus fréquente réduit certains délais mais augmente les ressources et les doublons sémantiques. | âge des données, taux d'observations uniques, requêtes/h |
| RQ2 | Quelle amélioration obtient-on avec des contrôles de qualité explicites ? | Les règles détectent mieux les anomalies sans réduire exagérément la couverture. | anomalies détectées par type, faux positifs inspectés, couverture |
| RQ3 | Quel est le compromis local entre pipeline Python batch et Spark streaming ? | À faible volume, une solution simple peut être plus économe ; Spark devient pertinent sous d'autres charges. | débit, p50/p95, RAM, CPU, coût de reprise |
| RQ4 | Une météo correctement jointe améliore-t-elle la prévision de stations vides ? | L'amélioration est possible mais doit être démontrée hors échantillon. | PR-AUC, précision/rappel, calibration, comparaison baseline |

**Hypothèses falsifiables :** si une architecture ne produit pas l'amélioration annoncée sur les données et charges testées, le résultat négatif doit être publié et expliqué.

## 4. Définition opérationnelle de la cible ML (provisoire)

- **Population :** stations actives et ouvertes selon les indicateurs disponibles.
- **Instant d'observation :** `t`, défini par la date de collecte, avec conservation de l'horodatage `last_reported` de la source.
- **Cible :** station observée avec zéro vélo disponible autour de `t + 30 min`, sous condition de disponibilité d'une observation admissible dans une fenêtre de tolérance documentée.
- **Attention :** s'il manque la mesure future, l'étiquette est inconnue et **n'est pas transformée en 0**.
- **Évaluation :** découpage temporel train/validation/test, sans mélange aléatoire des futurs et du passé ; baselines avant modèles complexes.

Cette cible mesure la **disponibilité observée**, et non les locations, le nombre de trajets ou l'intention des usagers.

## 5. Validité et menaces

- Biais dû au jour de semaine, vacances, météo, saisonnalité et travaux.
- Biais de couverture si le collecteur est arrêté.
- Information de station non actualisée (`last_reported` ancien).
- Data leakage via agrégations futures, interpolation ou jointures météo non disponibles au temps `t`.
- Limitation de généralisation : Grand Paris, période d'observation locale, contexte de l'opérateur.

## 6. Références de départ

- Vélib' Métropole, données publiques GBFS : https://www.velib-metropole.fr/donnees-open-data-gbfs-du-service-velib-metropole
- Spécification GBFS (MobilityData) : https://github.com/MobilityData/gbfs
- Documentation Spark Structured Streaming : https://spark.apache.org/docs/latest/streaming/index.html

La bibliographie sera enrichie avec des articles scientifiques datés et analysés ; les pages techniques ne sont pas présentées comme des articles évalués par les pairs.
