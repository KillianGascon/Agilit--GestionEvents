import os
import psycopg2
import psycopg2.extras
from dotenv import load_dotenv
from bottle import Bottle, run, template, request, redirect, static_file

load_dotenv()
app = Bottle()


def get_db():
    conn = psycopg2.connect(os.environ["DATABASE_URL"])
    return conn


@app.route("/static/<filepath:path>")
def serve_static(filepath):
    return static_file(filepath, root="./static")


@app.route("/")
def index():
    redirect("/events/new")


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
                        """INSERT INTO events
                           (titre, date_evenement, heure_debut, heure_fin, lieu, description, categorie_id)
                           VALUES (%s, %s, %s, %s, %s, %s, %s)""",
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
            redirect("/events/new?success=1")

        return template("event_form", errors=errors, form=request.forms, categories=categories, success=False)

    return template("event_form", errors={}, form={}, categories=categories, success=success)


if __name__ == "__main__":
    run(app, host="0.0.0.0", port=8080, debug=True, reloader=True)
