# Commandes de l'infrastructure

Toutes les commandes sont exécutées depuis la racine du projet :

    cd ~/Documents/Numerique2026/messagerie-souveraine

## 1. Vérifier la branche Git

    git branch --show-current

La branche d'infrastructure doit être :

    infra

## 2. Vérifier la configuration Docker Compose

    docker compose config

Cette commande vérifie la syntaxe du fichier `docker-compose.yml` et le remplacement des variables du fichier `.env`.

Lister les services configurés :

    docker compose config --services

Résultat attendu :

    postgres
    synapse

## 3. Démarrer les services

Démarrer PostgreSQL et Synapse :

    docker compose up -d

Démarrer uniquement PostgreSQL :

    docker compose up -d postgres

Démarrer uniquement Synapse :

    docker compose up -d synapse

## 4. Vérifier l'état des services

    docker compose ps

Les services attendus sont :

    messagerie-postgres
    messagerie-synapse

PostgreSQL et Synapse doivent être actifs.

## 5. Consulter les journaux

Journaux de Synapse :

    docker compose logs --tail=100 synapse

Suivre les journaux de Synapse en direct :

    docker compose logs -f synapse

Journaux de PostgreSQL :

    docker compose logs --tail=100 postgres

## 6. Tester PostgreSQL

Tester la disponibilité de PostgreSQL :

    docker compose exec postgres pg_isready \
      -U synapse \
      -d synapse

Résultat attendu :

    accepting connections

Vérifier la base, sa collation et son type de caractères :

    docker compose exec postgres psql \
      -U synapse \
      -d synapse \
      -tAc "SELECT datname, datcollate, datctype FROM pg_database WHERE datname = 'synapse';"

La base doit utiliser la collation :

    C

Vérifier l'encodage :

    docker compose exec postgres psql \
      -U synapse \
      -d synapse \
      -tAc "SHOW SERVER_ENCODING;"

Résultat attendu :

    UTF8

## 7. Tester Synapse

Tester l'état de santé :

    curl -i http://localhost:8008/health

Tester l'API Matrix :

    curl -i http://localhost:8008/_matrix/client/versions

Une réponse `HTTP/1.1 200 OK` confirme que l'API Matrix répond.

## 8. Créer un compte fictif

Créer un compte utilisateur normal :

    docker compose exec synapse register_new_matrix_user \
      http://localhost:8008 \
      -c /data/homeserver.yaml \
      -u NOM_UTILISATEUR \
      --no-admin

Créer un compte administrateur :

    docker compose exec synapse register_new_matrix_user \
      http://localhost:8008 \
      -c /data/homeserver.yaml \
      -u NOM_UTILISATEUR \
      --admin

Les mots de passe doivent être saisis localement.

Ils ne doivent jamais être ajoutés au dépôt GitHub.

## 9. Arrêter les services

Arrêter les conteneurs sans supprimer les volumes :

    docker compose down

Redémarrer les services :

    docker compose restart

Redémarrer uniquement Synapse :

    docker compose restart synapse

## 10. Attention aux volumes

La commande suivante supprime également les volumes locaux :

    docker compose down -v

Elle peut supprimer les données PostgreSQL.

Elle doit être utilisée uniquement si la base de démonstration peut être recréée.

## 11. Fichiers à ne jamais publier

Les fichiers suivants doivent rester locaux :

    .env
    deployment/synapse/*.signing.key
    synapse-data/
    media-store/
    postgres-data/
    *.log

Vérifier l'état Git :

    git status --short

Vérifier qu'un fichier est ignoré :

    git check-ignore -v .env

## 12. Vérification complète

La vérification complète de l'infrastructure est :

    docker compose config
    docker compose ps
    docker compose exec postgres pg_isready -U synapse -d synapse
    curl -i http://localhost:8008/_matrix/client/versions
    git status

