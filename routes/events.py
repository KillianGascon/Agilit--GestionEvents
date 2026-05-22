import psycopg2.extras
from bottle import request, template, redirect, response, abort

from db import get_db
from ics_utils import build_calendar_from_events


def register(app):

    @app.route("/")
    def index():
        with get_db() as conn:
            with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                cur.execute(
                    "SELECT e.id, e.titre, e.date_evenement, e.heure_debut, e.lieu,"
                    " e.categorie_id, c.nom AS categorie, c.couleur AS categorie_couleur"
                    " FROM events e"
                    " LEFT JOIN categories c ON e.categorie_id = c.id"
                    " ORDER BY e.date_evenement ASC, e.heure_debut ASC"
                )
                events = cur.fetchall()

            with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                cur.execute("SELECT id, nom, couleur FROM categories ORDER BY nom")
                categories = cur.fetchall()

        return template("event_list", events=events, categories=categories)

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

    @app.route("/events/<event_id:int>/edit", method=["GET", "POST"])
    def event_edit(event_id):
        with get_db() as conn:
            with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                cur.execute(
                    "SELECT id, titre, date_evenement, heure_debut, heure_fin,"
                    " lieu, description, categorie_id"
                    " FROM events WHERE id = %s",
                    (event_id,),
                )
                event = cur.fetchone()
        if not event:
            from bottle import abort
            abort(404, "Événement introuvable.")

        with get_db() as conn:
            with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                cur.execute("SELECT id, nom, couleur FROM categories ORDER BY nom")
                categories = cur.fetchall()

        errors = {}

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
                            "UPDATE events SET titre=%s, date_evenement=%s, heure_debut=%s,"
                            " heure_fin=%s, lieu=%s, description=%s, categorie_id=%s"
                            " WHERE id=%s",
                            (
                                titre,
                                date_evenement,
                                heure_debut or None,
                                heure_fin or None,
                                lieu or None,
                                description or None,
                                int(categorie_id) if categorie_id else None,
                                event_id,
                            ),
                        )
                redirect(f"/events/{event_id}")

            return template("event_edit", errors=errors, form=request.forms, event=event, categories=categories)

        return template("event_edit", errors={}, form=event, event=event, categories=categories)

    @app.route("/events/<event_id:int>/delete", method="POST")
    def event_delete(event_id):
        with get_db() as conn:
            with conn.cursor() as cur:
                cur.execute("DELETE FROM events WHERE id = %s", (event_id,))
        redirect("/?deleted=1")

    @app.route("/events/<event_id:int>/export.ics")
    def event_export_ics(event_id):
        """Télécharge l'événement au format iCalendar (.ics)."""
        with get_db() as conn:
            with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                cur.execute(
                    "SELECT id, titre, date_evenement, heure_debut, heure_fin,"
                    " lieu, description"
                    " FROM events WHERE id = %s",
                    (event_id,),
                )
                event = cur.fetchone()
        if not event:
            abort(404, "Événement introuvable.")

        cal = build_calendar_from_events([event])
        ics_bytes = cal.to_ical()

        # Nom de fichier sûr (sans caractères spéciaux)
        safe_titre = "".join(
            c if c.isalnum() or c in "-_ " else "_"
            for c in (event["titre"] or "evenement")
        ).strip().replace(" ", "_")
        filename = f"{safe_titre}_{event_id}.ics"

        response.content_type = "text/calendar; charset=utf-8"
        response.headers["Content-Disposition"] = f'attachment; filename="{filename}"'
        return ics_bytes

    @app.route("/events/<event_id:int>")
    def event_detail(event_id):
        with get_db() as conn:
            with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                cur.execute(
                    "SELECT id, titre, date_evenement, heure_debut, heure_fin,"
                    " lieu, description, categorie, categorie_couleur, createur,"
                    " created_at, updated_at"
                    " FROM v_events_detail WHERE id = %s",
                    (event_id,),
                )
                event = cur.fetchone()
        if not event:
            from bottle import abort
            abort(404, "Événement introuvable.")
        return template("event_detail", event=event)
