# Artchive MVP Plan

This document describes the first shippable local-only version of Artchive.

## Target Experience

The first version should let a parent quickly archive a child's artwork from their iPhone photo library, add lightweight context, and browse the saved collection later.

## First Release Scope

- Local-only iOS app.
- Multiple child profiles.
- Artwork image import from photo library.
- Artwork metadata entry.
- Gallery browsing.
- Artwork detail view.
- Basic edit and delete.

## Data Model

### Child

Fields:

- `id`
- `name`
- `birthdate`
- `profileColor`
- `createdAt`

Relationships:

- Has many artwork entries.

Notes:

- `birthdate` can be optional.
- `profileColor` can be a simple stored string for MVP.

### Artwork

Fields:

- `id`
- `title`
- `artworkDescription`
- `tags`
- `archiveDate`
- `imageFilename`
- `createdAt`
- `updatedAt`

Relationships:

- Belongs to one child.

Notes:

- Use `artworkDescription` instead of `description` in Swift code to avoid confusion with common protocol/property naming.
- Store tags as an array if SwiftData support is smooth; otherwise store as a comma-separated string behind a small helper.
- Store image files in app documents storage and keep only the filename/path in SwiftData.

## Screens

### Gallery

Primary app screen.

- Shows artwork in a grid.
- Supports filtering by child.
- Empty state invites the user to add the first piece.
- Add button opens the capture/import flow.

### Add Artwork

Form-driven flow after image import.

- Selected image preview.
- Child picker.
- Title field.
- Description field.
- Tags field.
- Archive date defaults to today.
- Save button.

### Artwork Detail

Read view for a single piece.

- Full artwork image.
- Title.
- Child.
- Archive date.
- Description.
- Tags.
- Edit and delete actions.

### Children

Simple management screen.

- List child profiles.
- Add child.
- Edit child.
- Delete child only if no artwork exists, or require confirmation.

## Implementation Slices

### Slice 1: App Shell And Models

- Create SwiftUI app.
- Add SwiftData models.
- Set up model container.
- Add placeholder tabs or navigation.

### Slice 2: Children

- Add child creation.
- List children.
- Edit child name and optional birthdate.

### Slice 3: Artwork Import And Save

- Use PhotosUI to import an image.
- Copy selected image into app documents storage.
- Save artwork metadata with selected child.

### Slice 4: Gallery And Detail

- Display saved artwork thumbnails.
- Open detail screen.
- Load image from local storage.

### Slice 5: Edit, Delete, And Polish

- Edit artwork metadata.
- Delete artwork and associated image file.
- Improve empty states.
- Add basic tag filtering or search.

## Early Product Decisions

- Metadata fields should be optional except child and image.
- Tags should be free-form for MVP.
- Photo library import should come before camera capture because it is simpler and still supports testing with real photos.
- The app should support multiple children from the start, even if onboarding creates only one.

## Later Ideas

- Camera capture.
- iCloud sync.
- Export archive as PDF.
- Generate yearly photo books.
- OCR for handwritten names/dates.
- AI-assisted titles and tags.
- "On this day" resurfacing.

