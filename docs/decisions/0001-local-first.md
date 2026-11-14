# ADR 0001 — Démarrage local et incrémental

- **Date :** 2026-11-14
- **Statut :** Accepted for initial development

## Contexte

Poste Windows 11 avec 15,9 Go RAM, Docker Engine validé. La plateforme cible utilise plusieurs composants potentiellement consommateurs de mémoire. Démarrer immédiatement toutes les couches augmenterait le risque de pannes et masquerait la compréhension des flux.

## Décision

Commencer par un collecteur Python et des tests déterministes. Ajouter Kafka, Spark, stockage Lakehouse, orchestrateur et monitoring **un composant à la fois**, avec un critère de validation et des mesures à chaque étape. Utiliser Docker Compose et des profils de services.

## Alternatives rejetées pour le démarrage

- Installer toute la stack sans instrumentation.
- Déployer immédiatement sur le cloud et encourir coûts et configuration non nécessaires.

## Conséquences

- ✅ Débogage plus simple et apprentissage scientifique cumulatif.
- ✅ Mesure de la valeur réelle de chaque technologie.
- ⚠️ Le dépôt ne sera pas « full stack » dès son premier commit.
