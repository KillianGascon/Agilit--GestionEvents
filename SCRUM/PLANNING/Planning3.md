# Sprint Planning 3 — GestionEvents

> **Date :** 2026-05-22  
> **Sprint :** 3 / 3  
> **Durée :** 1/2 journée  
> **Équipe :** Agilité — GestionEvents  
> **Stack :** Python / Bottle · PostgreSQL

---

## Sprint Goal

Livrer l'export ICS, la recherche d'événements et une gestion de compte utilisateur basique pour finaliser le MVP.

---

## User Stories sélectionnées

| ID | Titre | Priorité | Points |
|----|-------|----------|--------|
| #10 | Exporter un événement en fichier .ics | Haute | 5 |
| #9 | Exporter tout le calendrier en .ics | Haute | 3 |
| #12 | Rechercher un événement par mot-clé | Moyenne | 5 |
| #11 | Créer un compte et se connecter | Moyenne | 5 |

**Total Sprint 3 : 18 points**

---

## Sprint Backlog

### #10 · Exporter un événement en fichier .ics *(5 pts)*

| Tâche technique |
|-----------------|
| Ajouter la dépendance `icalendar` dans `requirements.txt` |
| Créer la route GET `/event/<id>/export` dans Bottle |
| Générer le fichier `.ics` conforme RFC 5545 (VEVENT : titre, date, heure, lieu, description) |
| Forcer le téléchargement du fichier avec le bon `Content-Type: text/calendar` |
| Ajouter un bouton "Exporter .ics" dans la page de détail de l'événement |
| Gérer le cas 404 si l'événement n'existe pas |

---

### #9 · Exporter tout le calendrier en .ics *(3 pts)*

| Tâche technique |
|-----------------|
| Créer la route GET `/export` dans Bottle |
| Générer un fichier `.ics` agrégeant tous les événements de la base (VCALENDAR complet) |
| Nommer dynamiquement le fichier (ex : `gestionevents_<date>.ics`) |
| Ajouter un bouton "Tout exporter" dans l'en-tête ou la page d'accueil |

---

### #12 · Rechercher un événement par mot-clé *(5 pts)*

| Tâche technique |
|-----------------|
| Ajouter un champ de recherche dans `index.html` (formulaire GET avec paramètre `?q=`) |
| Modifier la route GET `/` pour accepter le paramètre `q` |
| Écrire la requête SQL `LIKE` sur le titre et la description |
| Afficher le terme recherché et le nombre de résultats dans la page |
| Cumuler la recherche avec le filtre catégorie existant (`?q=&categorie=`) |
| Gérer l'affichage "Aucun résultat" si aucun événement ne correspond |

---

### #11 · Créer un compte et se connecter *(5 pts)*

| Tâche technique |
|-----------------|
| Créer la table `users` en base (id, username, email, password_hash) |
| Créer la route GET/POST `/register` (formulaire d'inscription + insertion en base) |
| Hasher le mot de passe avec `bcrypt` ou `hashlib` avant stockage |
| Créer la route GET/POST `/login` (vérification des identifiants + session Bottle) |
| Créer la route GET `/logout` (destruction de la session) |
| Protéger les routes de création/modification/suppression d'événements (redirection si non connecté) |

---

## Répartition du travail

| Membre | Tâches assignées | Points |
|--------|-----------------|--------|
| Killian | Exporter un événement en fichier .ics | #10 — 5 pts |
| Alexandre | Exporter tout le calendrier en .ics | #9 — 3 pts |
| Pierre | Rechercher un événement par mot-clé | #12 — 5 pts |
| Alexis | Créer un compte et se connecter | #11 — 5 pts |

---

## Points d'attention issus de la Rétrospective 2

- Faire une **revue de code croisée** avant chaque merge sur `main`
- Tester systématiquement les **cas d'erreur** (fichier vide, événement inexistant, requête sans résultat) en plus du cas nominal

---

## Critères de succès du Sprint

- [ ] Un événement peut être téléchargé au format `.ics` valide importable dans un agenda (#10)
- [ ] Le calendrier entier peut être exporté en un seul fichier `.ics` (#9)
- [ ] La recherche par mot-clé filtre correctement les événements par titre et description (#12)
- [ ] Un utilisateur peut créer un compte, se connecter et se déconnecter (#11)
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
