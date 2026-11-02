# Messagerie souveraine

**Prototype de messagerie instantanée souveraine, open source et sécurisée, destiné aux administrations.**

Ce projet vise à mettre en place une solution de communication numérique reposant sur des technologies libres, avec une infrastructure hébergée et administrée localement.

Il s'inscrit dans le cadre du **Hackathon 226 – Sprint Technique Pré-Hackathon 2026**.

---

## Sommaire

- [Objectif du projet](#objectif-du-projet)
- [Architecture](#architecture)
- [Technologies utilisées](#technologies-utilisées)
- [Prérequis](#prérequis)
- [Installation et démarrage](#installation-et-démarrage)
- [Scripts d'exploitation](#scripts-dexploitation)
- [Guide du client Element](#guide-du-client-element)
- [Comptes de démonstration](#comptes-de-démonstration)
- [Scénario de démonstration](#scénario-de-démonstration)
- [Documentation](#documentation)
- [Sécurité](#sécurité)
- [Limites et perspectives](#limites-et-perspectives)
- [Licence](#licence)

---

## Objectif du projet

L'objectif est de proposer une plateforme de messagerie instantanée permettant aux utilisateurs d'une administration de communiquer dans un environnement maîtrisé.

Le projet repose notamment sur les principes suivants :

- **Souveraineté numérique :** hébergement et administration de l'infrastructure sous contrôle local.
- **Sécurité des échanges :** prise en charge du chiffrement de bout en bout par le protocole Matrix.
- **Maîtrise des données :** utilisation d'une infrastructure et de technologies open source.
- **Gestion des utilisateurs :** création et administration de comptes fictifs.
- **Contrôle des accès :** utilisation de salles privées, invitations et retrait de membres.
- **Évolutivité :** possibilité d'intégrer ultérieurement des mécanismes d'authentification renforcée et des services complémentaires.

---

## Architecture

L'architecture repose sur le protocole Matrix, avec Synapse comme homeserver de messagerie et PostgreSQL comme système de gestion de base de données.

```text
                 UTILISATEURS
                       |
                       |
                 CLIENT ELEMENT
                       |
                       | HTTP local : 8008
                       v
                SERVEUR SYNAPSE
                 HOMESERVER MATRIX
                       |
                       | Réseau Docker interne
                       v
                   POSTGRESQL
                 BASE DE DONNÉES
```

### Composants principaux

| Composant | Rôle |
|---|---|
| Element | Interface cliente de messagerie |
| Matrix | Protocole de communication |
| Synapse | Homeserver Matrix et serveur de gestion des communications |
| PostgreSQL | Stockage des données du homeserver |
| Docker Compose | Déploiement et orchestration des services |
| Git et GitHub | Versionnement et collaboration |

### Paramètres locaux du prototype

| Élément | Valeur |
|---|---|
| Nom du serveur Matrix | `messagerie.local` |
| Adresse locale du homeserver | `http://localhost:8008` |
| Port Synapse | `8008` |
| Nom de la base de données | `synapse` |
| Système de gestion de base de données | PostgreSQL |

> Ces paramètres correspondent à l'environnement local de démonstration. Ils doivent être adaptés avant toute utilisation dans un autre environnement.

---

## Technologies utilisées

| Technologie | Utilisation | Licence ou référence |
|---|---|---|
| Matrix | Protocole de messagerie | Apache 2.0 |
| Synapse | Homeserver Matrix | Apache 2.0 |
| Element | Client de messagerie | Apache 2.0 |
| PostgreSQL | Gestion de base de données | PostgreSQL License |
| Docker | Conteneurisation | Apache 2.0 |
| Docker Compose | Orchestration des services | Apache 2.0 |
| Git et GitHub | Gestion du code et collaboration | N/A |

Niveau d'engagement open source : **étendre et adapter**.

---

## Prérequis

Avant de démarrer le projet, les outils suivants doivent être installés :

- Linux, macOS ou Windows avec WSL2 ;
- Docker Engine ou Docker Desktop ;
- Docker Compose ;
- Git ;
- Element Desktop pour la démonstration utilisateur ;
- un environnement compatible avec l'exécution locale de Docker.

Vérifier les installations :

```bash
docker --version
docker compose version
git --version
```

Le projet utilise uniquement des comptes, des messages et des données fictifs.

---

## Installation et démarrage

### 1. Récupérer le projet

Cloner le dépôt GitHub :

```bash
git clone https://github.com/Sekouba-64/messagerie-souveraine.git
cd messagerie-souveraine
```

La branche stable utilisée pour l'installation est `main`.

### 2. Vérifier la configuration Docker Compose

Vérifier la configuration du projet :

```bash
docker compose config
```

Afficher les services déclarés :

```bash
docker compose config --services
```

Les services principaux sont :

```text
postgres
synapse
```

### 3. Démarrer l'infrastructure

La méthode recommandée consiste à utiliser le script fourni :

```bash
./scripts/start.sh
```

Le démarrage manuel reste également possible :

```bash
docker compose up -d
```

Vérifier l'état des services :

```bash
docker compose ps
```

Les conteneurs PostgreSQL et Synapse doivent être actifs et, lorsque le contrôle de santé est disponible, indiqués comme `healthy`.

### 4. Vérifier l'API Matrix

Tester l'API de versions Matrix :

```bash
curl -i http://127.0.0.1:8008/_matrix/client/versions
```

Une réponse similaire à la suivante confirme que Synapse répond :

```text
HTTP/1.1 200 OK
```

### 5. Consulter les journaux

Afficher les dernières lignes des journaux de Synapse :

```bash
docker compose logs --tail=100 synapse
```

Suivre les journaux en temps réel :

```bash
docker compose logs -f synapse
```

Pour arrêter uniquement l'affichage des journaux :

```text
Ctrl + C
```

---

## Scripts d'exploitation

Le répertoire `scripts/` contient des scripts destinés à faciliter les opérations courantes.

| Script | Fonction |
|---|---|
| `scripts/start.sh` | Démarre PostgreSQL et Synapse |
| `scripts/stop.sh` | Arrête les conteneurs sans supprimer les volumes |
| `scripts/status.sh` | Vérifie l'état des services et de l'API Matrix |
| `scripts/logs.sh` | Affiche et suit les journaux de Synapse |

### Démarrer l'infrastructure

```bash
./scripts/start.sh
```

### Vérifier l'état de l'infrastructure

```bash
./scripts/status.sh
```

### Afficher les journaux de Synapse

Afficher les 100 dernières lignes et suivre les nouveaux messages :

```bash
./scripts/logs.sh
```

Afficher les 50 dernières lignes et suivre les nouveaux messages :

```bash
./scripts/logs.sh 50
```

### Arrêter l'infrastructure

```bash
./scripts/stop.sh
```

Le script `scripts/stop.sh` utilise `docker compose down` et conserve les volumes Docker.

> Ne pas utiliser `docker compose down -v` dans l'environnement de démonstration. Cette commande supprimerait les volumes, notamment les données PostgreSQL contenant les comptes et les conversations.

---

## Guide du client Element

Element est le client utilisé pour accéder au homeserver Matrix local.

### Adresse du serveur

L'adresse du homeserver à utiliser dans Element est :

```text
http://localhost:8008
```

### Procédure générale

1. Ouvrir Element Desktop.
2. Sélectionner l'option permettant d'utiliser un serveur personnalisé.
3. Saisir l'adresse : `http://localhost:8008`.
4. Se connecter avec un compte fictif.
5. Ouvrir ou créer une conversation.
6. Vérifier l'activation du chiffrement de bout en bout lorsque cela est requis.

### Utiliser Alice et Bob simultanément

Pour tester deux comptes sur la même machine, utiliser deux profils Element distincts.

Lancer le premier profil :

```bash
element-desktop
```

Puis, dans un autre terminal :

```bash
element-desktop --profile bob
```

Le premier profil peut être utilisé avec Alice et le second avec Bob.

Les deux profils doivent utiliser le même homeserver :

```text
http://localhost:8008
```

mais des comptes différents.

Pour les instructions détaillées, consulter le [guide de connexion Element](docs/guide-client-element.md).

---

## Comptes de démonstration

Les comptes suivants sont fictifs et réservés à la démonstration :

| Rôle | Identifiant Matrix |
|---|---|
| Administrateur | `@admin.dgtd:messagerie.local` |
| Agent Alice | `@alice.kabore:messagerie.local` |
| Agent Bob | `@bob.ouedraogo:messagerie.local` |
| Intrus de test | `@intrus.test:messagerie.local` |

Les mots de passe ne sont jamais publiés dans ce dépôt.

La description des comptes et des rôles est disponible dans :

[Comptes fictifs de démonstration](demo/comptes-fictifs.md)

> Ces comptes ne doivent pas être utilisés avec des données réelles ou sensibles.

---

## Scénario de démonstration

La démonstration du prototype peut être organisée autour des étapes suivantes :

1. Présenter le besoin de souveraineté et de maîtrise de l'infrastructure.
2. Démarrer PostgreSQL et Synapse.
3. Vérifier l'état des services.
4. Vérifier que l'API Matrix répond.
5. Connecter Alice et Bob avec Element.
6. Créer une conversation privée entre Alice et Bob.
7. Activer le chiffrement de bout en bout.
8. Envoyer un message fictif et vérifier sa réception.
9. Créer un groupe administratif privé chiffré.
10. Vérifier que le compte intrus ne voit pas le groupe privé sans invitation.
11. Tester le retrait d'un membre d'une salle temporaire.
12. Vérifier que les services restent disponibles après les tests.

Le déroulement détaillé est disponible ici :

[Scénario de démonstration](demo/scenario-demo.md)

---

## Documentation

Les documents techniques du projet sont regroupés dans les répertoires `docs/` et `demo/`.

| Document | Description |
|---|---|
| [Guide client Element](docs/guide-client-element.md) | Installation et connexion avec Element |
| [Architecture infrastructure](docs/architecture-infra.md) | Présentation de l'architecture technique |
| [Commandes infrastructure](docs/commandes-infra.md) | Commandes d'administration et d'exploitation |
| [Tests infrastructure](docs/tests-infra.md) | Vérifications et résultats des tests techniques |
| [Comptes fictifs](demo/comptes-fictifs.md) | Comptes et rôles utilisés pour la démonstration |
| [Scénario de démonstration](demo/scenario-demo.md) | Déroulement de la démonstration finale |

---

## Sécurité

La sécurité constitue un axe central du projet.

Les mécanismes et principes considérés comprennent notamment :

- le chiffrement de bout en bout proposé par Matrix ;
- l'utilisation des mécanismes cryptographiques Olm et Megolm ;
- la gestion des comptes et des droits d'accès ;
- l'utilisation de salles privées et d'invitations ;
- le retrait d'un membre d'une salle ;
- la séparation des composants applicatifs et de la base de données ;
- la protection des informations de configuration et des secrets.

Dans une conversation chiffrée de bout en bout, le contenu des messages est chiffré côté client et déchiffré par les clients destinataires autorisés.

Synapse assure notamment le stockage et le relais des événements chiffrés. Dans le fonctionnement normal du chiffrement de bout en bout, le serveur ne dispose pas des clés nécessaires pour lire le contenu des messages.

> La présence de Synapse ou d'Element ne suffit pas, à elle seule, à démontrer que tous les mécanismes sont correctement configurés. Les fonctionnalités doivent être vérifiées par des tests effectifs.

### Gestion des secrets

Les éléments suivants ne doivent jamais être ajoutés au dépôt GitHub :

- mots de passe ;
- fichiers `.env` contenant des secrets ;
- jetons d'accès Matrix ;
- `registration_shared_secret` ;
- clé privée de signature Synapse ;
- clés de récupération Element ;
- données administratives réelles.

Les secrets doivent rester dans l'environnement local de démonstration ou dans un gestionnaire de secrets approprié.

---

## Limites et perspectives

Le prototype constitue une base fonctionnelle de démonstration. Il n'est pas présenté comme une infrastructure de production.

### Limites identifiées

- Utilisation d'un environnement local de démonstration.
- Utilisation d'une adresse HTTP locale.
- Absence de reverse proxy et de configuration HTTPS de production.
- Intégration de Keycloak non réalisée.
- Authentification multifacteur non intégrée.
- Fédération Matrix externe non utilisée dans le périmètre actuel.
- Comptes, messages et données exclusivement fictifs.
- Le retrait testé concerne l'accès à une salle Matrix.
- La révocation complète d'un appareil ou de toutes ses clés constitue une amélioration future.

### Perspectives d'amélioration

- Mettre en place un reverse proxy avec HTTPS.
- Intégrer Keycloak pour la gestion centralisée des identités.
- Ajouter une authentification multifacteur.
- Renforcer la supervision et la journalisation.
- Réaliser des audits et des tests de sécurité.
- Préparer un déploiement dans un environnement de production.
- Approfondir la gestion de la révocation des appareils et des sessions.

---

## Licence

Ce projet est distribué sous licence **Apache 2.0**.

Consulter le fichier [LICENSE](LICENSE) pour plus d'informations.
