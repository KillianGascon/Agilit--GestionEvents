% rebase('layout')
<div class="card">
    <h1>Modifier l'événement</h1>

    <form method="POST" action="/events/{{event['id']}}/edit" novalidate>

        <div class="form-group {{'error' if errors.get('titre') else ''}}">
            <label for="titre">Titre <span class="required">*</span></label>
            <input
                type="text"
                id="titre"
                name="titre"
                value="{{form.get('titre', '')}}"
                placeholder="Nom de l'événement"
                required
            >
            % if errors.get('titre'):
            <span class="error-msg">{{errors['titre']}}</span>
            % end
        </div>

        <div class="form-row">
            <div class="form-group {{'error' if errors.get('date_evenement') else ''}}">
                <label for="date_evenement">Date <span class="required">*</span></label>
                <input
                    type="date"
                    id="date_evenement"
                    name="date_evenement"
                    value="{{str(form.get('date_evenement', ''))[:10]}}"
                    required
                >
                % if errors.get('date_evenement'):
                <span class="error-msg">{{errors['date_evenement']}}</span>
                % end
            </div>

            <div class="form-group">
                <label for="categorie_id">Catégorie</label>
                <select id="categorie_id" name="categorie_id">
                    <option value="">-- Choisir --</option>
                    % for cat in categories:
                    <option
                        value="{{cat['id']}}"
                        {{'selected' if str(form.get('categorie_id', '')) == str(cat['id']) else ''}}
                    >{{cat['nom']}}</option>
                    % end
                </select>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="heure_debut">Heure de début</label>
                <input
                    type="time"
                    id="heure_debut"
                    name="heure_debut"
                    value="{{str(form.get('heure_debut', '') or '')[:5]}}"
                >
            </div>

            <div class="form-group {{'error' if errors.get('heure_fin') else ''}}">
                <label for="heure_fin">Heure de fin</label>
                <input
                    type="time"
                    id="heure_fin"
                    name="heure_fin"
                    value="{{str(form.get('heure_fin', '') or '')[:5]}}"
                >
                % if errors.get('heure_fin'):
                <span class="error-msg">{{errors['heure_fin']}}</span>
                % end
            </div>
        </div>

        <div class="form-group">
            <label for="lieu">Lieu</label>
            <input
                type="text"
                id="lieu"
                name="lieu"
                value="{{form.get('lieu', '') or ''}}"
                placeholder="Adresse ou nom du lieu"
            >
        </div>

        <div class="form-group">
            <label for="description">Description</label>
            <textarea
                id="description"
                name="description"
                rows="4"
                placeholder="Détails supplémentaires..."
            >{{form.get('description', '') or ''}}</textarea>
        </div>

        <div class="form-actions">
            <a href="/events/{{event['id']}}" class="btn btn-back">Annuler</a>
            <button type="submit" class="btn btn-primary">Enregistrer les modifications</button>
        </div>

    </form>
</div>
