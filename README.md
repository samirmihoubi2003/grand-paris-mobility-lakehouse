# Grand Paris Mobility Lakehouse

**Plateforme expérimentale de Data Engineering pour la disponibilité des vélos partagés.**

*Projet personnel, pédagogique et reproductible — état actuel : cadrage scientifique et architecture cible (aucun pipeline de production n'est encore livré).*

## 1. Problématique

**Question de recherche :** Comment concevoir, instrumenter et évaluer une plateforme Data Lakehouse qui collecte des états de stations Vélib', fiabilise des données temporelles et soutient une prévision de disponibilité à horizon court ?

Ce dépôt vise deux résultats distincts : (1) un système d'ingénierie des données reproductible ; (2) une évaluation expérimentale transparente de ses compromis et, à terme, de modèles prédictifs.

> **Limite fondamentale :** le flux public décrit des **instantanés de disponibilité des stations**, **pas des trajets individuels**. Une variation du nombre de vélos disponibles n'est pas une mesure certifiée des locations ou retours.

## 2. Architecture cible (non encore implémentée)

```mermaid
flowchart TD
    A["API Vélib' GBFS<br/>station_status / station_information"] -->|"Polling horodaté"| B["Collecteur Python"]
    B -->|"Événements de snapshots"| K["Kafka"]
    K --> SP["Spark Structured Streaming"]
    SP --> BR["Bronze<br/>données brutes et métadonnées"]
    BR --> SI["Silver<br/>validation, dédoublonnage, fraîcheur"]
    WX["Météo / calendrier<br/>sources et licences à valider"] --> SI
    SI --> GO["Gold<br/>modèles SQL / dbt"]
    GO --> BI["Tableaux de bord"]
    SI --> ML["Évaluation ML<br/>prévision à 30 min"]
    AF["Airflow<br/>batch / backfill"] -.-> BR
    OBS["Tests, logs, métriques"] -.-> B
    OBS -.-> SP
    OBS -.-> GO
```

**Attention :** le fournisseur Vélib' expose des points de consultation HTTP. Le *streaming* est créé par notre collecte régulière et la publication d'événements dans Kafka ; l'API n'est **pas** intrinsèquement un flux Kafka ni un journal de trajets.

## 3. Objectifs scientifiques

- **Fiabilité :** caractériser les données manquantes, les duplications, les états obsolètes, les interruptions et la reprise.
- **Performance :** mesurer le débit utile, la latence de bout en bout et l'utilisation des ressources sur une machine contrainte.
- **Reproductibilité :** documenter le code, les versions, la configuration, les paramètres, le protocole et les résultats bruts des expériences.
- **Prévision :** comparer des *baselines* temporelles à des modèles plus élaborés, uniquement avec les données disponibles à l'instant de la prédiction.

Voir la [question de recherche et les hypothèses](docs/research/01_problem_statement.md) et le [protocole d'évaluation](docs/experiments/00_evaluation_protocol.md).

## 4. État de réalisation

| Composant | État | Preuve |
|---|---|---|
| Audit machine / Docker | ✅ Vérifié localement | [Journal d'audit](docs/setup/01_environment_validation.md) |
| Définition scientifique | 📄 Rédigée | [Problématique](docs/research/01_problem_statement.md) |
| Architecture cible | 📄 Proposée | [Architecture](docs/architecture/01_target_architecture.md) |
| Collecteur et jeu de données | ⏳ Non implémentés | — |
| Kafka / Spark / Lakehouse | ⏳ Non implémentés | — |
| Tests automatisés / CI | ⏳ Non implémentés | — |
| Tableaux de bord / modèle ML | ⏳ Non implémentés | — |

## 5. Structure du dépôt

```text
grand-paris-mobility-lakehouse/
├── .editorconfig
├── .gitattributes
├── .gitignore
├── .github/
│   └── PULL_REQUEST_TEMPLATE.md
├── CHANGELOG.md
├── README.md
├── docs/
│   ├── architecture/
│   ├── assets/
│   ├── decisions/
│   ├── experiments/
│   ├── git/
│   ├── research/
│   ├── setup/
│   └── sources/
└── scripts/
    └── setup/
        └── check_environment.ps1
```

Le dossier `src/` sera créé lors du développement du premier collecteur.

## 6. Reproductibilité et confidentialité

- Les fichiers de données collectées, les secrets, les fichiers `.env`, les sorties d'expériences et les rapports locaux ne sont pas suivis par Git.
- Les résultats chiffrés seront publiés **seulement après mesure**, avec les paramètres, les versions, les commandes de reproduction, les dates et les limites.
- Les droits de réutilisation seront vérifiés avant toute redistribution de données brutes.
- L'architecture sera mise en œuvre **par étapes** pour respecter la RAM disponible ; multiplier les outils ne garantit pas une meilleure solution.

## 7. Sources et navigation

- [Vélib' Métropole — documentation officielle des données GBFS](https://www.velib-metropole.fr/donnees-open-data-gbfs-du-service-velib-metropole)
- [Documentation des sources et du contrat de données](docs/sources/01_velib_gbfs.md)
- [Audit de l'environnement](docs/setup/01_environment_validation.md)
- [Workflow Git et contributions](docs/git/01_git_workflow.md)
- [Journal des versions](CHANGELOG.md)

**Prochaine étape :** construire un collecteur HTTP **minimal, testé, idempotent et horodaté** avant d'introduire Kafka. Les autres fonctionnalités restent des objectifs, et non des réalisations revendiquées.
