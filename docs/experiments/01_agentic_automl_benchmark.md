# 01 — Protocole de benchmark : frameworks agentiques, AutoML et ML classique

**Statut :** plan pré-enregistré ; **aucun benchmark mesuré**.

## 1. Comparaisons séparées (ne pas mélanger les catégories)

### A. Orchestration agentique

- LangGraph : graphe explicite, état, checkpoints, boucles, humain dans la boucle.
- Hugging Face smolagents (ToolCallingAgent) : alternative à confronter sur un même jeu de tâches, avec outils autorisés identiques.

### B. Automatisation du ML

- Baseline métier : prédire à `t+30` le statut courant (persistance) et baseline fréquentielle historique.
- Pipeline scikit-learn : régression logistique, puis un modèle d'arbres.
- FLAML : recherche AutoML sous budget temporel.
- AutoGluon Tabular : candidat de comparaison si ressources et protocole compatibles ; preset CPU modeste.

### C. Prétraitement / évaluation (ablation)

- Pipeline scikit-learn natif vs `skrub.tabular_pipeline` / `Cleaner` selon pertinence.
- Métriques `sklearn.metrics`, rapport `skore`, tracking `MLflow`.

`skrub` n'est pas un framework d'agent ; `skore` n'est pas non plus un agent. Les évaluations doivent suivre leurs fonctions réelles.

## 2. Question de comparaison

À données, métriques, découpages, seeds, contraintes mémoire et budget temps égaux :

- Quelle approche améliore le plus la validation par rapport à la baseline ?
- Combien de temps de calcul et d'essais ont été nécessaires ?
- Combien de propositions ont échoué aux règles du harness ?
- L'amélioration résiste-t-elle aux différentes fenêtres temporelles et au test gelé ?
- Les conclusions changent-elles lorsque le problème devient plus difficile (stations initialement non vides, sous-groupes rares) ?

## 3. Critères de benchmark des frameworks agentiques

Grille de pondération **proposée avant expérience**, révisable uniquement avant le début des mesures :

| Critère | Poids | Méthode d'observation |
|---|---:|---|
| Contrôle des actions et sécurité | 30 % | outils autorisés, refus, audit des actions |
| Reproductibilité et état durable | 25 % | reprise après incident, logs, IDs de runs |
| Qualité des décisions | 20 % | validité des hypothèses, gains vérifiés |
| Ressources et coût | 15 % | CPU/RAM/temps/tokens |
| Simplicité de maintenance | 10 % | configuration, tests, complexité |

Les poids reflètent nos priorités de recherche et non un classement universel. Chaque mesure doit préciser sa méthode, et une impression personnelle ne doit pas être présentée comme résultat chiffré.

## 4. Règles d'équité expérimentale

- Même table de features, même définition de cible, mêmes fenêtres temporelles.
- Même métrique primaire, même quota de temps et calcul par méthode, budgets et seeds consignés.
- Aucun entraînement sur test final, aucune adaptation après consultation des scores test.
- Évaluation explicite des solutions en cas de panne et d'échantillons incomplets.
- Publier aussi les essais défavorables et les erreurs.
- Répéter sur plusieurs fenêtres et seeds lorsque la collecte rend la comparaison statistiquement crédible.

## 5. Plan d'analyse

1. Statistiques descriptives des données et proportion de classe positive.
2. Score de persistance : indispensable pour une tâche temporelle.
3. Modèles ML simples + intervalles/variations chronologiques.
4. FLAML / AutoGluon sous contraintes (sans leur attribuer une autonomie agentique).
5. Agent avec règles déterministes ; puis agent doté d'un LLM avec les mêmes outils.
6. Comparaison performance/coût/fiabilité ; analyses de sous-groupes.
7. Rapport de validité interne et externe, données manquantes, risque de dérive, limites.

## 6. Livrables scientifiques attendus

- `experiment_protocol.md` figé et versionné, manifest du dataset.
- Table CSV des runs (sans données sensibles), artefacts et MLflow.
- Figures PR curve, matrice de confusion, calibration, coût vs score.
- Journal des propositions agent, acceptations, refus, raisons.
- README de reproduction : commit Git, commande, environnement, seed, durée, limites.
- Rapport final distinguant constats, hypothèses et interprétations.

## Sources

- https://docs.langchain.com/oss/python/langgraph/overview
- https://huggingface.co/docs/smolagents/index
- https://microsoft.github.io/FLAML/docs/Examples/AutoML-Classification/
- https://auto.gluon.ai/stable/tutorials/tabular/tabular-essentials.html
- https://skrub-data.org/stable/documentation.html
- https://docs.skore.probabl.ai/stable/
- https://www.mlflow.org/docs/latest/ml/tracking
