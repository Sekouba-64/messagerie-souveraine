# Résultats des tests d'infrastructure

## Environnement testé

- Branche Git : `infra`
- Serveur Matrix : `messagerie.local`
- URL locale : `http://localhost:8008`
- PostgreSQL : `postgres:16-alpine`
- Synapse : `matrixdotorg/synapse`
- Client utilisé : Element Desktop
- Données utilisées : données fictives uniquement

## 1. Test Docker

Commande utilisée :


	docker run --rm hello-world

	
## 2. Test PostegreSQL

Commandes utilisées:
	docker compose up -d postgres
	docker compose ps ;

	docker compose ps
	NAME                  IMAGE                         COMMAND                  SERVICE    CREATED        STATUS                  PORTS
	messagerie-postgres   postgres:16-alpine            "docker-entrypoint.s…"   postgres   13 hours ago   Up 11 hours (healthy)   0.0.0.0:5432->5432/tcp, [::]:5432->5432/tcp
	
Par la suite:
docker compose exec postgres pg_isready -U synapse -d synapse
	/var/run/postgresql:5432 - accepting connections
	
Puis : 
docker compose exec postgres psql \
-U synapse \
-d synapse \
-tAc "SELECT datname, datcollate, datctype FROM pg_database WHERE datname = 'synapse';"
	synapse|C|C
	

## 3. Test Synapse
Commandes utilisées: 

   docker compose up -d synapse
   docker compose ps
   
messagerie-synapse    matrixdotorg/synapse:latest   "/start.py run -m sy…"   synapse    13 hours ago   Up 4 hours (healthy)    8448/tcp, 0.0.0.0:8008->8008/tcp, [::]:8008->8008/tcp, 19090/tcp

	
Puis plus loin:
	docker compose logs --tail=50 synapse; mentionne que synapse fonctionne sans erreur critique
	

## 4. Test API Matrix
Commandes utilisées: 
	curl -i http://localhost:8008/_matrix/client/versions

	
	curl -i --max-time 10 http://127.0.0.1:8008/_matrix/client/versions
	HTTP/1.1 200 OK
	Server: Synapse/1.164.1
	Date: Sun, 01 Nov 2026 16:39:07 GMT
	Cache-Control: public, max-age=600, s-maxage=3600, stale-while-revalidate=600
	Vary: Authorization
	Content-Type: application/json
	Access-Control-Allow-Origin: *
	Access-Control-Allow-Methods: GET, HEAD, POST, PUT, DELETE, OPTIONS
	Access-Control-Allow-Headers: X-Requested-With, Content-Type, Authorization, Date
	Access-Control-Expose-Headers: Synapse-Trace-Id, Server

## 5. Test de connextion Alice
Ce test est manuel dans Element. 


### Procédure

- Homeserver utilisé : `http://localhost:8008`
- Compte utilisé : `@alice.kabore:messagerie.local`
- Client : Element Desktop

### Résultat observé

Alice s’est connectée avec succès et l’interface Element s’est ouverte.

### Conclusion

La connexion d’un utilisateur Matrix au homeserver Synapse fonctionne.

## Test 6 — Connexion de Bob

### Procédure

- Homeserver utilisé : `http://localhost:8008`
- Compte utilisé : `@bob.ouedraogo:messagerie.local`
- Client : Element Desktop avec le profil `bob`

### Résultat observé

Bob s’est connecté avec succès dans une deuxième fenêtre Element.

### Conclusion

Deux utilisateurs peuvent utiliser simultanément le homeserver local.

## Test 7 — Message chiffré

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

## Test 8 — Groupe privé chiffré

### Procédure

- Alice a créé une salle privée.
- Bob a été invité.
- Le chiffrement a été activé.
- Alice a envoyé un message au groupe.
- Bob a reçu le message.

### Résultat observé

Le cadenas et l’indicateur de chiffrement étaient visibles.

### Conclusion

Un groupe privé chiffré fonctionne avec Alice et Bob.


## Test 9 — Compte intrus

### Procédure

- Le compte `@intrus.test:messagerie.local` existe.
- L’intrus s’est connecté à Element.
- Il n’a pas été invité dans le groupe privé Alice-Bob.
- Il a recherché le groupe.

### Résultat observé

L’intrus ne voit pas le groupe privé et ne peut pas le rejoindre sans invitation.

### Conclusion

L’existence d’un compte Matrix ne donne pas automatiquement accès aux salles privées.


## Test 10 — Retrait d’un membre

### Procédure

- Un salon temporaire privé a été créé.
- Alice, Bob et `intrus.test` y ont été ajoutés pour le test.
- Un premier message a été envoyé.
- Alice a retiré `intrus.test`.
- Un nouveau message a été envoyé après le retrait.

### Résultat observé

L’intrus pouvait éventuellement conserver les anciens messages reçus avant son retrait, mais il ne devait plus recevoir les nouveaux messages.

### Conclusion

Le retrait d’un membre bloque son accès aux nouveaux événements de la salle.
