# Daily Scrum 3 — GestionEvents

> **Date :** 2026-05-22  
> **Sprint :** 3 / 3

---

## Killian — #10 · Exporter un événement en fichier .ics

**Ce que j'ai fait :** Lors du Sprint 2, j'ai créé la route POST `/event/<id>/delete`, écrit la requête SQL `DELETE`, ajouté le bouton "Supprimer" avec confirmation JS et géré la redirection après suppression.

**Ce que je vais faire :**
- Ajouter la dépendance `icalendar` dans `requirements.txt`
- Créer la route GET `/event/<id>/export` dans Bottle
- Générer le fichier `.ics` conforme RFC 5545 (VEVENT : titre, date, heure, lieu, description)
- Forcer le téléchargement avec le bon `Content-Type: text/calendar`
- Ajouter un bouton "Exporter .ics" dans la page de détail
- Gérer le cas 404 si l'événement n'existe pas

**Mes blocages :** Aucun

---

## Alexandre — #9 · Exporter tout le calendrier en .ics

**Ce que j'ai fait :** Lors du Sprint 2, j'ai créé les routes GET et POST `/event/<id>/edit`, le template `edit_event.html` pré-rempli, la requête SQL `UPDATE`, la validation des champs et la redirection après modification.

**Ce que je vais faire :**
- Créer la route GET `/export` dans Bottle
- Générer un fichier `.ics` agrégeant tous les événements de la base (VCALENDAR complet)
- Nommer dynamiquement le fichier (`gestionevents_<date>.ics`)
- Ajouter un bouton "Tout exporter" dans l'en-tête ou la page d'accueil

**Mes blocages :** Aucun

---

## Pierre — #12 · Rechercher un événement par mot-clé

**Ce que j'ai fait :** Lors du Sprint 2, j'ai contribué à la mise en place du projet et à la coordination de l'équipe.

**Ce que je vais faire :**
- Ajouter un champ de recherche dans `index.html` (formulaire GET avec paramètre `?q=`)
- Modifier la route GET `/` pour accepter le paramètre `q`
- Écrire la requête SQL `LIKE` sur le titre et la description
- Afficher le terme recherché et le nombre de résultats dans la page
- Cumuler la recherche avec le filtre catégorie existant (`?q=&categorie=`)
- Gérer l'affichage "Aucun résultat" si aucun événement ne correspond

**Mes blocages :** Aucun

---

## Alexis — #11 · Créer un compte et se connecter

**Ce que j'ai fait :** Lors du Sprint 2, j'ai ajouté le champ `catégorie` à la table `events` via migration SQL, créé le menu déroulant de filtrage, modifié la route GET `/` pour le paramètre `?categorie=` et mis à jour la requête SQL de récupération.

**Ce que je vais faire :**
- Créer la table `users` en base (id, username, email, password_hash)
- Créer les routes GET/POST `/register` (formulaire d'inscription + insertion en base)
- Hasher le mot de passe avec `bcrypt` ou `hashlib` avant stockage
- Créer les routes GET/POST `/login` (vérification des identifiants + session Bottle)
- Créer la route GET `/logout` (destruction de la session)
- Protéger les routes de création/modification/suppression (redirection si non connecté)

**Mes blocages :** Aucun
