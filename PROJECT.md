# Artchive

Artchive is a personal iOS app for preserving children's artwork before it gets filed away, lost, or thrown out. The MVP is intentionally local-first: quickly capture a piece of art, add a small amount of context, and make the collection easy to browse later.

## Motivation

Young kids produce a huge amount of art. Families often love the work, but physical storage becomes messy fast. Artchive should make it easy to preserve the memory and the image without turning the process into another chore.

## MVP Goals

- Capture or import a photo of a piece of artwork.
- Automatically record the archive date.
- Prompt for title, description, child, and tags.
- Store all data locally on the device.
- Browse saved artwork in a gallery.
- View artwork details.
- Edit and delete artwork entries.

## Non-Goals For MVP

- Cloud sync.
- Account creation.
- Family sharing.
- Server-side storage.
- Photo book ordering.
- AI tagging, OCR, or image enhancement.

## Core Concepts

### Child

Represents a child whose artwork is being archived.

Initial fields:

- Name
- Optional birthdate
- Optional profile color or avatar

### Artwork

Represents one archived piece of art.

Initial fields:

- Image file path
- Archive date
- Title
- Description
- Tags
- Child

## Initial User Flow

1. Open the app.
2. Tap add artwork.
3. Take a photo or import one from the photo library.
4. Choose the child.
5. Add title, description, and tags.
6. Save.
7. See the new artwork in the gallery.
8. Tap artwork to view details.

## Technical Direction

- SwiftUI for the interface.
- SwiftData for local metadata.
- App document storage for image files.
- PhotosUI for photo library import.
- Camera capture support after the import flow works.

## Product Principles

- Capture should be fast.
- Metadata should be helpful, but not burdensome.
- The app should feel like a family archive, not a database.
- Local-only storage should be clear to the user.
- The first version should optimize for a complete, pleasant capture-to-gallery loop.

## Open Questions

- Should title, description, and tags be required or optional?
- Should the app support multiple child profiles immediately, or create one default child during onboarding?
- Should artwork be grouped primarily by date, child, or tags?
- Should tags be free-form strings for MVP?
- What is the minimum backup/export story for a local-only app?

## First Build Milestone

Build a small SwiftUI app that can:

1. Create at least one child profile.
2. Import an artwork image from the photo library.
3. Save metadata locally.
4. Display saved artwork in a gallery.
5. Open an artwork detail screen.

