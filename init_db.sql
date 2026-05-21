-- ============================================================
--  GestionEvents — Script de création de la base de données
--  PostgreSQL 14+
--  Usage : psql -U <user> -d <database> -f init_db.sql
-- ============================================================

-- Extension pour la génération d'UUID (optionnel mais recommandé)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
--  TABLE : categories
--  Référentiel des catégories d'événements (Pro, Privé, Urgent…)
-- ============================================================
CREATE TABLE IF NOT EXISTS categories (
    id          SERIAL          PRIMARY KEY,
    nom         VARCHAR(50)     NOT NULL UNIQUE,
    couleur     VARCHAR(7)      DEFAULT '#6366f1',   -- code hex pour l'UI
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- Données de référence
INSERT INTO categories (nom, couleur) VALUES
    ('Pro',    '#3b82f6'),
    ('Privé',  '#10b981'),
    ('Urgent', '#ef4444'),
    ('Autre',  '#8b5cf6')
ON CONFLICT (nom) DO NOTHING;


-- ============================================================
--  TABLE : users
--  Gestion des comptes utilisateurs (US-12)
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id            SERIAL          PRIMARY KEY,
    nom           VARCHAR(100)    NOT NULL,
    email         VARCHAR(255)    NOT NULL UNIQUE,
    mot_de_passe  VARCHAR(255)    NOT NULL,           -- stocké haché (bcrypt)
    created_at    TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- Index sur l'email pour les lookups de connexion
CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);


-- ============================================================
--  TABLE : events
--  Table principale des événements
-- ============================================================
CREATE TABLE IF NOT EXISTS events (
    id              SERIAL          PRIMARY KEY,
    titre           VARCHAR(200)    NOT NULL,
    date_evenement  DATE            NOT NULL,
    heure_debut     TIME,
    heure_fin       TIME,
    lieu            VARCHAR(255),
    description     TEXT,
    categorie_id    INT             REFERENCES categories(id) ON DELETE SET NULL,
    createur_id     INT             REFERENCES users(id) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    -- Contrainte : heure_fin doit être après heure_debut si les deux sont renseignées
    CONSTRAINT chk_heures CHECK (
        heure_fin IS NULL OR heure_debut IS NULL OR heure_fin > heure_debut
    )
);

-- Index pour les tris et filtres fréquents
CREATE INDEX IF NOT EXISTS idx_events_date        ON events (date_evenement);
CREATE INDEX IF NOT EXISTS idx_events_categorie   ON events (categorie_id);
CREATE INDEX IF NOT EXISTS idx_events_createur    ON events (createur_id);
-- Index full-text pour la recherche par mot-clé (US-11)
CREATE INDEX IF NOT EXISTS idx_events_search      ON events
    USING GIN (to_tsvector('french', titre || ' ' || COALESCE(lieu, '')));


-- ============================================================
--  FONCTION + TRIGGER : mise à jour automatique de updated_at
-- ============================================================
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE OR REPLACE TRIGGER trg_events_updated_at
    BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();


-- ============================================================
--  DONNÉES DE TEST (à supprimer en production)
-- ============================================================

-- Utilisateur de test (mot de passe : "password123" — haché avec bcrypt)
INSERT INTO users (nom, email, mot_de_passe) VALUES
    ('Alice Dupont',  'alice@example.com',  '$2b$12$placeholder_hash_alice'),
    ('Bob Martin',    'bob@example.com',    '$2b$12$placeholder_hash_bob')
ON CONFLICT (email) DO NOTHING;

-- Événements de test
INSERT INTO events (titre, date_evenement, heure_debut, heure_fin, lieu, description, categorie_id, createur_id) VALUES
    ('Réunion d''équipe',        '2026-06-10', '09:00', '10:00', 'Salle A',         'Point hebdomadaire de l''équipe dev.',          1, 1),
    ('Anniversaire de Bob',      '2026-06-15', '19:00', '23:00', 'Chez Bob',        'Fêter les 30 ans de Bob !',                     2, 1),
    ('Déploiement v1.0',         '2026-06-20', '14:00', '15:00', 'En ligne',        'Mise en production de GestionEvents.',          3, 2),
    ('Atelier Scrum',            '2026-06-25', '10:00', '12:00', 'Salle de conf.',  'Formation aux cérémonies Scrum.',               1, 2)
ON CONFLICT DO NOTHING;


-- ============================================================
--  VUES UTILES
-- ============================================================

-- Vue enrichie des événements avec le nom de la catégorie
CREATE OR REPLACE VIEW v_events_detail AS
SELECT
    e.id,
    e.titre,
    e.date_evenement,
    e.heure_debut,
    e.heure_fin,
    e.lieu,
    e.description,
    e.categorie_id,
    c.nom         AS categorie,
    c.couleur     AS categorie_couleur,
    u.nom         AS createur,
    e.created_at,
    e.updated_at
FROM events e
LEFT JOIN categories c ON e.categorie_id = c.id
LEFT JOIN users      u ON e.createur_id  = u.id
ORDER BY e.date_evenement ASC, e.heure_debut ASC;
