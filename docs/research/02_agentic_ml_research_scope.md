# 02 — Cadrage scientifique : agent ML itératif et reproductibilité

**Projet :** Grand Paris Mobility Lakehouse & Autonomous ML Lab
**Statut :** protocole proposé, non implémenté
**Date de cadrage :** 2026-11-15

## 1. Question de recherche

> Dans quelle mesure un agent ML itératif, encadré par un harness reproductible et sécurisé, améliore-t-il la qualité prédictive et l'efficacité expérimentale par rapport à des baselines classiques et à des solutions AutoML, à budget comparable ?

Le terme « améliore » désigne une amélioration mesurée sur des données de validation définies à l'avance. Aucune amélioration n'est présumée.

## 2. Problème métier et variable cible

Pour chaque station Vélib' opérationnelle `s` et instant d'observation `t`, prédire si elle sera **vide à l'horizon de 30 minutes**.

Définition expérimentale préliminaire :

- `y(s, t) = 1` si le premier état valide de `s` dans la fenêtre `[t+28min, t+32min]` indique `num_bikes_available == 0`, sinon `0` s'il indique une valeur strictement positive.
- Si aucun état valide n'existe dans cette fenêtre, `y` est **inconnu** et l'échantillon n'est pas utilisé pour l'apprentissage supervisé.
- Exclure les états opérationnels incohérents ou obsolètes ; documenter précisément la politique de filtrage et la couverture.
- Évaluer également le sous-ensemble où `num_bikes_available(t) > 0`, pour éviter qu'une baseline « déjà vide » masque la difficulté de prévoir une future pénurie.

**Attention :** la cible décrit un état futur observé, pas une location individuelle ni un flux certifié de trajets.

## 3. Hypothèses réfutables

- **H1 — Gains prédictifs :** un agent itératif sous contraintes peut dépasser la baseline temporelle en `Average Precision` sur validation bloquée temporellement ; il peut également échouer.
- **H2 — Fiabilité :** le harness rejette les propositions introduisant une fuite temporelle, une configuration invalide ou un budget dépassé.
- **H3 — Coût/qualité :** à budget identique, l'agent peut être comparé à une recherche AutoML sans confondre leurs mécanismes.
- **H4 — Robustesse :** le système conserve un niveau mesurable de performance et de fonctionnement face aux données manquantes, à la dérive et aux redémarrages.

## 4. Variables explicatives candidates

À l'instant `t` uniquement : état actuel, capacité de la station, heure locale, jour de semaine, observations historiques jusqu'à `t`, tendances et moyennes glissantes passées, météo déjà connue à `t`, informations géographiques connues.

Une observation météo future non prévue à `t`, l'état futur de la station et toute statistique calculée sur l'ensemble de test sont interdits en entrée du modèle.

## 5. Design expérimental

1. **Collecter** des instantanés avec date de collecte et horodatage source, valider leur fraîcheur.
2. **Construire** une table de features versionnée et une cible mesurée après le délai requis.
3. **Geler** un découpage temporel global : train, validation, test final ; toutes les stations d'un même instant restent dans le même segment.
4. **Purger** les frontières temporelles au moins sur l'horizon de prédiction et les dépendances temporelles pertinentes pour éviter la fuite de labels.
5. **Définir** avant l'entraînement une métrique principale et un budget de calcul commun.
6. **Comparer** persistence, régression logistique, modèle arbres, AutoML et agent itératif.
7. **Réserver le test final** pour une évaluation unique après sélection sur validation ; aucune décision adaptative ne doit utiliser ce test.
8. **Répéter** sur plusieurs fenêtres chronologiques lorsque l'historique devient suffisant et reporter dispersion/incertitude.

La méthode `TimeSeriesSplit` de scikit-learn est utile pour comprendre la validation temporelle, mais nos fenêtres multi-stations exigent un contrôle explicite des timestamps et du délai de cible.

## 6. Mesures prévues

**Prédiction :** `Average Precision` / courbe Precision–Recall (métrique primaire candidate), Recall et Precision à un seuil fixé sur validation, F1, matrice de confusion, calibration et performance par sous-groupe.

**Groupes de contrôle :** classes de capacité, tranches horaires, jours, secteurs géographiques, stations rares en observation. Ces analyses n'établissent pas une absence de biais sociétal.

**Ingénierie :** taux d'échecs de pipeline, latence, débit, fraîcheur, duplication, complétude, temps d'entraînement, CPU/RAM, nombre d'essais, coût du modèle linguistique s'il est utilisé.

**Agent :** pourcentage de propositions rejetées par le harness, raisons de rejet, nombre d'itérations, gains sur validation, taux de régressions, traçabilité des décisions.

## 7. Critères de qualité scientifique

- Une baseline doit précéder tout agent.
- Une amélioration sur le seul train n'est pas une preuve.
- L'agent ne modifie ni la définition de cible, ni la partition test, ni la métrique choisie après avoir vu les scores.
- Toute expérience possède un identifiant, un commit Git, un hash de dataset ou sa version, un seed, un environnement, une configuration et des artefacts.
- Ne jamais afficher de résultats numériques fictifs dans la documentation publique.

## 8. Sources primaires

- Vélib' — https://www.velib-metropole.fr/donnees-open-data-gbfs-du-service-velib-metropole
- scikit-learn, TimeSeriesSplit — https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.TimeSeriesSplit.html
- scikit-learn, data leakage — https://scikit-learn.org/stable/common_pitfalls.html
- scikit-learn, métriques — https://scikit-learn.org/stable/modules/model_evaluation.html
