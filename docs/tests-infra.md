# Résultats des tests d'infrastructure

## Environnement testé

- Branche de référence : `main`
- Serveur Matrix : `messagerie.local`
- Homeserver local : `http://localhost:8008`
- PostgreSQL : `postgres:16-alpine`
- Synapse : `matrixdotorg/synapse`
- Client utilisé : Element Desktop
- Données utilisées : données fictives uniquement

---

## 1. Test de Docker

### Commande exécutée

```bash
docker run --rm hello-world
```

### Résultat observé

```text
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

### Conclusion

Docker Engine fonctionne correctement sur la machine de test.

---

## 2. Test de démarrage de PostgreSQL

### Commandes exécutées

```bash
docker compose up -d postgres
docker compose ps
```

### Résultat observé

```text
messagerie-postgres   postgres:16-alpine   Up (healthy)
```

### Vérification de la disponibilité

```bash
docker compose exec postgres pg_isready -U synapse -d synapse
```

Résultat :

```text
/var/run/postgresql:5432 - accepting connections
```

### Vérification de la base de données

```bash
docker compose exec postgres psql \
  -U synapse \
  -d synapse \
  -tAc "SELECT datname, datcollate, datctype FROM pg_database WHERE datname = 'synapse';"
```

Résultat :

```text
synapse|C|C
```

### Conclusion

PostgreSQL démarre correctement, accepte les connexions et utilise la base `synapse` avec la collation attendue.

---

## 3. Test de démarrage de Synapse

### Commandes exécutées

```bash
docker compose up -d synapse
docker compose ps
```

### Résultat observé

```text
messagerie-synapse   matrixdotorg/synapse:latest   Up (healthy)
```

Le port local utilisé est :

```text
0.0.0.0:8008->8008/tcp
```

### Vérification des journaux

```bash
docker compose logs --tail=50 synapse
```

### Conclusion

Synapse démarre correctement et reste actif sans erreur critique observée dans les journaux.

---

## 4. Test de l'API Matrix

### Commande exécutée

```bash
curl -i --max-time 10 \
  http://127.0.0.1:8008/_matrix/client/versions
```

### Résultat observé

```text
HTTP/1.1 200 OK
Server: Synapse/1.164.1
Content-Type: application/json
```

### Conclusion

L'API client Matrix répond correctement depuis la machine hôte.

---

## 5. Test de connexion d'Alice

### Procédure

- Homeserver utilisé : `http://localhost:8008`
- Compte utilisé : `@alice.kabore:messagerie.local`
- Client : Element Desktop

### Résultat observé

Alice s'est connectée avec succès et l'interface Element s'est ouverte.

### Conclusion

La connexion d'un utilisateur Matrix au homeserver Synapse fonctionne.

---

## 6. Test de connexion de Bob

### Procédure

- Homeserver utilisé : `http://localhost:8008`
- Compte utilisé : `@bob.ouedraogo:messagerie.local`
- Client : Element Desktop avec le profil `bob`

### Résultat observé

Bob s'est connecté avec succès dans une deuxième fenêtre Element.

### Conclusion

Deux utilisateurs peuvent utiliser simultanément le homeserver local.

---

## 7. Test d'un message chiffré

### Procédure

- Alice et Bob ont ouvert une conversation privée.
- Le chiffrement de bout en bout a été activé.
- Le cadenas était visible dans Element.
- Alice a envoyé un message fictif.
- Bob a reçu et déchiffré le message.

### Résultat observé

Le message a été reçu correctement par Bob dans la conversation chiffrée.

### Conclusion

Le chiffrement côté client fonctionne dans la conversation Alice-Bob.

---

## 8. Test d'un groupe privé chiffré

### Procédure

- Alice a créé une salle privée.
- Bob a été invité.
- Le chiffrement a été activé.
- Alice a envoyé un message au groupe.
- Bob a reçu le message.

### Résultat observé

Le cadenas et l'indicateur de chiffrement étaient visibles.

### Conclusion

Un groupe privé chiffré fonctionne avec Alice et Bob.

---

## 9. Test du compte intrus

### Procédure

- Le compte `@intrus.test:messagerie.local` existe.
- L'intrus s'est connecté à Element.
- Il n'a pas été invité dans le groupe privé Alice-Bob.
- Il a recherché le groupe.

### Résultat observé

L'intrus ne voit pas le groupe privé et ne peut pas le rejoindre sans invitation.

### Conclusion

L'existence d'un compte Matrix ne donne pas automatiquement accès aux salles privées.

---

## 10. Test du retrait d'un membre

### Procédure

- Un salon temporaire privé a été créé.
- Alice, Bob et `@intrus.test:messagerie.local` y ont été ajoutés.
- Un premier message a été envoyé.
- Alice a retiré l'intrus.
- Un nouveau message a été envoyé après le retrait.

### Résultat observé

L'intrus pouvait éventuellement conserver les anciens messages reçus avant son retrait, mais il ne recevait plus les nouveaux messages après son retrait.

### Conclusion

Le retrait d'un membre bloque son accès aux nouveaux événements de la salle. Il ne garantit pas l'effacement rétroactif des messages déjà reçus et déchiffrés sur son appareil.

---

## 11. Vérification finale des services

### Commandes exécutées

Vérifier l'état des conteneurs :

```bash
docker compose ps
```

Vérifier la disponibilité de PostgreSQL :

```bash
docker compose exec postgres pg_isready \
  -U synapse \
  -d synapse
```

Vérifier le code HTTP de l'API Matrix :

```bash
curl -sS -o /dev/null -w "%{http_code}\n" \
  http://127.0.0.1:8008/_matrix/client/versions
```

### Résultat observé

```text
messagerie-postgres : healthy
messagerie-synapse  : healthy
PostgreSQL          : accepting connections
API Matrix          : HTTP 200
```

### Conclusion

Les services PostgreSQL et Synapse restent disponibles après les tests fonctionnels. L'infrastructure est opérationnelle depuis la branche stable `main`.

---

## Conclusion générale

Le parcours suivant a été validé :

```text
Docker
  ↓
PostgreSQL
  ↓
Synapse
  ↓
API Matrix
  ↓
Element
  ↓
Conversation chiffrée
  ↓
Groupe privé
  ↓
Contrôle d'accès
  ↓
Retrait d'un membre
```

Les tests ont été réalisés avec des comptes, des messages et des données fictifs uniquement.

## 8 bis. Test d'un fichier dans une conversation chiffrée

### Procédure

- Alice et Bob ont ouvert une conversation privée chiffrée.
- Alice a envoyé le fichier fictif `document-test.txt`.
- Bob a reçu et ouvert le fichier.
- Aucune donnée réelle ou sensible n'a été utilisée.

### Résultat observé

Le fichier a été reçu et ouvert correctement par Bob dans la conversation chiffrée.

### Conclusion

Le transfert fonctionnel d'un fichier dans une conversation chiffrée a été démontré côté client Element.

Ce test ne constitue pas un audit cryptographique indépendant. Il confirme le fonctionnement du parcours utilisateur avec le chiffrement Matrix activé.

## 12. Test de révocation globale d'un compte

### Compte utilisé

- Compte fictif : `@intrus.test:messagerie.local`
- Opération : désactivation administrative du compte
- Invalidation des sessions et appareils : activée

### Procédure

- Le compte fictif a été actif sur le homeserver.
- Une révocation administrative a été exécutée.
- Les sessions et appareils associés ont été déconnectés.
- Une nouvelle tentative de connexion a été effectuée.

### Résultat observé

Le compte a été marqué comme désactivé et la tentative de reconnexion a été refusée.

### Conclusion

La désactivation administrative et l'invalidation des sessions permettent de révoquer l'accès du compte fictif au homeserver.

Cette opération n'efface pas rétroactivement les messages qui auraient déjà été reçus et déchiffrés localement sur un appareil.
