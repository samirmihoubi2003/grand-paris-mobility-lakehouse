# Leçon 01 — De « prédire » à « améliorer un modèle » : comprendre ML, AutoML, agent et harness

**Public :** débutant en agentic ML ; objectif : comprendre avant d'automatiser.

## 1. Cinq notions différentes

- **Dataset :** lignes d'observations avec variables (features) et éventuellement une vérité future (label).
- **Modèle ML :** fonction apprise sur des exemples passés pour prédire un résultat sur de nouvelles observations.
- **Pipeline ML :** suite reproductible de nettoyage, encodage, apprentissage et prédiction.
- **AutoML :** système qui effectue automatiquement certaines recherches de modèles et d'hyperparamètres.
- **Agent ML :** système qui examine des diagnostics, formule une hypothèse d'amélioration, appelle des outils d'expérience, analyse leur résultat et itère.
- **Harness :** environnement de règles et d'outils dans lequel l'agent peut travailler sans changer les critères scientifiques ni dépasser le budget.

## 2. Exemple fictif (aucune mesure réelle)

Supposons que la station A possède 2 vélos à 14 h. Notre système veut prédire si elle sera vide à 14 h 30.

- Feature à 14 h : `num_bikes_available = 2`.
- Cible observée plus tard : `num_bikes_available(14h30) == 0`.
- Baseline de persistance : « si elle est vide maintenant, elle le restera ; sinon, elle sera non vide ».
- Modèle ML : apprend le lien entre historique de disponibilité, heure, météo disponible et cible future.
- Agent : constate par exemple un rappel insuffisant, propose d'ajouter un lag historique ; le harness vérifie que ce lag est calculé uniquement à partir du passé.

**L'agent ne peut pas connaître le futur au moment de prédire.** Les labels futurs servent à l'apprentissage et à l'évaluation après leur observation.

## 3. Overfitting, imbalance et leakage

**Overfitting :** le modèle mémorise trop l'entraînement ; son score entraînement est excellent mais sa validation se dégrade.

**Class imbalance :** beaucoup plus d'exemples « station non vide » que « station vide » ou inversement ; l'accuracy peut alors masquer une détection médiocre des rares pénuries.

**Data leakage :** information inaccessible à 14 h glissée dans une feature (ex. état de 14 h 30 ou pluie effectivement observée à 14 h 20). Les scores paraissent meilleurs qu'ils ne le seraient en usage réel.

## 4. Pourquoi faire d'abord une baseline ?

Sans baseline, le score de l'agent ne signifie rien. Une baseline simple constitue un point de référence ; si un agent complexe ne fait pas mieux, sa complexité n'est pas justifiée par les résultats.

## 5. Mini-exercice avant la première ligne de code

Pour chacune des variables suivantes, décider si elle est disponible au moment `t = 14h00` :

1. Nombre de vélos à 13 h 55 : **oui**, si déjà collecté.
2. Température observée à 14 h 20 : **non**.
3. Capacité connue de la station : **oui**, si à jour.
4. Nombre de vélos à 14 h 30 : **non** (c'est notre cible future).
5. Prévision météorologique publiée à 13 h 30 pour 14 h 30 : **potentiellement oui**, si l'on conserve sa date de publication et sa provenance.

## 6. Chemin pédagogique du projet

1. Collector HTTP et tests sans Kafka ; comprendre les données.
2. Agrégation des snapshots et labels futurs ; apprendre `t`, `t+30`, les lacunes et le split temporel.
3. Première baseline avec scikit-learn et métriques.
4. Pipeline de features + contrôles de leakage ; essayer skrub.
5. MLflow et comparaison des essais.
6. Harness à règles explicites et contraintes de ressources.
7. Boucle itérative déterministe avec diagnostics.
8. Ajout d'un agent LangGraph piloté par LLM et outils restreints, avec revue humaine.
9. Benchmark FLAML, AutoGluon, LangGraph et alternative agentique.
10. Industrialisation Data Engineering et services de déploiement, avec mesure des ressources.

**Règle permanente :** aucune compétence ou résultat n'apparaît dans le CV comme acquis avant une réalisation et une validation vérifiables.
