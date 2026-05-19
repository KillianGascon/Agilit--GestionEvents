# Fiche Projet : GestionEvents

## Description courte
**GestionEvents** est une application web de gestion d'événements collaborative. Elle permet à des groupes d'utilisateurs de planifier, centraliser et gérer des événements en commun, avec une fonctionnalité clé d'export au format standard `.ics` (iCalendar) pour une synchronisation facile avec les agendas personnels (Google Calendar, Outlook, Apple Calendar).

## Problème résolu
Aujourd'hui, l'organisation d'événements au sein d'un groupe (famille, collègues, amis) est souvent éparpillée (messages WhatsApp, e-mails, post-its). **GestionEvents** centralise l'information de manière collaborative, évitant les doublons, les oublis et facilitant l'intégration des événements dans les outils de calendrier du quotidien grâce à l'export ICS.

## Utilisateurs cibles
L'application s'adresse à tout type de groupe ayant besoin de se coordonner :
* **Groupes de travail / Associatifs :** pour planifier des réunions, des ateliers ou des jalons.
* **Groupes familiaux / Amis :** pour organiser des repas, des vacances, des anniversaires ou des tâches partagées.

## Fonctionnalités principales envisagées
1. **Création et édition d'un événement** (Titre, date, heure, description, lieu).
2. **Visualisation collaborative** sous forme de liste et/ou de calendrier global interactif.
3. **Système de catégories / tags** pour filtrer les événements (ex: Privé, Pro, Urgent).
4. **Export au format `.ics`** (individuel ou de tout le calendrier).
5. *(Optionnel selon le temps)* Gestion de comptes utilisateurs basique et invitations.

## Stack technique choisie
* **Backend & Front (Rendu) :** Python avec le micro-framework **Bottle** (utilisation du moteur de template natif de Bottle pour générer les pages HTML/CSS).
* **Base de données :** PostgreSQL.

## Contraintes identifiées
* **Le Temps (Contrainte majeure) :** 3 demi-journées, c'est extrêmement court. Il faudra se concentrer sur un MVP (Produit Minimum Viable) ultra-simplifié lors du Sprint 1.
* **Travail en équipe et Git :** Nécessité de bien découper les tâches pour éviter les conflits de fusion (merge conflicts) sur GitHub lors des pushs rapides.

## Risques techniques
* **La dette technologique (et le blocage technique) :** Risque de perdre du temps sur la configuration initiale (connexion Python/Bottle PostgreSQL, ou configuration de la base de données).
* **Génération du fichier ICS :** La structure d'un fichier `.ics` répond à une norme stricte (RFC 5545). Si la librairie Python choisie (ex: `icalendar`) est mal maîtrisée, cela peut bloquer l'équipe.
