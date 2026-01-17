# 📅 VSchedule

A Flutter mobile app for viewing university class schedules from the [VŠE Prague](https://www.vse.cz/) (Prague University of Economics and Business) InSIS system.

![vschedule](https://user-images.githubusercontent.com/33172723/232555888-2e8476dd-2b5b-4da0-8e86-5fe122148121.png)

## Overview

VSchedule provides a clean, mobile-friendly interface for students to view their weekly class schedules. The app authenticates directly with the InSIS portal, scrapes schedule data, and presents it in a modern UI with day-by-day navigation.

## Features

- **InSIS Authentication** — Secure login to the university portal
- **Schedule Parsing** — HTML scraping of personal timetable data
- **Offline Support** — Local SQLite caching for offline access
- **Secure Storage** — Credentials stored using Flutter Secure Storage
- **Day Picker** — Swipe or tap to navigate between weekdays
- **Clean UI** — Custom fonts (Poppins, Quicksand) and polished design

## Architecture

The app follows the **BLoC pattern** (Business Logic Component) for state management with RxDart streams.

```
lib/src/
├── blocs/           # State management (login, schedule)
├── models/          # ScheduleEvent data model
├── resources/
│   ├── http/        # InSIS HTTP client & HTML parser
│   ├── db/          # SQLite provider for caching
│   └── credentials/ # Secure credential storage
└── ui/              # Screens & widgets
```

## Tech Stack

| Category | Tools |
|----------|-------|
| Framework | Flutter / Dart |
| State | BLoC + RxDart |
| HTTP | `http`, HTML parsing with `html` |
| Storage | `sqflite`, `flutter_secure_storage` |
| UI | Material Design, Google Fonts |

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run
```

## Data Model

Each schedule event contains:
- **Time** — Start/end (`DateTime`)
- **Type** — Lecture or Seminar
- **Course** — Full course name with ID
- **Room** — Building and room number
- **Teacher** — Instructor name
