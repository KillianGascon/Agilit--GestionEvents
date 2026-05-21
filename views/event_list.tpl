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
<div class="filtres">
    <button class="filtre-btn active" data-categorie="all" onclick="filterByCategory(null)" id="filter-all">
        Tous
    </button>
    % for categorie in categories:
    <button class="filtre-btn" data-categorie="{{categorie['id']}}" onclick="filterByCategory({{categorie['id']}})" id="filter-{{categorie['id']}}">
        {{categorie['nom']}}
    </button>
    % end
</div>
<div class="events-grid" id="events-grid">
    % for e in events:
    <a href="/events/{{e['id']}}" class="event-card-link">
    <div class="event-card" data-categorie-id="{{e['categorie_id'] if e.get('categorie_id') else ''}}" data-categorie="{{e['categorie'] if e.get('categorie') else ''}}">
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

<script>
let selectedFilter = null;
let isFilterActive = false;

function filterByCategory(categorieId) {
    if (categorieId === null || selectedFilter === categorieId) {
        selectedFilter = null;
        isFilterActive = false;
    } else {
        selectedFilter = categorieId;
        isFilterActive = true;
    }

    const eventCards = document.querySelectorAll('.event-card-link');
    const filterButtons = document.querySelectorAll('.filtre-btn');

    filterButtons.forEach(btn => {
        btn.classList.remove('active');
        if (!isFilterActive && btn.dataset.categorie === 'all') {
            btn.classList.add('active');
        } else if (isFilterActive && String(btn.dataset.categorie) === String(selectedFilter)) {
            btn.classList.add('active');
        }
    });

    eventCards.forEach(card => {
        const eventElement = card.querySelector('.event-card');
        const cardCategorieId = eventElement.dataset.categorieId;

        if (!isFilterActive) {
            card.style.display = '';
        } else if (String(cardCategorieId) === String(selectedFilter)) {
            card.style.display = '';
        } else {
            card.style.display = 'none';
        }
    });
}
</script>
