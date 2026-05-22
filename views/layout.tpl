<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GestionEvents</title>
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
    <header>
        <nav>
            <a href="/" class="brand">GestionEvents</a>
            <div class="nav-right">
                % from routes.auth import get_current_user
                % user = get_current_user()
                % if user:
                <span class="nav-username">{{user['nom']}}</span>
                <a href="/events/new" class="btn btn-primary btn-sm">+ Nouvel événement</a>
                <form method="POST" action="/logout" style="margin:0">
                    <button type="submit" class="btn btn-ghost btn-sm">Déconnexion</button>
                </form>
                % else:
                <a href="/login" class="btn btn-ghost btn-sm">Connexion</a>
                <a href="/register" class="btn btn-primary btn-sm">Inscription</a>
                % end
            </div>
        </nav>
    </header>
    <main>
        {{!base}}
    </main>
</body>
</html>
