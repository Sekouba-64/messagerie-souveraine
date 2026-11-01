# Scénario de démonstration – Messagerie souveraine

## Séquence 1 – Présentation

Les agents de l’administration échangent actuellement sur des messageries grand public.

Ce prototype propose une messagerie **hébergée localement**, avec chiffrement de bout en bout, identité contrôlée et possibilité de révocation.

## Séquence 2 – Démarrage de l’infrastructure

Depuis la racine du projet :

    docker compose up -d
    docker compose ps

Montrer que les conteneurs messagerie-postgres et messagerie-synapse sont actifs.

## Séquence 3 – Connexion des agents

- Homeserver : http://localhost:8008
- Connexion d’Alice : @alice.kabore:messagerie.local
- Connexion de Bob : @bob.ouedraogo:messagerie.local

## Séquence 4 – Conversation chiffrée 1 à 1

1. Alice crée une discussion privée avec Bob.
2. Activation du chiffrement de bout en bout.
3. Envoi d’un message fictif.
4. Vérification que le cadenas est présent des deux côtés.

## Séquence 5 – Groupe administratif

1. Création d’un groupe privé.
2. Invitation d’Alice et Bob uniquement.
3. Vérification que le chiffrement est actif.

## Séquence 6 – Test de l’intrus

1. Connexion avec le compte @intrus.test:messagerie.local.
2. Tentative de rejoindre la conversation privée ou le groupe.
3. Démonstration du refus d’accès.

## Séquence 7 – Conclusion technique

- Le client chiffre le message avec les mécanismes Olm / Megolm.
- Synapse stocke et relaie l’événement chiffré.
- Le destinataire déchiffre localement.
- Le serveur ne lit pas le contenu en clair d'un message correctement chiffré de bout en bout.

