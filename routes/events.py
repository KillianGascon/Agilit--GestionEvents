import psycopg2.extras
from bottle import request, template, redirect

from db import get_db


def register(app):

    @app.route("/")
    def index():
        with get_db() as conn:
            with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                cur.execute(
                    "SELECT id, titre, date_evenement, heure_debut, lieu, categorie, categorie_couleur"
                    " FROM v_events_detail"
                )
                events = cur.fetchall()
        return template("event_list", events=events)

    @app.route("/events/new", method=["GET", "POST"])
    def new_event():
        errors = {}
        success = request.query.get("success") == "1"

        with get_db() as conn:
            with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                cur.execute("SELECT id, nom, couleur FROM categories ORDER BY nom")
                categories = cur.fetchall()

        if request.method == "POST":
            titre = request.forms.get("titre", "").strip()
            date_evenement = request.forms.get("date_evenement", "").strip()
            heure_debut = request.forms.get("heure_debut", "").strip()
            heure_fin = request.forms.get("heure_fin", "").strip()
            lieu = request.forms.get("lieu", "").strip()
            description = request.forms.get("description", "").strip()
            categorie_id = request.forms.get("categorie_id", "").strip()

            if not titre:
                errors["titre"] = "Le titre est obligatoire."
            if not date_evenement:
                errors["date_evenement"] = "La date est obligatoire."
            if heure_debut and heure_fin and heure_fin <= heure_debut:
                errors["heure_fin"] = "L'heure de fin doit être après l'heure de début."

            if not errors:
                with get_db() as conn:
                    with conn.cursor() as cur:
                        cur.execute(
                            "INSERT INTO events"
                            " (titre, date_evenement, heure_debut, heure_fin, lieu, description, categorie_id)"
                            " VALUES (%s, %s, %s, %s, %s, %s, %s)",
                            (
                                titre,
                                date_evenement,
                                heure_debut or None,
                                heure_fin or None,
                                lieu or None,
                                description or None,
                                int(categorie_id) if categorie_id else None,
                            ),
                        )
                redirect("/?success=1")

            return template("event_form", errors=errors, form=request.forms, categories=categories, success=False)

        return template("event_form", errors={}, form={}, categories=categories, success=success)
