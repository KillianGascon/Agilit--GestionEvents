# Daily Scrum 1 — GestionEvents

> **Date :** 2026-05-19  
> **Sprint :** 1 / 3

---

## Pierre — US-04 · Initialiser le projet et le README

**Ce que j'ai fait :** Rien pour l'instant, début du sprint.

**Ce que je vais faire :**
- Créer le repository GitHub et configurer le `.gitignore`
- Rédiger le `README.md` avec la description, la stack et les instructions de lancement
- Créer le `requirements.txt` avec les dépendances initiales

**Mes blocages :** Aucun

---

## Alexis — US-03 · Mettre en place la base de données et les modèles

**Ce que j'ai fait :** Rien pour l'instant, début du sprint.

**Ce que je vais faire :**
- Rédiger le script SQL de création de la table `events`
- Créer le fichier de configuration pour les variables de connexion
- Implémenter le module de connexion Python/Bottle → PostgreSQL
- Tester la connexion et versionner le script sur Git

**Mes blocages :** Aucun

---

## Alexandre — US-01 · Afficher la liste des événements

**Ce que j'ai fait :** Rien pour l'instant, début du sprint.

**Ce que je vais faire :**
- Créer la route GET `/` dans Bottle
- Écrire la requête SQL de récupération des événements triés par date
- Créer le template HTML `index.html` avec titre, date, heure et lieu
- Gérer le message "Aucun événement" si la liste est vide

**Mes blocages :** Aucun

---

## Killian — US-02 · Créer un nouvel événement

**Ce que j'ai fait :** Rien pour l'instant, début du sprint.

**Ce que je vais faire :**
- Créer la route GET `/new` pour afficher le formulaire
- Créer le template HTML `new_event.html` avec les champs requis
- Créer la route POST `/new` pour traiter et insérer l'événement en base
- Implémenter la validation des champs obligatoires titre et date
- Rediriger vers la liste après soumission réussie

**Mes blocages :** Aucun

---

## Fiona — US-T1 · Mettre en place l'interface graphique de base

**Ce que j'ai fait :** Rien pour l'instant, début du sprint.

**Ce que je vais faire :**
- Créer le template `base.html` avec la barre de navigation
- Créer et intégrer la feuille de style `static/css/style.css`
- Adapter `index.html` et `new_event.html` pour hériter de `base.html`

**Mes blocages :** Aucun
