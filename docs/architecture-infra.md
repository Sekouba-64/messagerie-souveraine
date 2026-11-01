# Architecture de l'infrastructure

## 1. Objectif

Cette infrastructure fournit un serveur de messagerie Matrix auto-hébergé pour le prototype de messagerie souveraine destinée à l'administration.

Les composants fonctionnent localement avec Docker Compose.

## 2. Architecture actuelle

    Client Matrix
         |
         | HTTP local : 8008
         v
       Synapse
         |
         | Réseau interne Docker
         v
    PostgreSQL : 5432

Le client communique avec Synapse.

Synapse communique avec PostgreSQL en utilisant le nom de service Docker : `postgres`.

Le client ne communique pas directement avec PostgreSQL.

## 3. Composants actuellement déployés

### 3.1 Synapse

Synapse est le homeserver Matrix.

Il est responsable de :

- gérer les utilisateurs Matrix ;
- gérer les conversations et les groupes ;
- recevoir les requêtes du client ;
- synchroniser les appareils ;
- stocker les événements ;
- transmettre les messages aux destinataires autorisés ;
- fournir l'API Matrix.

Configuration actuelle :

- Nom du serveur : messagerie.local
- Port local : 8008
- URL locale : http://localhost:8008
- Image Docker : matrixdotorg/synapse:latest
- Conteneur : messagerie-synapse

Tester l'API Matrix :

    curl -i http://localhost:8008/_matrix/client/versions

Une réponse HTTP 200 OK confirme que l'API répond.

### 3.2 PostgreSQL

PostgreSQL est la base de données utilisée par Synapse.

Configuration actuelle :

- Nom de la base : synapse
- Utilisateur : synapse
- Port local : 5432
- Conteneur : messagerie-postgres
- Image Docker : postgres:16-alpine
- Collation : C
- Encodage : UTF8

PostgreSQL stocke les données nécessaires au fonctionnement de Synapse.

La base PostgreSQL ne doit pas être exposée directement au client Matrix. Elle est utilisée uniquement par Synapse sur le réseau Docker.

### 3.3 Docker Compose

Docker Compose démarre et relie les services :

- postgres
- synapse

Démarrer les services :

    docker compose up -d

Arrêter les services :

    docker compose down

Afficher l'état des services :

    docker compose ps

### 3.4 GitHub

GitHub contient :

- les fichiers de configuration non sensibles ;
- les scripts du projet ;
- la documentation ;
- le code développé par l'équipe ;
- l'historique des commits.

GitHub ne contient pas :

- les mots de passe ;
- le fichier .env ;
- les clés privées Synapse ;
- les volumes PostgreSQL ;
- les bases de données ;
- les messages réels ;
- les documents administratifs réels.

## 4. Connexion entre Synapse et PostgreSQL

Synapse utilise le connecteur PostgreSQL `psycopg2`.

La configuration logique est :

    database:
      name: psycopg2
      args:
        user: synapse
        database: synapse
        host: postgres
        port: 5432

Le paramètre important est `host: postgres`.

`postgres` correspond au nom du service PostgreSQL dans `docker-compose.yml`.

Il ne faut pas utiliser `localhost` dans la configuration de Synapse pour joindre PostgreSQL, car `localhost` désignerait le conteneur Synapse lui-même.

## 5. Chiffrement

La cryptographie n'est pas développée par l'équipe.

Le chiffrement de bout en bout est fourni par le client Matrix avec les mécanismes standards Matrix, notamment Olm et Megolm.

Flux attendu :

    Message écrit dans le client
              |
              v
    Chiffrement côté client
              |
              v
    Message chiffré envoyé à Synapse
              |
              v
    Stockage et transmission par Synapse
              |
              v
    Déchiffrement local chez le destinataire

Le serveur ne doit pas recevoir le texte original d'un message chiffré.

Les tests de chiffrement doivent utiliser uniquement des messages et fichiers fictifs.

## 6. État actuel du projet

Les composants suivants sont disponibles :

- Docker ;
- Docker Compose ;
- PostgreSQL ;
- Synapse ;
- API Matrix ;
- comptes fictifs ;
- branche Git `infra`.

Les composants suivants ne sont pas encore intégrés :

- client Element ;
- Keycloak ;
- authentification TOTP ;
- reverse proxy ;
- HTTPS de production ;
- interface personnalisée ;
- logique métier des niveaux de confidentialité.

## 7. Limites actuelles

- Le serveur fonctionne en HTTP local pour le prototype.
- L'URL `http://localhost:8008` est réservée aux tests locaux.
- L'authentification forte TOTP n'est pas encore intégrée.
- Keycloak n'est pas encore intégré.
- Le reverse proxy n'est pas encore configuré.
- Les données utilisées sont fictives.
- La fédération Matrix n'est pas utilisée dans le prototype.
