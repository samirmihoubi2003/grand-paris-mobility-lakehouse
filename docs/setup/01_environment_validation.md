# 01 — Validation de l'environnement (2026-11-14)

**Contexte :** Windows 11 Pro, poste de développement personnel. Les observations suivantes proviennent des sorties terminal effectivement exécutées, pas d'une mesure de charge représentative.

| Élément | Résultat observé |
|---|---|
| CPU | AMD Ryzen 7 5800H, 16 processeurs logiques |
| RAM | 15,9 Go |
| Disque libre C: | 402,1 Go au moment de l'audit |
| Virtualisation firmware | Activée |
| Python | 3.12.10 |
| Git | 2.56.0.windows.4 |
| VS Code | 1.146.0 |
| Docker CLI/Engine | 29.9.2 |
| Docker Desktop | 4.98.0 |
| Docker Compose | v5.6.1 |
| WSL | 3.0.5.0 (commande de version OK) |
| Context Docker | `desktop-linux`, conteneurs `linux/amd64` |

## Historique des validations

1. Script d'audit exécuté : Docker CLI présent mais Engine non accessible au premier essai.
2. Démarrage de Docker Desktop, puis `docker version` : **Client + Server** présents sans erreur.
3. `docker run --rm hello-world` : affiche **« Hello from Docker! »**.

**Conclusion limitée :** le moteur Docker fonctionne et un conteneur minimal a été exécuté. **Cela ne valide pas encore** une stack Spark/Kafka/Airflow ni les distributions WSL individuellement.

## Contrainte de capacité

15,9 Go de RAM : services démarrés par profil et tests de consommation avant montée en charge. Aucun seuil de performance n'est considéré validé à ce stade.

## Reproduction

Script en lecture seule : [`scripts/setup/check_environment.ps1`](../../scripts/setup/check_environment.ps1). Les rapports locaux sont exclus de Git ; aucun identifiant de compte, chemin utilisateur ni secret n'est nécessaire ici.
