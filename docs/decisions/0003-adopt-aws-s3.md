
# ADR 0003 — Adoption d'Amazon S3

**Date :** 2026-11-17

**Statut :** Accepté — implémentation à venir
## 1. Contexte

Le projet nécessite un stockage durable des données
brutes (Bronze), des données préparées (Silver) et
des jeux de données destinés à l'analyse (Gold).

L'objectif est également d'acquérir une expérience
pratique des services cloud AWS.

## 2. Décision

Adopter Amazon S3 comme service de stockage objet
pour la plateforme Data Lakehouse.

Architecture hybride retenue :

- Collecte des données avec Python.
- Stockage Bronze sur Amazon S3.
- Traitements avec Apache Spark.
- Tables Delta Lake sur Amazon S3 pour Silver.
- Modèles analytiques Gold avec PostgreSQL et dbt.
- Exécution locale des traitements dans un premier temps.

## 3. Justification

- Utilisation d'un service cloud réel.
- Séparation du stockage et du calcul.
- Expérience pratique des permissions AWS IAM.
- Intégration possible avec AWS Glue et Athena.
- Conservation des données indépendamment du poste local.

## 4. Contraintes

- Coûts de stockage, de requêtes et de transfert.
- Nécessité d'une configuration IAM sécurisée.
- Dépendance à la connectivité réseau.
- Contrôle du nombre de requêtes et de petits fichiers.
- Compatibilité Delta Lake / S3 à valider.

## 5. Validation prévue

1. Configurer un environnement AWS sécurisé.
2. Activer les alertes de coûts.
3. Créer un bucket S3 privé.
4. Tester les permissions de lecture et d'écriture.
5. Charger un premier fichier JSON de test.
6. Vérifier son intégrité après téléchargement.
7. Documenter les résultats et les coûts observés.

Aucune ressource AWS n'a encore été créée dans
le cadre de cette décision.
