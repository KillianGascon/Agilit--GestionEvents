% rebase('layout')
<div class="detail-header">
    <a href="/" class="btn btn-back">&larr; Retour</a>
    <div class="detail-actions">
        <a href="/events/{{event['id']}}/edit" class="btn btn-primary">Modifier</a>
        <form action="/events/{{event['id']}}/delete" method="post" onsubmit="return confirm('Supprimer cet événement ? Cette action est irréversible.');">
            <button type="submit" class="btn btn-danger">Supprimer</button>
        </form>
    </div>
</div>

<div class="detail-card">
    <div class="detail-top">
        % if event['categorie']:
        <span class="badge" style="background:{{event['categorie_couleur'] or '#6366f1'}}">{{event['categorie']}}</span>
        % end
        <h1 class="detail-titre">{{event['titre']}}</h1>
    </div>

    <div class="detail-info-grid">
        <div class="detail-info-item">
            <span class="detail-label">Date</span>
            <span class="detail-value">{{event['date_evenement'].strftime('%d/%m/%Y')}}</span>
        </div>

        % if event['heure_debut']:
        <div class="detail-info-item">
            <span class="detail-label">Heure de début</span>
            <span class="detail-value">{{event['heure_debut'].strftime('%H:%M') if hasattr(event['heure_debut'], 'strftime') else str(event['heure_debut'])[:5]}}</span>
        </div>
        % end

        % if event['heure_fin']:
        <div class="detail-info-item">
            <span class="detail-label">Heure de fin</span>
            <span class="detail-value">{{event['heure_fin'].strftime('%H:%M') if hasattr(event['heure_fin'], 'strftime') else str(event['heure_fin'])[:5]}}</span>
        </div>
        % end

        % if event['lieu']:
        <div class="detail-info-item">
            <span class="detail-label">Lieu</span>
            <span class="detail-value">{{event['lieu']}}</span>
        </div>
        % end

        % if event['createur']:
        <div class="detail-info-item">
            <span class="detail-label">Créateur</span>
            <span class="detail-value">{{event['createur']}}</span>
        </div>
        % end
    </div>

    % if event['description']:
    <div class="detail-description">
        <span class="detail-label">Description</span>
        <p>{{event['description']}}</p>
    </div>
    % end

    <div class="detail-footer">
        <span class="detail-meta">Créé le {{event['created_at'].strftime('%d/%m/%Y à %H:%M')}}</span>
        % if event['updated_at'] and event['updated_at'] != event['created_at']:
        <span class="detail-meta">Modifié le {{event['updated_at'].strftime('%d/%m/%Y à %H:%M')}}</span>
        % end
    </div>
</div>
