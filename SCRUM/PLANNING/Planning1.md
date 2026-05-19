# Sprint Planning 1 — GestionEvents

> **Date :** 2026-05-19  
> **Sprint :** 1 / 3  
> **Durée :** 1/2 journée  
> **Équipe :** Agilité — GestionEvents  
> **Stack :** Python / Bottle · PostgreSQL

---

## Sprint Goal

Mettre en place la structure du projet et livrer une première liste d'événements démontrable.

---

## User Stories sélectionnées

| ID | Titre | Priorité | Points |
|----|-------|----------|--------|
| US-04 | Initialiser le projet et le README | Haute | 2 |
| US-03 | Mettre en place la base de données et les modèles | Haute | 5 |
| US-01 | Afficher la liste des événements | Haute | 3 |
| US-02 | Créer un nouvel événement | Haute | 5 |
| US-T1 | Mettre en place l'interface graphique de base | Haute | 3 |

**Total Sprint 1 : 18 points**

---

## Sprint Backlog

### US-04 · Initialiser le projet et le README *(2 pts)*

| Tâche technique |
|-----------------|
| Créer le repository GitHub et configurer `.gitignore` |
| Mettre en place la structure de dossiers (`routes/`, `templates/`, `static/`) |
| Rédiger le `README.md` (description, stack, installation, lancement) |
| Créer le `requirements.txt` avec les dépendances initiales (Bottle, psycopg2) |

---

### US-03 · Mettre en place la base de données et les modèles *(5 pts)*

| Tâche technique |
|-----------------|
| Rédiger le script SQL de création de la table `events` |
| Créer le fichier de configuration pour les variables de connexion (`.env` ou `config.py`) |
| Implémenter le module de connexion Python/Bottle → PostgreSQL |
| Tester la connexion et versionner le script sur Git |

---

### US-01 · Afficher la liste des événements *(3 pts)*

| Tâche technique |
|-----------------|
| Créer la route GET `/` dans Bottle |
| Écrire la requête SQL de récupération des événements triés par date |
| Créer le template HTML `index.html` (liste avec titre, date, heure, lieu) |
| Gérer l'affichage du message "Aucun événement" si la liste est vide |

---

### US-02 · Créer un nouvel événement *(5 pts)*

| Tâche technique |
|-----------------|
| Créer la route GET `/new` (affichage du formulaire) |
| Créer le template HTML `new_event.html` avec les champs requis |
| Créer la route POST `/new` (traitement et insertion en base) |
| Implémenter la validation des champs obligatoires (titre, date) |
| Rediriger vers la liste après soumission réussie |

---

### US-T1 · Mettre en place l'interface graphique de base *(3 pts)*

| Tâche technique |
|-----------------|
| Créer le template `base.html` avec navigation (liens Accueil / Nouvel événement) |
| Créer et intégrer la feuille de style `static/css/style.css` |
| Adapter `index.html` et `new_event.html` pour hériter de `base.html` |

---

## Répartition du travail

| Membre | Tâches assignées | Points |
|--------|-----------------|--------|
| Pierre | Setup projet | US-04 — 2 pts |
| Alexis | Base de données | US-03 — 5 pts |
| Alexandre | Liste événements | US-01 — 3 pts |
| Killian | Création événement | US-02 — 5 pts |
| Fiona | Interface graphique de base | US-T1 — 3 pts |

---

## Critères de succès du Sprint

- [ ] Le repository GitHub est structuré, clonable et documenté (US-04)
- [ ] La base de données PostgreSQL est initialisée et la connexion fonctionne (US-03)
- [ ] La page d'accueil affiche la liste des événements depuis la BDD (US-01)
- [ ] Un formulaire permet de créer un événement persisté en base (US-02)
- [ ] Toutes les pages partagent un template de base avec navigation et CSS cohérent (US-T1)
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
