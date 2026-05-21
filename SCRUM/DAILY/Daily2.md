# Daily Scrum 2 — GestionEvents

> **Date :** 2026-05-21  
> **Sprint :** 2 / 3

---

## Fiona — US-05 · Voir le détail d'un événement

**Ce que j'ai fait :** Lors du Sprint 1, j'ai créé le template `base.html` avec la barre de navigation, intégré la feuille de style `static/css/style.css` et adapté `index.html` et `new_event.html` pour hériter de `base.html`.

**Ce que je vais faire :**
- Créer la route GET `/event/<id>` dans Bottle
- Écrire la requête SQL de récupération d'un événement par son ID
- Créer le template HTML `event_detail.html` avec titre, date, heure, lieu et description
- Ajouter un lien "Détail" sur chaque événement dans `index.html`
- Gérer le cas 404 si l'événement n'existe pas

**Mes blocages :** Aucun

---

## Alexandre — US-06 · Modifier un événement existant

**Ce que j'ai fait :** Lors du Sprint 1, j'ai créé la route GET `/`, écrit la requête SQL de récupération des événements triés par date, créé le template `index.html` et géré l'affichage du message "Aucun événement".

**Ce que je vais faire :**
- Créer la route GET `/event/<id>/edit` pour afficher le formulaire pré-rempli
- Créer le template HTML `edit_event.html` avec les champs pré-remplis
- Créer la route POST `/event/<id>/edit` pour traiter la mise à jour en base
- Écrire la requête SQL `UPDATE` et valider les champs obligatoires
- Rediriger vers le détail de l'événement après modification réussie

**Mes blocages :** Aucun

---

## Alexis — US-07 · Filtrer les événements par catégorie

**Ce que j'ai fait :** Lors du Sprint 1, j'ai rédigé le script SQL de création de la table `events`, mis en place la configuration de connexion et implémenté le module de connexion Python/Bottle → PostgreSQL.

**Ce que je vais faire :**
- Ajouter le champ `catégorie` à la table `events` via migration SQL
- Créer un menu déroulant de filtrage par catégorie dans `index.html`
- Modifier la route GET `/` pour accepter le paramètre `?categorie=`
- Mettre à jour la requête SQL de récupération pour filtrer par catégorie
- Afficher la catégorie de chaque événement dans la liste et le détail

**Mes blocages :** Aucun

---

## Killian — US-08 · Supprimer un événement

**Ce que j'ai fait :** Lors du Sprint 1, j'ai créé les routes GET et POST `/new`, le template `new_event.html`, implémenté la validation des champs obligatoires et la redirection après soumission réussie.

**Ce que je vais faire :**
- Créer la route POST `/event/<id>/delete` dans Bottle
- Écrire la requête SQL `DELETE` correspondante
- Ajouter un bouton "Supprimer" dans la page de détail avec confirmation JS
- Rediriger vers la liste après suppression réussie

**Mes blocages :** Aucun
