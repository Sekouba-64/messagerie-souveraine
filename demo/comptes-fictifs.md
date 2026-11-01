# Comptes fictifs de démonstration

Ce fichier décrit uniquement les comptes utilisés dans l'environnement local de démonstration.

Aucune donnée réelle d'agent, de service administratif ou de citoyen n'est utilisée.

## Serveur Matrix

- Nom du serveur : `messagerie.local`
- Adresse locale : `http://localhost:8008`
- Usage : environnement local de démonstration
- Fédération Matrix : hors périmètre du prototype

## Comptes utilisés

| Nom | Identifiant Matrix | Rôle | Fonction dans la démonstration |
|---|---|---|---|
| Administrateur DGTD | `@admin.dgtd:messagerie.local` | Administrateur | Gestion du serveur et des scénarios de test |
| Alice Kaboré | `@alice.kabore:messagerie.local` | Agent | Premier agent administratif fictif |
| Bob Ouédraogo | `@bob.ouedraogo:messagerie.local` | Agent | Deuxième agent administratif fictif |
| Intrus de test | `@intrus.test:messagerie.local` | Utilisateur de test | Vérification du refus d'accès à une conversation privée |

## Gestion des mots de passe

Les mots de passe :

- ne sont pas enregistrés dans ce fichier ;
- ne sont pas publiés sur GitHub ;
- ne sont pas écrits dans le README ;
- sont conservés uniquement dans un emplacement local sécurisé ;
- sont réservés à la démonstration.

## Scénario autorisé

Alice et Bob doivent pouvoir :

1. se connecter au serveur ;
2. accéder à leur client Matrix ;
3. rejoindre une conversation autorisée ;
4. échanger un message fictif ;
5. échanger un fichier fictif ;
6. vérifier l'état du chiffrement.

## Scénario administrateur

L'administrateur doit pouvoir :

1. gérer les comptes fictifs ;
2. créer ou gérer une conversation administrative ;
3. inviter Alice et Bob dans une conversation ;
4. simuler la révocation d'un utilisateur ou d'un appareil.

## Scénario intrus

Le compte `@intrus.test:messagerie.local` sert à vérifier qu'un utilisateur non autorisé :

1. ne peut pas rejoindre une conversation privée sans invitation ;
2. ne peut pas lire l'historique d'une conversation dont il n'est pas membre ;
3. ne reçoit pas les clés de chiffrement d'un groupe privé ;
4. ne peut pas accéder aux échanges réservés à Alice et Bob.

## Données utilisées

Les messages et fichiers de démonstration doivent être fictifs.

Exemple de message :

```text
Réunion de coordination fictive à 14 heures.

