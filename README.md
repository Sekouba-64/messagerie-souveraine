# Messagerie souveraine – Prototype open source

Prototype de messagerie instantanée souveraine destinée aux agents de l’administration publique, développé dans le cadre du Sprint Technique Pré-Hackathon 2026 (Hackathon 226).

## Objectif

Fournir une messagerie:

- hébergée sur une infrastructure maîtrisée (Docker Compose) ;
- avec chiffrement de bout en bout (protocole Matrix – Olm/Megolm) ;
- utilisant uniquement des technologies open source ;
- permettant l’enrôlement d’agents fictifs, la gestion des accès et la démonstration de révocation.

## Architecture générale

    Client Element
         ↓ HTTP (localhost:8008)
    Synapse (Homeserver Matrix)
         ↓ Réseau Docker interne
    PostgreSQL

- **Client** : Element (interface utilisateur)
- **Serveur** : Synapse (homeserver Matrix)
- **Base de données** : PostgreSQL
- **Chiffrement** : Olm (1 à 1) et Megolm (groupes) – côté client uniquement
- **Déploiement** : Docker Compose (une seule commande)

## Technologies utilisées

| Composant       | Technologie    | Licence     |
|-----------------|----------------|-------------|
| Protocole       | Matrix         | Apache 2.0  |
| Homeserver      | Synapse        | Apache 2.0  |
| Client          | Element        | Apache 2.0  |
| Base de données | PostgreSQL     | PostgreSQL  |
| Orchestration   | Docker Compose | Apache 2.0  |

Niveau d’engagement open source : **Étendre et adapter**.

## Installation et démarrage

    git clone https://github.com/Sekouba-64/messagerie-souveraine.git
    cd messagerie-souveraine
    git switch client
    docker compose up -d
    docker compose ps

Vérifier que l’API répond :

    curl -i http://localhost:8008/_matrix/client/versions

## Guide de connexion (Client)

Voir le guide détaillé :

→ [docs/guide-client-element.md](docs/guide-client-element.md)

**Homeserver à utiliser :** `http://localhost:8008`

## Comptes fictifs de démonstration

| Rôle           | Identifiant Matrix                  |
|----------------|-------------------------------------|
| Administrateur | @admin.dgtd:messagerie.local        |
| Agent Alice    | @alice.kabore:messagerie.local      |
| Agent Bob      | @bob.ouedraogo:messagerie.local     |
| Intrus (test)  | @intrus.test:messagerie.local       |

Les mots de passe ne sont **jamais** publiés dans ce dépôt.

## Scénario de démonstration

Le scénario complet (connexion, conversation chiffrée, groupe, test d’intrus) est décrit ici :

→ [demo/scenario-demo.md](demo/scenario-demo.md)

## Documentation technique

- Architecture infrastructure : [docs/architecture-infra.md](docs/architecture-infra.md)
- Commandes utiles : [docs/commandes-infra.md](docs/commandes-infra.md)
- Comptes fictifs : [demo/comptes-fictifs.md](demo/comptes-fictifs.md)

## Limites actuelles du prototype

- Fonctionne en HTTP local (`localhost:8008`) pour la démonstration.
- Authentification forte (TOTP) et Keycloak non encore intégrés.
- Reverse proxy et HTTPS non configurés.
- Fédération Matrix désactivée.
- Données exclusivement fictive.

## Licence

Ce projet est publié sous licence **Apache 2.0**.

Voir le fichier [LICENSE](LICENSE).
