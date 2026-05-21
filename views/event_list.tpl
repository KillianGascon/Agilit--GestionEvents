% rebase('layout')
<div class="page-header">
    <h1>Événements</h1>
    <a href="/events/new" class="btn btn-primary">+ Nouvel événement</a>
</div>

% if not events:
<div class="empty-state">
    <p>Aucun événement pour le moment.</p>
    <a href="/events/new" class="btn btn-primary">Créer le premier événement</a>
</div>
% else:
<div class="events-grid">
    % for e in events:
    <a href="/events/{{e['id']}}" class="event-card-link">
    <div class="event-card">
        % if e['categorie']:
        <span class="badge" style="background:{{e['categorie_couleur'] or '#6366f1'}}">{{e['categorie']}}</span>
        % end
        <h2 class="event-card-titre">{{e['titre']}}</h2>
        <div class="event-card-meta">
            <div class="meta-item">
                <span class="meta-icon">📅</span>
                <span>{{e['date_evenement'].strftime('%d/%m/%Y')}}</span>
            </div>
            % if e['heure_debut']:
            <div class="meta-item">
                <span class="meta-icon">🕐</span>
                <span>{{e['heure_debut'].strftime('%H:%M') if hasattr(e['heure_debut'], 'strftime') else str(e['heure_debut'])[:5]}}</span>
            </div>
            % end
            % if e['lieu']:
            <div class="meta-item">
                <span class="meta-icon">📍</span>
                <span>{{e['lieu']}}</span>
            </div>
            % end
            % if e.get('description'):
            <div class="meta-item meta-description">
                <span>{{e['description']}}</span>
            </div>
            % end
        </div>
    </div>
    </a>
    % end
</div>
% end
