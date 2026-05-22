% rebase('layout')
<div class="auth-wrapper">
    <div class="auth-card">
        <h1>Créer un compte</h1>

        % if errors.get('global'):
        <div class="alert alert-error">{{errors['global']}}</div>
        % end

        <form method="POST" action="/register" novalidate>
            <div class="form-group {{'error' if errors.get('nom') else ''}}">
                <label for="nom">Pseudo <span class="required">*</span></label>
                <input
                    type="text"
                    id="nom"
                    name="nom"
                    value="{{form.get('nom', '')}}"
                    placeholder="ton_pseudo"
                    autocomplete="username"
                    required
                >
                % if errors.get('nom'):
                <span class="error-msg">{{errors['nom']}}</span>
                % end
            </div>

            <div class="form-group {{'error' if errors.get('email') else ''}}">
                <label for="email">Email <span class="required">*</span></label>
                <input
                    type="email"
                    id="email"
                    name="email"
                    value="{{form.get('email', '')}}"
                    placeholder="email@example.com"
                    autocomplete="email"
                    required
                >
                % if errors.get('email'):
                <span class="error-msg">{{errors['email']}}</span>
                % end
            </div>

            <div class="form-group {{'error' if errors.get('password') else ''}}">
                <label for="password">Mot de passe <span class="required">*</span></label>
                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="6 caractères minimum"
                    autocomplete="new-password"
                    required
                >
                % if errors.get('password'):
                <span class="error-msg">{{errors['password']}}</span>
                % end
            </div>

            <div class="form-group {{'error' if errors.get('confirm') else ''}}">
                <label for="confirm">Confirmer le mot de passe <span class="required">*</span></label>
                <input
                    type="password"
                    id="confirm"
                    name="confirm"
                    placeholder="••••••••"
                    autocomplete="new-password"
                    required
                >
                % if errors.get('confirm'):
                <span class="error-msg">{{errors['confirm']}}</span>
                % end
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary btn-block">Créer mon compte</button>
            </div>
        </form>

        <p class="auth-link">Déjà un compte ? <a href="/login">Se connecter</a></p>
    </div>
</div>
