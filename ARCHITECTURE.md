# BANA 2026 Seattle — App Architecture

## Overview

The BANA iOS app serves **two phases** of the 25th milestone convention (July 30–Aug 2, 2026, Hyatt Regency Bellevue, ~600 attendees):

| Phase | Focus |
|-------|--------|
| **Pre-Event** (3 months out) | Countdown, registration, hotel, community spotlight |
| **Live-Event** | Schedule, cultural voting, Bunts Match, attendee directory, maps, alerts |

---

## Proposed Folder Structure

```
bana/
├── banaApp.swift                    # App entry point
├── App/
│   └── ContentView.swift            # Root coordinator (Pre-Event vs Live-Event)
├── Core/
│   ├── Models/                      # Shared data models
│   │   ├── AuthModels.swift         # AuthUser, AuthProvider, AuthError
│   │   ├── ConventionModels.swift   # BANA 2026 Seattle: ConventionInfo, Schedule, etc.
│   │   └── ChatModels.swift         # ChatMessage, ChatPeer (extracted from ChatService)
│   ├── Services/
│   │   ├── AuthenticationService.swift
│   │   ├── ChatService.swift
│   │   ├── ScheduleService.swift    # Cached schedule (offline-first)
│   │   └── NotificationService.swift # Push / incident alerts
│   ├── Components/                  # Reusable UI
│   │   ├── MenuItem.swift
│   │   ├── WebView.swift
│   │   └── BANAButton.swift         # Themed primary/secondary buttons
│   └── Theme/
│       └── BANATheme.swift          # Colors, typography, BANA 2026 Seattle branding
├── Features/
│   ├── PreEvent/
│   │   ├── CountdownHeroView.swift  # Home: countdown to July 30, 2026
│   │   ├── RegistrationHotelView.swift
│   │   └── MeetTheCommunityView.swift
│   └── LiveEvent/
│       ├── Schedule/
│       │   ├── ScheduleView.swift   # Multi-day tabs (Thu–Sun)
│       │   └── ScheduleDetailView.swift
│       ├── BuntsMatchView.swift     # WebView wrapper for matchmaking
│       ├── AttendeeDirectoryView.swift
│       ├── CulturalVotingView.swift
│       ├── KidsWorldView.swift
│       └── MapView.swift
├── AuthenticationView.swift         # Auth gate (unchanged location for now)
├── ChatView.swift
└── Assets.xcassets/
```

**Rationale:**

- **App/** — Single root coordinator; decides Pre-Event vs Live-Event shell.
- **Core/** — Shared models, services, components, theme. Keeps feature code thin.
- **Features/PreEvent** — Countdown, registration, hotel, “Meet the Community” (BANA history, 1979 inception).
- **Features/LiveEvent** — Agenda, Bunts Match, directory, cultural voting, Kids World, maps.
- **Theme** — One place for BANA 2026 Seattle branding (professional, culturally rich, high contrast).

---

## First 3 Files to Refactor (Seattle 2026 Alignment)

### 1. **ContentView** → Root coordinator

**Current:** Auth gate → WebView + burger menu (generic BANA site links).

**Target:**

- Keep auth gate.
- **Pre-Event:** Home = Countdown Hero (days to July 30, 2026) + clear CTAs (Register, Hotel, Meet the Community). Menu can still expose Spotlight, Resources, Chat, Sign Out.
- **Live-Event:** Tab-based shell: Schedule | Bunts Match | Directory | More (Cultural Voting, Kids World, Maps, Announcements).
- Use `ConventionModels.ConventionInfo` for dates and phase (e.g. “isLiveEvent” based on current date).

**Refactor steps:**

1. Introduce `AppPhase` (preEvent / liveEvent) and determine phase from `ConventionInfo.conventionStartDate`.
2. Pre-Event: embed `CountdownHeroView` as the main home content; keep WebView/menu for other items.
3. Live-Event: replace main area with a `TabView` (Schedule, Bunts Match, Directory, More).
4. Move `MenuItem` and `WebView` into `Core/Components/` and reference from ContentView.

---

### 2. **Models** → Extract and add Convention 2026 models

**Current:** Auth and chat models live inside `AuthenticationService.swift` and `ChatService.swift`.

**Target:**

- **Core/Models/AuthModels.swift** — `AuthUser`, `AuthProvider`, `AuthError` (no behavior).
- **Core/Models/ConventionModels.swift** — BANA 2026 Seattle:
  - `ConventionInfo`: name, start/end dates, venue (Hyatt Regency Bellevue), city (Seattle), earlyBirdPrice (395), roomBlockURL, etc.
  - `ScheduleDay`: day (Thu–Sun), date, list of `ScheduleItem`.
  - `ScheduleItem`: title, subtitle, time, location, track (e.g. Young Voices Unite, Business Forum, Cultural Showcase).
  - Optional: `Attendee` (for directory), `CulturalPerformance` (for voting).
- **Core/Models/ChatModels.swift** — `ChatMessage`, `ChatPeer` (extract from ChatService).

**Refactor steps:**

1. Add `Core/Models/` and create `ConventionModels.swift` with 2026 data.
2. Create `AuthModels.swift` and move auth types from `AuthenticationService.swift`; update service and views to import/use.
3. Create `ChatModels.swift` and move chat types from `ChatService.swift`; update `ChatService` and `ChatView`.

---

### 3. **banaApp.swift** → Entry point and theme

**Current:** Only launches `ContentView()`.

**Target:**

- Remain the single entry point.
- Apply BANA 2026 theme globally (e.g. tint, nav bar appearance) so all screens share the same premium, high-contrast look.
- No need to change navigation flow here; phase logic stays in ContentView.

**Refactor steps:**

1. Create `Core/Theme/BANATheme.swift` with colors and typography for BANA 2026 Seattle.
2. In `banaApp`, set `ContentView()` inside a container that applies `.tint(BANATheme.accent)` and, if needed, a custom `NavigationBar` appearance.
3. Optionally inject an `@StateObject` or environment object for `ConventionInfo` so the app has a single source of truth for convention dates and phase.

---

## Technical Constraints (Recap)

- **SwiftUI + async/await** for all new code.
- **Offline-first schedule**: `ScheduleService` loads and caches schedule; UI reads from cache when offline.
- **Reference existing models** in the workspace but **modernize** for 2026 (dates, venue, pricing, tracks).

---

## Implementation Order

1. Add **Core/Models/ConventionModels.swift** (new) and **Core/Theme/BANATheme.swift** (new).
2. Refactor **ContentView** to use `ConventionInfo`, show **CountdownHeroView** for Pre-Event home, and keep existing menu/WebView for other links.
3. Extract **AuthModels** and **ChatModels** into Core/Models; update **AuthenticationService** and **ChatService**.
4. Apply **BANATheme** in **banaApp**.
5. Add remaining Pre-Event and Live-Event feature views and services incrementally.

This keeps the app buildable at each step and aligns the codebase with the Seattle 2026 vision.
