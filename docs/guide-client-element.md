# Guide de connexion – Client Element

## Objectif
Permettre à un agent fictif de se connecter au serveur Matrix local et d’échanger des messages chiffrés de bout en bout.

## Prérequis
- Le serveur Matrix doit être démarré (`docker compose up -d`)
- Element Desktop installé (recommandé) ou Element Web

## Homeserver à utiliser
http://localhost:8008


## Comptes de démonstration

| Rôle              | Identifiant Matrix                  |
|-------------------|-------------------------------------|
| Agent Alice       | @alice.kabore:messagerie.local     |
| Agent Bob         | @bob.ouedraogo:messagerie.local    |
| Administrateur    | @admin.dgtd:messagerie.local       |
| Intrus (test)     | @intrus.test:messagerie.local      |

> Les mots de passe ne sont **jamais** publiés dans la documentation.

## Procédure de connexion étape par étape

1. Ouvrir **Element Desktop**
2. Cliquer sur **Se connecter**
3. Cliquer sur **Modifier** (serveur personnalisé)
4. Saisir l’adresse : `http://localhost:8008`
5. Se connecter avec le compte **Alice** (`@alice.kabore:messagerie.local`)
6. Ouvrir une **deuxième instance** d’Element (ou un autre profil) et se connecter avec **Bob** (`@bob.ouedraogo:messagerie.local`)
7. Depuis le compte Alice : créer une nouvelle discussion privée avec Bob
8. Activer le **chiffrement de bout en bout** (icône cadenas)
9. Envoyer un message fictif, par exemple :  
   `Réunion de coordination fictive à 14 heures.`
10. Vérifier que Bob reçoit le message et que le cadenas est bien visible des deux côtés

## Points de contrôle importants
- Le cadenas doit être présent (chiffrement de bout en bout activé)
- Le message ne doit jamais apparaître en clair côté serveur
- Seuls les membres invités peuvent accéder à la conversation
