# Sprint Planning 2 — GestionEvents

> **Date :** 2026-05-21  
> **Sprint :** 2 / 3  
> **Durée :** 1/2 journée  
> **Équipe :** Agilité — GestionEvents  
> **Stack :** Python / Bottle · PostgreSQL

---

## Sprint Goal

Permettre à l'utilisateur de consulter, modifier, supprimer et filtrer les événements existants.

---

## User Stories sélectionnées

| ID | Titre | Priorité | Points |
|----|-------|----------|--------|
| US-05 | Voir le détail d'un événement | Haute | 3 |
| US-06 | Modifier un événement existant | Haute | 5 |
| US-07 | Filtrer les événements par catégorie | Moyenne | 5 |
| US-08 | Supprimer un événement | Haute | 3 |

**Total Sprint 2 : 16 points**

---

## Sprint Backlog

### US-05 · Voir le détail d'un événement *(3 pts)*

| Tâche technique |
|-----------------|
| Créer la route GET `/event/<id>` dans Bottle |
| Écrire la requête SQL de récupération d'un événement par son ID |
| Créer le template HTML `event_detail.html` (titre, date, heure, lieu, catégorie, description) |
| Ajouter un lien "Détail" sur chaque événement de la liste (`index.html`) |
| Gérer le cas 404 si l'événement n'existe pas |

---

### US-06 · Modifier un événement existant *(5 pts)*

| Tâche technique |
|-----------------|
| Créer la route GET `/event/<id>/edit` (affichage du formulaire pré-rempli) |
| Créer le template HTML `edit_event.html` avec les champs pré-remplis |
| Créer la route POST `/event/<id>/edit` (traitement et mise à jour en base) |
| Écrire la requête SQL `UPDATE` correspondante |
| Valider les champs obligatoires avant la mise à jour |
| Rediriger vers le détail de l'événement après modification réussie |

---

### US-07 · Filtrer les événements par catégorie *(5 pts)*

| Tâche technique |
|-----------------|
| Ajouter un champ `catégorie` à la table `events` (migration SQL) |
| Créer un menu déroulant de filtrage par catégorie dans `index.html` |
| Modifier la route GET `/` pour accepter un paramètre de filtre `?categorie=` |
| Mettre à jour la requête SQL de récupération pour filtrer par catégorie |
| Afficher la catégorie de chaque événement dans la liste et le détail |

---

### US-08 · Supprimer un événement *(3 pts)*

| Tâche technique |
|-----------------|
| Créer la route POST `/event/<id>/delete` dans Bottle |
| Écrire la requête SQL `DELETE` correspondante |
| Ajouter un bouton "Supprimer" dans la page de détail avec confirmation (modale ou `confirm()` JS) |
| Rediriger vers la liste après suppression réussie |

---

## Répartition du travail

| Membre | Tâches assignées | Points |
|--------|-----------------|--------|
| Fiona | Voir le détail d'un événement | US-05 — 3 pts |
| Alexandre | Modifier un événement existant | US-06 — 5 pts |
| Alexis | Filtrer les événements par catégorie | US-07 — 5 pts |
| Killian | Supprimer un événement | US-08 — 3 pts |

---

## Critères de succès du Sprint

- [ ] La page de détail affiche toutes les informations d'un événement (US-05)
- [ ] Un formulaire pré-rempli permet de modifier un événement persisté en base (US-06)
- [ ] Le filtre par catégorie restreint correctement la liste affichée (US-07)
- [ ] Un événement peut être supprimé avec confirmation et n'apparaît plus en liste (US-08)
- [ ] Toutes les US passent la Definition of Done de l'équipe

---

## Définition of Done (rappel)

Une User Story est terminée si :
- [ ] Le développement est terminé
- [ ] Le code est versionné sur Git
- [ ] La fonctionnalité est testée
- [ ] Les critères d'acceptation sont validés
- [ ] Aucune erreur bloquante n'est connue
- [ ] Le README est mis à jour si nécessaire
- [ ] La fonctionnalité est démontrable
- [ ] Le PO l'a validée
