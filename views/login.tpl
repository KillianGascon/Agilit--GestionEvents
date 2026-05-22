% rebase('layout')
<div class="auth-wrapper">
    <div class="auth-card">
        <h1>Connexion</h1>

        % if error:
        <div class="alert alert-error">{{error}}</div>
        % end

        <form method="POST" action="/login" novalidate>
            <div class="form-group">
                <label for="identifier">Pseudo ou email</label>
                <input
                    type="text"
                    id="identifier"
                    name="identifier"
                    value="{{form.get('identifier', '')}}"
                    placeholder="ton_pseudo ou email@example.com"
                    autocomplete="username"
                    required
                >
            </div>

            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="••••••••"
                    autocomplete="current-password"
                    required
                >
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary btn-block">Se connecter</button>
            </div>
        </form>

        <p class="auth-link">Pas encore de compte ? <a href="/register">Créer un compte</a></p>
    </div>
</div>
