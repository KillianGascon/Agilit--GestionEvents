"""
Utilitaires pour la génération de fichiers iCalendar (.ics).

Fonctions exportées :
  - event_to_vevent(event)              : construit un VEVENT à partir d'un dict événement
  - build_calendar_from_events(events)  : construit le VCALENDAR complet (1 ou N événements)

Utilisation typique (export d'un seul événement) :
    cal = build_calendar_from_events([event])
    ics_bytes = cal.to_ical()

Utilisation typique (export du calendrier complet, par un collègue) :
    cal = build_calendar_from_events(all_events)
    ics_bytes = cal.to_ical()
"""

import datetime
import uuid

from icalendar import Calendar, Event, vText


# ---------------------------------------------------------------------------
# Constante produit (identifiant de l'application dans l'en-tête PRODID)
# ---------------------------------------------------------------------------
_PRODID = "-//Agilit GestionEvents//FR"


def event_to_vevent(event: dict) -> Event:
    """
    Convertit un dict événement (tel que retourné par la DB) en composant VEVENT.

    Champs attendus dans `event` :
        id              int  — identifiant unique en base
        titre           str  — résumé / titre de l'événement
        date_evenement  date — date de l'événement
        heure_debut     timedelta|time|None — heure de début
        heure_fin       timedelta|time|None — heure de fin (optionnel)
        lieu            str|None
        description     str|None

    Retourne un objet icalendar.Event prêt à être ajouté à un Calendar.
    """
    vevent = Event()

    # --- UID unique et stable (basé sur l'id en base) ----------------------
    vevent.add("uid", f"event-{event['id']}@agilit-gestionevents")

    # --- DTSTAMP : horodatage de génération (UTC) ---------------------------
    vevent.add("dtstamp", datetime.datetime.now(tz=datetime.timezone.utc))

    # --- SUMMARY (obligatoire) ---------------------------------------------
    vevent.add("summary", vText(event["titre"]))

    # --- DTSTART / DTEND ---------------------------------------------------
    date = event["date_evenement"]
    # date_evenement peut être un objet date ou datetime selon le driver
    if hasattr(date, "date"):
        date = date.date()

    def _to_time(val) -> datetime.time | None:
        """Normalise timedelta, time ou None en datetime.time."""
        if val is None:
            return None
        if isinstance(val, datetime.timedelta):
            total = int(val.total_seconds())
            return datetime.time(total // 3600, (total % 3600) // 60)
        if isinstance(val, datetime.time):
            return val
        return None

    heure_debut = _to_time(event.get("heure_debut"))
    heure_fin   = _to_time(event.get("heure_fin"))

    if heure_debut:
        dtstart = datetime.datetime(
            date.year, date.month, date.day,
            heure_debut.hour, heure_debut.minute,
        )
        if heure_fin:
            dtend = datetime.datetime(
                date.year, date.month, date.day,
                heure_fin.hour, heure_fin.minute,
            )
        else:
            # Pas d'heure de fin : durée par défaut d'1 heure
            dtend = dtstart + datetime.timedelta(hours=1)
        vevent.add("dtstart", dtstart)
        vevent.add("dtend",   dtend)
    else:
        # Événement sur la journée entière
        vevent.add("dtstart", date)
        vevent.add("dtend",   date + datetime.timedelta(days=1))

    # --- LOCATION (optionnel) ----------------------------------------------
    if event.get("lieu"):
        vevent.add("location", vText(event["lieu"]))

    # --- DESCRIPTION (optionnel) -------------------------------------------
    if event.get("description"):
        vevent.add("description", vText(event["description"]))

    return vevent


def build_calendar_from_events(events: list[dict]) -> Calendar:
    """
    Construit un objet Calendar iCalendar à partir d'une liste d'événements.

    Chaque élément de `events` doit être compatible avec event_to_vevent().

    Exemple — export d'un seul événement :
        cal = build_calendar_from_events([event])

    Exemple — export du calendrier complet (usage collègue) :
        cal = build_calendar_from_events(all_events)

    Retourne un objet icalendar.Calendar.
    Appeler cal.to_ical() pour obtenir les bytes à envoyer au client.
    """
    cal = Calendar()
    cal.add("prodid", _PRODID)
    cal.add("version", "2.0")
    cal.add("calscale", "GREGORIAN")
    cal.add("method", "PUBLISH")
    # Nom affiché dans les clients calendrier (Google Cal, Apple Cal…)
    cal.add("x-wr-calname", "GestionEvents")
    cal.add("x-wr-timezone", "Europe/Paris")

    for event in events:
        cal.add_component(event_to_vevent(event))

    return cal
