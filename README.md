# MyLifeStyle

MyLifeStyle er en iOS-app for å holde oversikt over kosthold, kalorier og daglige helsevaner.
Appen er bygget med fokus på enkel brukeropplevelse, tydelig visualisering av progresjon
og strukturert kode.

## Screenshots

<p align="center">
  <img src="screenshots/home_light.png" width="250">
  <img src="screenshots/nutrition_dark.png" width="250">
</p>

## Funksjonalitet

- 📊 Oversikt over daglige og ukentlige kalorimål
- 🍽 Registrering av måltider
- 🔄 Automatisk beregning av gjenstående kalorier
- 🌙 Støtte for både light og dark mode
- 📅 Navigering mellom dager
- 📈 Visualisering av progresjon med sirkulære grafer

## Teknologi

- **Swift**
- **SwiftUI**
- **MVVM-arkitektur**
- **Local state management**
- **Custom UI-komponenter**
- **Dark Mode-støtte**

## Arkitektur

Prosjektet er strukturert etter MVVM for bedre separasjon av ansvar:

- **Views** – SwiftUI views
- **ViewModels** – forretningslogikk og state
- **Models** – datamodeller for måltider, kalorier osv.

Dette gjør koden lettere å teste, vedlikeholde og videreutvikle.

## Hvordan kjøre prosjektet

1. Klon repoet:
   ```bash
   git clone https://github.com/<brukernavn>/MyLifeStyle.git
