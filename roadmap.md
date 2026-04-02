# Tamagotchi App – Projekt-Roadmap

## Projektübersicht

Eine moderne, responsive Tamagotchi-App in Flutter mit plattformübergreifender Unterstützung (Android, Windows, Linux, Web), Backend-Anbindung für Benutzerverwaltung, Arena-Kämpfe, Turniere und Bitcoin-Integration.

---

## Phase 1: Projektfundament & Architektur

### 1.1 Projektsetup
- [ ] Flutter-Projekt initialisieren (Android, Windows, Linux, Web)
- [ ] Ordnerstruktur festlegen (Feature-basiert)
- [ ] State-Management wählen und einrichten (Riverpod)
- [ ] Routing-Lösung einrichten (GoRouter)
- [ ] CI/CD-Pipeline aufsetzen (GitHub Actions für Build & Test)
- [ ] Linting-Regeln und Code-Conventions definieren

### 1.2 Backend-Architektur
- [ ] Backend-Technologie festlegen (Dart mit Shelf/Serverpod oder Supabase)
- [ ] Datenbankschema entwerfen (PostgreSQL)
- [ ] REST-API- oder GraphQL-Schnittstellendefinition
- [ ] Authentifizierungs-Strategie festlegen (JWT + Refresh Tokens)
- [ ] WebSocket-Strategie für Echtzeit-Features (Arena, Statusupdates)
- [ ] Docker-Compose für lokale Entwicklung

### 1.3 Datenmodelle (Entwurf)
- [ ] `User` – Benutzerkonto, Profil, Erfahrungspunkte, Wallet
- [ ] `Creature` – Tamagotchi-Basismodell (Tier oder Monster)
- [ ] `CreatureType` – Katalog aller wählbaren Kreaturen mit Basiswerten
- [ ] `CreatureStats` – Hunger, Glück, Energie, Gesundheit, Sauberkeit, Alter
- [ ] `BattleRecord` – Kampfhistorie
- [ ] `Tournament` – Turnierstruktur
- [ ] `Transaction` – Bitcoin-Transaktionen

---

## Phase 2: Benutzerverwaltung & Authentifizierung

### 2.1 Backend – Auth-Service
- [ ] Registrierung (E-Mail + Passwort)
- [ ] Login / Logout
- [ ] JWT-Token-Generierung und -Validierung
- [ ] Refresh-Token-Mechanismus
- [ ] Passwort-Zurücksetzen (E-Mail-Versand)
- [ ] Account-Löschung (DSGVO-konform)
- [ ] Rate Limiting für Auth-Endpoints

### 2.2 Frontend – Auth-UI
- [ ] Responsive Login-Screen
- [ ] Responsive Registrierungs-Screen
- [ ] Passwort-vergessen-Flow
- [ ] Session-Management im Client (Secure Storage)
- [ ] Automatischer Token-Refresh
- [ ] Offline-Erkennung und Hinweis

---

## Phase 3: Tamagotchi-Kernmechaniken

### 3.1 Kreatur-Auswahl & Erstellung
- [ ] Kreatur-Katalog erstellen (mindestens 8–12 verschiedene Tiere/Monster)
  - Tiere: Katze, Hund, Drache, Hase, Fuchs, Vogel
  - Monster: Schleim, Goblin, Geist, Elementar, Steingolem, Schattenkatze
- [ ] Sprite-Sheets / Animationen pro Kreatur (Idle, Fressen, Schlafen, Spielen, Kämpfen)
- [ ] Kreatur-Erstellungsflow: Typ wählen → Name vergeben → Bestätigen
- [ ] Jeder User kann mehrere Kreaturen besitzen
- [ ] Aktive Kreatur auswählen

### 3.2 Statuswerte & Bedürfnisse
- [ ] **Hunger** (0–100) – sinkt über Zeit, steigt durch Füttern
- [ ] **Glück** (0–100) – sinkt über Zeit, steigt durch Spielen
- [ ] **Energie** (0–100) – sinkt durch Aktivitäten, regeneriert durch Schlafen
- [ ] **Gesundheit** (0–100) – sinkt bei Vernachlässigung, steigt durch Pflege/Medizin
- [ ] **Sauberkeit** (0–100) – sinkt über Zeit, steigt durch Waschen/Putzen
- [ ] **Alter** – wächst in Echtzeit (Tage seit Erstellung)
- [ ] **Gewicht** – beeinflusst durch Fütterungsverhalten
- [ ] Statuswerte sinken serverseitig (auch wenn App geschlossen)
- [ ] Tod bei langfristiger Vernachlässigung (Gesundheit = 0 über längere Zeit)

### 3.3 Interaktionen
- [ ] **Füttern** – verschiedene Nahrungsmittel mit unterschiedlichen Effekten
  - Normales Futter: +10 Hunger, +2 Gewicht
  - Premium-Futter: +20 Hunger, +5 Glück, +1 Gewicht
  - Snack: +5 Hunger, +10 Glück, +5 Gewicht
- [ ] **Spielen** – Mini-Interaktionen, erhöht Glück, senkt Energie
- [ ] **Schlafen legen** – regeneriert Energie über Zeit
- [ ] **Waschen / Putzen** – erhöht Sauberkeit
- [ ] **Medizin geben** – stellt Gesundheit wieder her (bei Krankheit)
- [ ] **Trainieren** – erhöht Kampfwerte, senkt Energie stark
- [ ] Cooldowns für Aktionen (z.B. Füttern max. alle 30 Min.)

### 3.4 Entwicklungsstufen
- [ ] **Ei** (Tag 0) – Schlüpf-Animation
- [ ] **Baby** (Tag 1–3) – eingeschränkte Interaktionen
- [ ] **Kind** (Tag 4–7) – alle Grundinteraktionen verfügbar
- [ ] **Jugendlich** (Tag 8–14) – Training und Arena freigeschaltet
- [ ] **Erwachsen** (ab Tag 15) – Turnier-Teilnahme freigeschaltet
- [ ] Visuelle Veränderung pro Stufe (andere Sprites/Größe)

---

## Phase 4: UI/UX – Hauptbildschirme

### 4.1 Hauptscreen (Tamagotchi-Ansicht)
- [ ] Kreatur-Animation (animiertes Sprite, zentral)
- [ ] Statusleisten (Hunger, Glück, Energie, Gesundheit, Sauberkeit)
- [ ] Aktionsbuttons (Füttern, Spielen, Schlafen, Waschen, Trainieren)
- [ ] Hintergrund wechselt je nach Tageszeit (Tag/Nacht-Zyklus)
- [ ] Wetter-Effekte (optional, rein kosmetisch)
- [ ] Benachrichtigungen bei kritischen Statuswerten

### 4.2 Inventar & Shop
- [ ] Inventar-Ansicht (Futter, Medizin, Spielzeug)
- [ ] Shop zum Erwerb von Gegenständen (In-App-Währung)
- [ ] Münzen verdienen durch Pflege, Kämpfe, Turniere
- [ ] Tägliche Login-Belohnungen

### 4.3 Profil & Einstellungen
- [ ] Benutzerprofil (Name, Avatar, Statistiken)
- [ ] Kreatur-Übersicht (alle eigenen Kreaturen)
- [ ] Errungenschaften / Achievements
- [ ] Einstellungen (Benachrichtigungen, Sprache, Theme)
- [ ] Dark Mode / Light Mode

### 4.4 Responsives Design
- [ ] Mobile-Layout (Hochformat, Touch-optimiert)
- [ ] Tablet-Layout (geteilte Ansicht)
- [ ] Desktop-Layout (Sidebar-Navigation, größere Kreatur-Ansicht)
- [ ] Web-Layout (Desktop-ähnlich, Tastatursteuerung)
- [ ] Adaptive Breakpoints: 600px (Mobil), 900px (Tablet), 1200px (Desktop)

---

## Phase 5: Arena – PvP-Kämpfe

### 5.1 Kampfsystem-Design
- [ ] Rundenbasiertes Kampfsystem
- [ ] Kampfwerte berechnen aus:
  - Grundwerte der Kreatur-Art (Angriff, Verteidigung, Geschwindigkeit)
  - Entwicklungsstufe (Multiplikator)
  - Aktuelle Statuswerte (hungrige Kreatur kämpft schlechter)
  - Trainings-Bonus
  - Zufallsfaktor (10–20%)
- [ ] Angriffs-Typen:
  - Normaler Angriff
  - Spezialangriff (kreaturspezifisch, Cooldown)
  - Verteidigung (reduziert nächsten eingehenden Schaden)
  - Ausweichen (Chance den Angriff zu vermeiden)
- [ ] Kampf-HP separat von Gesundheits-Statuswert
- [ ] Kampf endet bei HP = 0 oder nach max. 20 Runden (dann Entscheidung nach HP%)

### 5.2 Matchmaking
- [ ] Matchmaking-Queue (sucht Gegner ähnlicher Stärke)
- [ ] ELO-Rating-System für faires Matching
- [ ] Wartezeit-Anzeige
- [ ] Kampf-Einladungen an Freunde (Freundesliste)
- [ ] Zufallsgegner-Suche

### 5.3 Kampf-UI
- [ ] Kampf-Arena-Bildschirm (beide Kreaturen gegenüber)
- [ ] Kampf-Animationen (Angriff, Treffer, Ausweichen)
- [ ] HP-Balken für beide Kreaturen
- [ ] Aktionsauswahl (Angriff, Spezial, Verteidigung, Ausweichen)
- [ ] Kampflog (textueller Verlauf)
- [ ] Ergebnis-Screen (Gewinner, XP-Gewinn, Belohnungen)

### 5.4 Backend – Arena-Service
- [ ] WebSocket-basierte Echtzeit-Kampfkommunikation
- [ ] Kampflogik serverseitig (Anti-Cheat)
- [ ] Kampfergebnisse persistent speichern
- [ ] Rangliste / Leaderboard
- [ ] Erfahrungspunkte (XP) nach Kampf vergeben
  - Sieg: +50 XP
  - Niederlage: +10 XP
  - Bonus bei Sieg gegen stärkeren Gegner

### 5.5 Belohnungssystem
- [ ] XP-Level-System für Benutzer (nicht Kreatur)
- [ ] Münzen als Kampfbelohnung
- [ ] Seltene Items bei Siegesserien
- [ ] Saisonale Ranglisten mit Belohnungen

---

## Phase 6: Turniersystem

### 6.1 Turnierstruktur
- [ ] Turnier-Erstellung (Admin oder automatisch)
- [ ] Turnier-Formate:
  - **Einzelausscheidung** (Single Elimination, 8/16/32 Teilnehmer)
  - **Doppel-Ausscheidung** (Double Elimination)
  - **Rundenturnier** (Round Robin, für kleinere Gruppen)
- [ ] Turnier-Phasen:
  - Anmeldephase (mit Countdown)
  - Laufendes Turnier (Matches werden automatisch geplant)
  - Abgeschlossen (Ergebnisse & Auszahlung)
- [ ] Bracket-Ansicht (Turnierbaum-Visualisierung)
- [ ] Automatische Kampfplanung und Benachrichtigungen
- [ ] Zeitfenster für Kämpfe (z.B. 24h pro Runde)
- [ ] Automatischer Forfeit bei Nichtantreten

### 6.2 Turnier-UI
- [ ] Turnier-Übersicht (alle offenen/laufenden/vergangenen Turniere)
- [ ] Turnier-Detailansicht mit Bracket
- [ ] Anmeldeflow (inkl. Bitcoin-Zahlung, siehe Phase 7)
- [ ] Live-Turnier-Status und Benachrichtigungen
- [ ] Turnier-Ergebnishistorie

### 6.3 Backend – Turnier-Service
- [ ] Turnier-CRUD-API
- [ ] Automatisches Bracket-Generierung (Seeding nach ELO)
- [ ] Kampfplanung und Zeitmanagement
- [ ] Turnier-Status-Übergänge (Anmeldung → Aktiv → Abgeschlossen)
- [ ] Gewinn-Berechnung und -Verteilung
- [ ] Turnier-Statistiken und -Historie

---

## Phase 7: Bitcoin-Integration & Zahlungssystem

### 7.1 Wallet-System
- [ ] Bitcoin-Wallet-Anbindung (Lightning Network für schnelle, günstige Transaktionen)
- [ ] Wallet-Adresse pro Benutzer generieren
- [ ] Einzahlungen empfangen und bestätigen
- [ ] Auszahlungen initiieren
- [ ] Transaktionshistorie anzeigen
- [ ] Kontostand anzeigen (in Satoshis und BTC)

### 7.2 Turnier-Zahlungsflow
- [ ] Startgebühr festlegen (z.B. 10.000–100.000 Satoshis)
- [ ] Zahlung bei Turnier-Anmeldung einfordern
- [ ] Zahlungsbestätigung abwarten (Lightning: sofort, On-Chain: Konfirmationen)
- [ ] Pott berechnen (Summe aller Startgebühren)
- [ ] Bearbeitungsgebühr abziehen (z.B. 5–10%, konfigurierbar)
- [ ] Gewinn an Sieger auszahlen
- [ ] Optionale Platzierungsprämien (z.B. 70% Platz 1, 20% Platz 2, 10% Platz 3)
- [ ] Automatische Rückerstattung bei Turnierabsage

### 7.3 Sicherheit & Compliance
- [ ] Sichere Schlüsselverwaltung (HSM oder Vault)
- [ ] Auszahlungslimits und Verifizierung
- [ ] Betrugserkennung (ungewöhnliche Muster)
- [ ] Audit-Log für alle Finanztransaktionen
- [ ] Rechtliche Prüfung (Glücksspielregulierung je nach Region)
- [ ] AGB und Nutzungsbedingungen für Turniere mit Einsatz
- [ ] Altersverifikation (18+)
- [ ] KYC-Prüfung (Know Your Customer) ab bestimmten Beträgen

### 7.4 Backend – Payment-Service
- [ ] Lightning-Network-Node oder API-Anbindung (z.B. LND, BTCPay Server)
- [ ] Invoice-Generierung für Einzahlungen
- [ ] Webhook/Callback bei Zahlungseingang
- [ ] Auszahlungsqueue mit Bestätigung
- [ ] Escrow-System für Turnier-Potts
- [ ] Hot-Wallet / Cold-Wallet-Strategie

---

## Phase 8: Soziale Features

### 8.1 Freundesliste
- [ ] Freunde suchen (nach Username)
- [ ] Freundschaftsanfragen senden/annehmen/ablehnen
- [ ] Freunde-Kreaturen besuchen (nur anschauen)
- [ ] Direkte Kampfeinladungen an Freunde

### 8.2 Chat & Kommunikation
- [ ] Einfacher In-App-Chat (1:1 mit Freunden)
- [ ] Turnier-Chat (für Turnier-Teilnehmer)
- [ ] Chat-Moderation (Wortfilter, Meldefunktion)

### 8.3 Ranglisten & Statistiken
- [ ] Globale Rangliste (XP, ELO, Siege)
- [ ] Freundes-Rangliste
- [ ] Turnier-Rangliste (Gewinne, Teilnahmen)
- [ ] Detaillierte Kampfstatistiken pro Kreatur

---

## Phase 9: Push-Benachrichtigungen & Hintergrundlogik

### 9.1 Benachrichtigungen
- [ ] Push-Notifications (Firebase Cloud Messaging – Android, Web)
- [ ] Desktop-Benachrichtigungen (Windows, Linux)
- [ ] Benachrichtigungstypen:
  - Kreatur ist hungrig / krank / traurig
  - Kampfeinladung erhalten
  - Turnier beginnt bald
  - Turnierkampf steht an
  - Turnier gewonnen / Auszahlung erhalten
- [ ] Benachrichtigungspräferenzen (ein-/ausschaltbar pro Typ)

### 9.2 Serverseitige Simulation
- [ ] Cron-Jobs / Scheduler für Statuswert-Aktualisierung
- [ ] Statuswerte sinken alle 30 Minuten (konfigurierbar)
- [ ] Krankheitsmechanik bei niedrigen Werten
- [ ] Tod-Mechanik nach 7 Tagen Gesundheit = 0 (mit Warnungen)
- [ ] Wiederbelebungs-Mechanik (optional, kostenpflichtig)

---

## Phase 10: Testing, Optimierung & Launch

### 10.1 Testing
- [ ] Unit Tests (mindestens 80% Coverage für Business-Logik)
- [ ] Widget Tests (alle kritischen UI-Flows)
- [ ] Integration Tests (Auth, Kampf, Turnier, Zahlung)
- [ ] E2E Tests (kritische User-Journeys)
- [ ] Last-Tests für Backend (Kampf-WebSockets, Turnier-Peaks)
- [ ] Sicherheitsaudit (besonders Payment-Service)

### 10.2 Performance & Optimierung
- [ ] Lazy Loading für Listen und Assets
- [ ] Caching-Strategie (Kreatur-Sprites, Benutzerdaten)
- [ ] Offline-Modus (eingeschränkte Interaktionen ohne Netzwerk)
- [ ] App-Größe optimieren (plattformspezifisch)
- [ ] Backend-Skalierung (Horizontale Skalierung, Load Balancer)

### 10.3 Deployment
- [ ] Android: Google Play Store Release
- [ ] Windows: MSIX-Installer oder Microsoft Store
- [ ] Linux: Snap, Flatpak oder AppImage
- [ ] Web: Hosting (z.B. Firebase Hosting, Cloudflare Pages)
- [ ] Backend: Container-Deployment (Docker + Kubernetes oder VPS)
- [ ] Datenbank-Backups und Disaster Recovery
- [ ] Monitoring & Logging (Sentry, Grafana)

### 10.4 Launch-Checkliste
- [ ] Datenschutzerklärung (DSGVO)
- [ ] Impressum
- [ ] AGB (besonders für Bitcoin-Turniere)
- [ ] App-Store-Listings (Screenshots, Beschreibung)
- [ ] Beta-Testphase mit ausgewählten Nutzern
- [ ] Bug-Bounty-Programm (optional)

---

## Technologie-Stack (Empfehlung)

| Komponente          | Technologie                              |
|---------------------|------------------------------------------|
| Frontend            | Flutter 3.x (Dart)                       |
| State Management    | Riverpod                                 |
| Routing             | GoRouter                                 |
| Backend             | Dart (Serverpod) oder Node.js (NestJS)   |
| Datenbank           | PostgreSQL                               |
| Cache               | Redis                                    |
| Echtzeit            | WebSockets (Socket.IO oder nativ)        |
| Auth                | JWT + Refresh Tokens                     |
| Push Notifications  | Firebase Cloud Messaging                 |
| Bitcoin             | BTCPay Server + Lightning Network (LND)  |
| Hosting             | Docker + VPS (Hetzner/Contabo)           |
| CI/CD               | GitHub Actions                           |
| Monitoring          | Sentry + Grafana + Prometheus            |

---

## Meilensteine & Priorisierung

| Meilenstein | Beschreibung                              | Phasen  | Priorität |
|-------------|-------------------------------------------|---------|-----------|
| M1          | Lauffähige App mit Auth & Kreatur-Pflege  | 1–4     | Hoch      |
| M2          | Arena-Kämpfe (PvP)                        | 5       | Hoch      |
| M3          | Turniersystem (ohne Bitcoin)              | 6       | Mittel    |
| M4          | Bitcoin-Integration                       | 7       | Mittel    |
| M5          | Soziale Features                          | 8       | Niedrig   |
| M6          | Push-Notifications & Hintergrundlogik     | 9       | Mittel    |
| M7          | Launch & Go-Live                          | 10      | Hoch      |

---

## Offene Entscheidungen

- [ ] Soll das Backend in Dart (Serverpod) oder einer anderen Sprache geschrieben werden?
- [ ] Eigener Bitcoin Lightning Node oder gehosteter Service (z.B. Strike API, OpenNode)?
- [ ] Soll es eine eigene In-App-Währung geben, die gegen Bitcoin getauscht werden kann?
- [ ] Soll der Kreatur-Tod permanent sein oder soll es Wiederbelebung geben?
- [ ] Maximale Anzahl an Kreaturen pro Benutzer?
- [ ] Soll es Kreatur-Zucht (Breeding) geben?
- [ ] PvE-Inhalte (z.B. Dungeons, Story-Modus)?
- [ ] Handels-System zwischen Spielern?
