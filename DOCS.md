# Documentation technique — GestionEvents

> Projet réalisé en 3 sprints (3 demi-journées) dans le cadre du cours Agilité.  
> Équipe : Alexandre, Alexis, Fiona, Killian, Pierre

---

## Sommaire

1. [Architecture générale](#architecture-générale)
2. [Structure des fichiers](#structure-des-fichiers)
3. [Base de données](#base-de-données)
4. [Routes de l'application](#routes-de-lapplication)
5. [Authentification](#authentification)
6. [Export ICS](#export-ics)
7. [Variables d'environnement](#variables-denvironnement)
8. [Lancer l'application](#lancer-lapplication)

---

## Architecture générale

L'application suit une architecture **MVC légère** :

```
Navigateur → Bottle (routes) → PostgreSQL
                   ↓
              Templates .tpl (Bottle SimpleTemplate)
```

- **Backend :** Python 3 + Bottle (micro-framework)
- **Base de données :** PostgreSQL (connexion via `psycopg2`)
- **Templates :** moteur natif Bottle (fichiers `.tpl` dans `views/`)
- **CSS :** feuille de style unique `static/css/style.css`

---

## Structure des fichiers

```
├── app.py                  # Point d'entrée — création de l'app Bottle
├── db.py                   # Connexion PostgreSQL (get_db)
├── ics_utils.py            # Génération de fichiers .ics (RFC 5545)
├── requirements.txt        # Dépendances Python
├── .env                    # Variables d'environnement (non versionné)
│
├── routes/
│   ├── __init__.py
│   ├── events.py           # Routes événements (CRUD + export ICS)
│   └── auth.py             # Routes authentification (login, register, logout)
│
├── views/
│   ├── layout.tpl          # Template de base (navbar, structure HTML)
│   ├── event_list.tpl      # Liste des événements + filtre + recherche
│   ├── event_detail.tpl    # Détail d'un événement
│   ├── event_form.tpl      # Formulaire de création
│   ├── event_edit.tpl      # Formulaire de modification
│   ├── login.tpl           # Page de connexion
│   └── register.tpl        # Page d'inscription
│
├── static/
│   └── css/style.css       # Styles globaux
│
└── SCRUM/
    ├── PLANNING/           # Planning1.md, Planning2.md, Planning3.md
    ├── DAILY/              # Daily1.md, Daily2.md, Daily3.md
    ├── REVIEW/             # Review1.md, Review2.md, Review3.md
    └── RETRO/              # Retro1.md, Retro2.md, Retro3.md
```

---

## Base de données

### Table `events`

| Colonne | Type | Description |
|---------|------|-------------|
| `id` | SERIAL PK | Identifiant unique |
| `titre` | VARCHAR | Titre de l'événement (obligatoire) |
| `date_evenement` | DATE | Date (obligatoire) |
| `heure_debut` | TIME | Heure de début (optionnel) |
| `heure_fin` | TIME | Heure de fin (optionnel) |
| `lieu` | VARCHAR | Lieu (optionnel) |
| `description` | TEXT | Description (optionnel) |
| `categorie_id` | FK → categories | Catégorie (optionnel) |

### Table `categories`

| Colonne | Type | Description |
|---------|------|-------------|
| `id` | SERIAL PK | Identifiant unique |
| `nom` | VARCHAR | Nom de la catégorie |
| `couleur` | VARCHAR | Couleur hexadécimale (ex: `#e67e22`) |

### Table `users`

| Colonne | Type | Description |
|---------|------|-------------|
| `id` | SERIAL PK | Identifiant unique |
| `nom` | VARCHAR UNIQUE | Pseudo (min. 3 caractères) |
| `email` | VARCHAR UNIQUE | Adresse email |
| `mot_de_passe` | VARCHAR | Hash bcrypt du mot de passe |

---

## Routes de l'application

### Événements

| Méthode | Route | Description |
|---------|-------|-------------|
| GET | `/` | Liste des événements (filtre catégorie + recherche JS) |
| GET | `/events/new` | Formulaire de création |
| POST | `/events/new` | Création d'un événement |
| GET | `/events/<id>` | Détail d'un événement |
| GET | `/events/<id>/edit` | Formulaire de modification (pré-rempli) |
| POST | `/events/<id>/edit` | Mise à jour d'un événement |
| POST | `/events/<id>/delete` | Suppression d'un événement |
| GET | `/events/<id>/export.ics` | Export ICS d'un événement |
| GET | `/export.ics` | Export ICS de tous les événements |

### Authentification

| Méthode | Route | Description |
|---------|-------|-------------|
| GET/POST | `/login` | Connexion (pseudo ou email + mot de passe) |
| GET/POST | `/register` | Inscription |
| POST | `/logout` | Déconnexion |

---

## Authentification

- Les mots de passe sont hashés avec **bcrypt** avant stockage.
- La session est gérée via un **cookie signé** (`user_id`) avec la clé `SECRET_KEY`.
- Le cookie est `httponly` et expire après 7 jours.
- `get_current_user()` (dans `routes/auth.py`) est appelée depuis les templates via `layout.tpl` pour afficher ou non les boutons de connexion.

---

## Export ICS

Le module `ics_utils.py` expose deux fonctions :

- `event_to_vevent(event)` — convertit un dict événement en composant `VEVENT` (RFC 5545)
- `build_calendar_from_events(events)` — assemble un `VCALENDAR` complet

**Export individuel** → `GET /events/<id>/export.ics`  
Génère un fichier nommé `<titre>_<id>.ics`.

**Export global** → `GET /export.ics`  
Génère un fichier nommé `gestionevents_YYYYMMDD.ics` avec tous les événements triés par date.

Les fichiers sont importables dans Google Calendar, Apple Calendar et Outlook.

---

## Variables d'environnement

Fichier `.env` à créer à la racine (non versionné) :

```env
DATABASE_URL=postgresql://user:password@localhost:5432/gestionevents
SECRET_KEY=une-cle-secrete-longue-et-aleatoire
```

---

## Lancer l'application

```bash
# Installer les dépendances
pip install -r requirements.txt

# Créer le fichier .env (voir section ci-dessus)

# Lancer le serveur (port 8080, debug activé)
python app.py
```

L'application est accessible sur [http://localhost:8080](http://localhost:8080).
