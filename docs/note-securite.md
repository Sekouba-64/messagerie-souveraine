# Note de sécurité

## 1. Objet et périmètre

Cette note présente les menaces prises en compte, les protections mises en place et les limites connues du prototype de messagerie souveraine.

Le prototype est destiné à démontrer une messagerie instantanée administrative reposant sur des composants open source et déployable sur une infrastructure maîtrisée localement.

Le périmètre actuel comprend :

- un homeserver Matrix Synapse ;
- une base de données PostgreSQL ;
- le client Element Desktop ;
- un déploiement local avec Docker Compose ;
- des comptes et des données fictifs ;
- des conversations individuelles et des salles privées chiffrées.

Le prototype ne constitue pas encore une infrastructure de production de l'État.

## 2. Menaces prises en compte

Les menaces considérées sont les suivantes :

- interception du contenu des messages pendant leur transmission ;
- lecture du contenu des messages par le homeserver ;
- accès non autorisé à une salle privée ;
- utilisation d'un compte non invité ;
- perte ou compromission d'un appareil ;
- compromission d'un compte utilisateur ;
- exposition accidentelle de mots de passe ou de clés dans le dépôt Git ;
- accès non autorisé à la base de données ou aux fichiers de configuration ;
- fuite de métadonnées liées à l'utilisation du service.

Le prototype utilise uniquement des comptes fictifs. Aucune donnée administrative réelle ou sensible ne doit être utilisée pendant les tests.

## 3. Chiffrement des messages

Le chiffrement de bout en bout est fourni par Matrix et le client Element. Le prototype ne développe aucune cryptographie personnalisée.

Les mécanismes cryptographiques utilisés par Matrix comprennent notamment :

- Olm pour les échanges individuels ;
- Megolm pour les conversations de groupe.

Le chiffrement et le déchiffrement sont réalisés côté client. Les clients autorisés disposent des clés nécessaires pour lire les messages.

Synapse assure principalement le relais et le stockage des événements Matrix. Dans une conversation correctement chiffrée, le contenu du message n'est pas transmis au serveur sous forme de texte lisible.

Les tests réalisés ont démontré :

- une conversation chiffrée entre Alice et Bob ;
- l'affichage de l'indicateur de chiffrement dans Element ;
- la réception et le déchiffrement d'un message par le destinataire ;
- une salle privée chiffrée accessible aux membres invités.

La vérification du chiffrement de fichiers doit faire l'objet d'un test fonctionnel séparé avec un fichier fictif.

## 4. Contrôle d'accès et identité

Les utilisateurs du prototype sont préalablement créés sur le homeserver Synapse.

Les comptes de démonstration sont :

- `@admin.dgtd:messagerie.local` ;
- `@alice.kabore:messagerie.local` ;
- `@bob.ouedraogo:messagerie.local` ;
- `@intrus.test:messagerie.local`.

Les salles privées nécessitent une invitation. Un compte existant ne peut donc pas rejoindre automatiquement une salle privée sans y être invité.

Le test avec `@intrus.test:messagerie.local` a montré que :

- le compte peut exister sur le homeserver ;
- le compte peut se connecter à Element ;
- le compte ne voit pas la salle privée Alice-Bob ;
- le compte ne peut pas rejoindre la salle sans invitation.

Les rôles sont représentés dans le prototype par le compte administrateur et les droits liés aux salles Matrix.

## 5. Révocation et retrait d'un membre

Le retrait d'un membre d'une salle a été testé.

Après le retrait :

- le membre ne doit plus recevoir les nouveaux événements de la salle ;
- le membre ne doit plus pouvoir participer normalement à la conversation ;
- les messages déjà reçus et déchiffrés localement peuvent rester présents sur son appareil.

Le retrait d'une salle ne doit pas être confondu avec l'effacement rétroactif des données déjà reçues par un appareil.

La désactivation globale d'un compte et l'invalidation de toutes ses sessions constituent la procédure à utiliser en cas de départ d'un agent, de perte d'un téléphone ou de compromission présumée.

La révocation globale multi-appareils doit être vérifiée séparément avec un compte fictif dédié avant une démonstration finale.

## 6. Métadonnées visibles par le serveur

Le chiffrement de bout en bout protège principalement le contenu des messages. Il ne rend pas toutes les informations invisibles au homeserver.

Selon la configuration et l'utilisation, Synapse peut traiter ou conserver notamment :

- les identifiants des utilisateurs ;
- les identifiants des salles ;
- les membres des salles ;
- les événements de synchronisation ;
- les dates et heures d'activité ;
- les informations techniques de connexion ;
- les journaux applicatifs ;
- les événements chiffrés ;
- les informations nécessaires au routage et au fonctionnement du service ;
- les fichiers médias stockés par le homeserver, avec leurs informations techniques.

Le serveur peut donc déduire certaines relations d'utilisation, par exemple qu'un compte participe à une salle ou échange des événements à un moment donné.

Mesures prises dans le prototype :

- déploiement local sans fournisseur cloud obligatoire ;
- absence de fédération externe dans le périmètre de démonstration ;
- utilisation de données fictives ;
- séparation de PostgreSQL et de Synapse sur le réseau Docker ;
- limitation des secrets au fichier `.env` local ;
- exclusion des clés et données runtime du dépôt Git ;
- restriction de l'accès administratif à la machine de démonstration.

Les durées de conservation, la supervision centralisée et une politique complète de minimisation des journaux restent à définir pour un déploiement de production.

## 7. Protection de l'infrastructure

L'infrastructure du prototype est composée de PostgreSQL et de Synapse exécutés avec Docker Compose.

Les protections mises en place comprennent :

- communication entre services sur le réseau Docker interne ;
- accès local au homeserver sur `localhost:8008` ;
- base PostgreSQL non utilisée directement par le client ;
- secrets locaux non publiés dans Git ;
- fichier `.env` ignoré par Git ;
- fichiers de données runtime ignorés par Git ;
- clé privée de signature Synapse exclue du dépôt public ;
- scripts de vérification de l'état et des journaux.

Le déploiement actuel utilise HTTP local pour la démonstration. HTTPS, reverse proxy, pare-feu de production, sauvegardes chiffrées et haute disponibilité restent à mettre en place avant toute exploitation réelle.

## 8. Limites connues

Les limites actuelles sont les suivantes :

- aucun second facteur TOTP ou MFA n'est encore intégré ;
- Keycloak n'est pas intégré ;
- l'enrôlement institutionnel complet n'est pas implémenté ;
- la révocation globale multi-appareils doit encore être démontrée séparément ;
- le test fonctionnel d'un fichier chiffré doit encore être ajouté ;
- le déploiement est local et non destiné à la production ;
- HTTPS et reverse proxy ne sont pas configurés ;
- aucune garantie d'effacement rétroactif des messages déjà déchiffrés sur un appareil n'est revendiquée ;
- les comptes utilisés sont fictifs ;
- la présente note ne constitue pas un audit de sécurité indépendant.

## 9. Conclusion

Le prototype démontre une messagerie Matrix locale, open source et administrable, avec :

- chiffrement de conversations individuelles ;
- salles privées ;
- contrôle d'accès par invitation ;
- test d'un compte intrus ;
- retrait d'un membre ;
- déploiement local avec Docker Compose ;
- séparation entre Synapse et PostgreSQL ;
- gestion prudente des secrets dans le dépôt Git.

Les principales améliorations avant un déploiement administratif réel sont l'intégration d'un second facteur, la formalisation de l'enrôlement institutionnel, la révocation globale des appareils, le test des fichiers chiffrés et le durcissement de l'infrastructure.

## Références techniques

- Matrix : https://matrix.org/
- Chiffrement de bout en bout Matrix : https://matrix.org/docs/older/e2ee-guide/
- Synapse : https://github.com/element-hq/synapse
- Element Desktop : https://github.com/element-hq/element-desktop
- PostgreSQL : https://www.postgresql.org/
