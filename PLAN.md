# Uminom

## Core Features

Water Intake Logging: Log each water intake with a timestamp and volume.
Daily Goal Setting: Set a personalized daily water intake goal.
Visual Hydration Meter: Display a clear, visual representation of daily progress towards the hydration goal.
Reminder Scheduling: Schedule reminders throughout the day to drink water.
Generative Recommendation: AI-powered personalized advice using tool for optimal hydration based on logged activity and current conditions.

## Style Guidelines

Primary color: Sky blue (#46A5EA) to represent water and cleanliness.
Background color: Very light blue (#E5F4FC) to provide a clean and calming backdrop.
Accent color: Turquoise (#30D5C8) for interactive elements and highlights.

## Typography

Body and headline font: 'PT Sans', a modern humanist sans-serif that is very readable.

## Iconography

Use water-themed icons (e.g., droplet, glass, bottle) for clarity.

## Layout

Clean, minimalist layout with clear visual hierarchy.

## Animation

Subtle animations on logging intake and reaching goals.

## Architecture and Stack

Feature First, Flutter, Riverpod, MVVM.

## Folder Structure

```code
lib/
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── services/
│   ├── utils/
│   └── theme/
│
├── shared/
│   ├── widgets/
│   ├── providers/
│   └── extensions/
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   │
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── controllers/
│   │       ├── screens/
│   │       └── widgets/
│   │
│   ├── dashboard/
│   ├── profile/
│   └── settings/
│
└── main.dart
```
