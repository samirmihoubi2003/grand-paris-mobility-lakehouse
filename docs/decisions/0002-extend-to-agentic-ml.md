# ADR 0002 — Étendre le projet à l'Agentic ML sous contraintes

- **Date :** 2026-11-15
- **Statut :** proposé — à approuver avant implémentation
- **Contexte :** le projet initial collecte et traite des snapshots Vélib. Un besoin pédagogique et de portfolio impose de couvrir benchmark agentique/AutoML, harness ML et agent d'amélioration itérative.

## Décision proposée

Conserver la plateforme Data Engineering Vélib et lui adjoindre un laboratoire ML reproductible :

1. Données temporelles fiables et features versionnées.
2. Baselines supervisées non agentiques.
3. Harness imposant métriques, validation chronologique, transformations permises, limites CPU/RAM/temps et restrictions de déploiement.
4. Agent LangGraph pilotant uniquement les outils du harness, initialement sans LLM, puis avec LLM si une politique sûre est validée.
5. Benchmark séparé des frameworks agentiques, des solutions AutoML et des outils de préparation de données.

## Justification

- Une collecte qui fonctionne offre une provenance et des labels véritables.
- La séparation évite de confondre qualité prédictive, automatisation et agentivité.
- Un agent sans harness pourrait optimiser une métrique au prix de fuites, d'essais irréproductibles ou de ressources non maîtrisées.
- Une architecture modulaire permet d'apprendre chaque élément et de démontrer sa nécessité.

## Alternatives considérées

- **Chatbot connecté à un notebook :** rejeté, ne prouve ni la gestion des expériences ni les contraintes de déploiement.
- **Installer d'emblée Kafka + Spark + AutoML + agent LLM :** rejeté à ce stade (forte complexité, RAM locale et difficulté de débogage).
- **AutoML uniquement :** ne couvre pas le raisonnement itératif, la justification d'hypothèses et le benchmark agentique.

## Conséquences

Le périmètre est plus ambitieux et doit être livré par étapes testées. Les documents d'architecture existants restent des cibles, et non des fonctionnalités déjà réalisées. Tout résultat de recherche devra être reproduit et audité avant publication.
