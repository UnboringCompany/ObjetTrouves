### Objets Trouvés SNCF
Ce projet est une application Flutter pour afficher et rechercher des objets trouvés dans les gares SNCF. L'application utilise l'API de la SNCF pour récupérer les données des objets trouvés et les affiche dans une interface utilisateur conviviale.

## Fonctionnalités
Écran d'accueil : Affiche les derniers objets trouvés depuis la dernière connexion.
Filtres de recherche : Permet de rechercher des objets spécifiques en fonction de la gare d'origine, du type d'objet et de la date.
Sauvegarde de la date de dernière connexion : Utilise SharedPreferences pour sauvegarder la date de la dernière connexion afin de ne montrer que les nouveaux objets trouvés.
Son de démarrage : Joue un son de démarrage lors du lancement de l'application.

## Structure du Projet
StartPage : Écran de démarrage qui affiche un GIF et joue un son de démarrage.
HomePage : Écran principal qui affiche les objets trouvés depuis la dernière connexion.
FilteredPage : Écran de recherche avancée permettant de filtrer les objets trouvés par gare, type et date.
API_call : Fonctions pour interagir avec l'API de la SNCF et récupérer les données des objets trouvés.

## Dépendances
flutter/material.dart : Pour les composants de l'interface utilisateur.
http : Pour les requêtes HTTP.
shared_preferences : Pour sauvegarder et récupérer les préférences utilisateur.
audioplayers : Pour jouer des sons.
intl : Pour formater les dates.

## Installation
# Clonez le dépôt :
git clone https://github.com/votre-utilisateur/votre-projet.git

# Accédez au répertoire du projet :
cd votre-projet

# Installez les dépendances :
flutter pub get

# Lancez l'application :
flutter run

## Utilisation
# Écran d'accueil
L'écran d'accueil affiche les objets trouvés depuis la dernière connexion. Si aucun objet n'a été trouvé, un message approprié est affiché.

# Recherche avancée
L'écran de recherche avancée permet de filtrer les objets trouvés par gare d'origine, type d'objet et date. Les résultats sont affichés en temps réel.
