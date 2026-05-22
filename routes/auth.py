import os
import bcrypt
import psycopg2
import psycopg2.extras
from bottle import request, template, redirect, response

from db import get_db

SECRET_KEY = os.environ.get("SECRET_KEY", "dev-secret")


def get_current_user():
    user_id = request.get_cookie("user_id", secret=SECRET_KEY)
    if not user_id:
        return None
    conn = get_db()
    try:
        with conn:
            with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                cur.execute("SELECT id, nom, email FROM users WHERE id = %s", (user_id,))
                return cur.fetchone()
    finally:
        conn.close()


def register(app):

    @app.route("/login", method=["GET", "POST"])
    def login():
        if get_current_user():
            redirect("/")

        error = None

        if request.method == "POST":
            identifier = request.forms.get("identifier", "").strip()
            password = request.forms.get("password", "").encode()

            if not identifier or not password:
                error = "Tous les champs sont obligatoires."
            else:
                conn = get_db()
                try:
                    with conn:
                        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
                            cur.execute(
                                "SELECT id, mot_de_passe FROM users"
                                " WHERE nom = %s OR email = %s",
                                (identifier, identifier),
                            )
                            user = cur.fetchone()
                finally:
                    conn.close()

                if user and bcrypt.checkpw(password, user["mot_de_passe"].encode()):
                    response.set_cookie(
                        "user_id",
                        str(user["id"]),
                        secret=SECRET_KEY,
                        max_age=86400 * 7,
                        httponly=True,
                        path="/",
                    )
                    redirect("/")
                else:
                    error = "Identifiant ou mot de passe incorrect."

        return template("login", error=error, form=request.forms)

    @app.route("/register", method=["GET", "POST"])
    def register_view():
        if get_current_user():
            redirect("/")

        errors = {}

        if request.method == "POST":
            nom = request.forms.get("nom", "").strip()
            email = request.forms.get("email", "").strip().lower()
            password = request.forms.get("password", "")
            confirm = request.forms.get("confirm", "")

            if not nom:
                errors["nom"] = "Le pseudo est obligatoire."
            elif len(nom) < 3:
                errors["nom"] = "Le pseudo doit faire au moins 3 caractères."

            if not email or "@" not in email:
                errors["email"] = "L'adresse email est invalide."

            if not password:
                errors["password"] = "Le mot de passe est obligatoire."
            elif len(password) < 6:
                errors["password"] = "Le mot de passe doit faire au moins 6 caractères."

            if password and confirm != password:
                errors["confirm"] = "Les mots de passe ne correspondent pas."

            if not errors:
                password_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()
                user_id = None
                conn = get_db()
                try:
                    with conn:
                        with conn.cursor() as cur:
                            cur.execute(
                                "INSERT INTO users (nom, email, mot_de_passe)"
                                " VALUES (%s, %s, %s) RETURNING id",
                                (nom, email, password_hash),
                            )
                            user_id = cur.fetchone()[0]
                except psycopg2.errors.UniqueViolation as e:
                    detail = str(e).lower()
                    if "nom" in detail:
                        errors["nom"] = "Ce pseudo est déjà pris."
                    else:
                        errors["email"] = "Cet email est déjà utilisé."
                except psycopg2.Error as e:
                    import traceback
                    traceback.print_exc()
                    errors["global"] = f"Erreur DB : {type(e).__name__}: {e}"
                finally:
                    conn.close()

                if user_id is not None:
                    response.set_cookie(
                        "user_id",
                        str(user_id),
                        secret=SECRET_KEY,
                        max_age=86400 * 7,
                        httponly=True,
                        path="/",
                    )
                    redirect("/")

        return template("register", errors=errors, form=request.forms)

    @app.route("/logout", method="POST")
    def logout():
        response.delete_cookie("user_id", path="/")
        redirect("/login")
