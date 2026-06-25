# Artchive Execution Plan

This plan turns the MVP scope into an ordered build path. Each milestone should leave the app in a working state, even if the experience is still rough.

## Guiding Approach

- Build one usable vertical slice at a time.
- Keep the app local-only for the MVP.
- Prefer simple SwiftUI and SwiftData patterns until the app proves it needs more structure.
- Commit after each meaningful milestone.
- Keep product decisions documented as they change.

## Milestone 0: Project Setup

Goal: Create a runnable iOS app shell and establish basic project hygiene.

Tasks:

- Create the Xcode SwiftUI project for Artchive.
- Use SwiftUI as the app framework.
- Use SwiftData for local persistence.
- Set the minimum supported iOS version.
- Add an initial app icon placeholder only if Xcode requires one.
- Add a lightweight `.gitignore` for Xcode, Swift, and macOS generated files.
- Confirm the app builds and launches in the simulator.

Definition of done:

- The app opens to a basic screen in the iOS simulator.
- The project builds without errors.
- Generated files and user-specific Xcode state are ignored.
- Changes are committed and pushed.

Open decisions:

- Minimum iOS version.
- Whether to create the Xcode project manually in Xcode or generate it from the command line.

## Milestone 1: Domain Model And Persistence

Goal: Add the local data model for children and artwork entries.

Tasks:

- Create a `Child` SwiftData model.
- Create an `Artwork` SwiftData model.
- Configure the SwiftData model container in the app entry point.
- Add sample or preview data for SwiftUI previews if useful.
- Decide whether tags are stored as `[String]` or as a serialized string.
- Add a small image storage helper for future artwork image files.

Definition of done:

- The app launches with the SwiftData container configured.
- Child and artwork objects can be created in code.
- Image storage has a clear home in app documents storage.
- Model choices are reflected in `MVP_PLAN.md` if they change.

## Milestone 2: Child Profiles

Goal: Let the user create and manage child profiles.

Tasks:

- Add a Children screen.
- Show existing children in a list.
- Add a child creation form.
- Support editing child name and optional birthdate.
- Assign a simple profile color.
- Prevent or confirm deleting a child with artwork.

Definition of done:

- A user can create at least one child profile.
- Child profiles persist after app restart.
- The children workflow feels simple enough for a first-time user.

## Milestone 3: Artwork Import And Metadata Entry

Goal: Create the first real archive flow using photo library import.

Tasks:

- Add an add-artwork action from the gallery.
- Use PhotosUI to select an image.
- Copy the selected image into app documents storage.
- Present a metadata form after image selection.
- Require image and child.
- Make title, description, and tags optional.
- Default archive date to today.
- Save the artwork and return to the gallery.

Definition of done:

- A user can import a real image from the photo library.
- The image file is stored locally by the app.
- Artwork metadata is saved in SwiftData.
- Restarting the app preserves the artwork entry.

## Milestone 4: Gallery And Detail

Goal: Make saved artwork browsable and pleasant to revisit.

Tasks:

- Display artwork in a grid gallery.
- Load thumbnails from local image storage.
- Add empty states for no children and no artwork.
- Add child filtering.
- Open an artwork detail screen.
- Show image, title, child, archive date, description, and tags.

Definition of done:

- Saved artwork appears in the gallery.
- Tapping a piece opens its detail view.
- The gallery handles empty and populated states cleanly.
- Filtering by child works.

## Milestone 5: Edit, Delete, And Basic Search

Goal: Complete the core local archive management loop.

Tasks:

- Edit artwork metadata.
- Delete artwork entries.
- Delete associated local image files when artwork is deleted.
- Add basic search across title, description, and tags.
- Add tag filtering if the data model supports it cleanly.
- Add confirmation for destructive actions.

Definition of done:

- A user can correct metadata after saving.
- A user can remove artwork they no longer want.
- Search helps find a saved piece without browsing manually.
- Deleting artwork does not leave orphaned image files.

## Milestone 6: MVP Polish Pass

Goal: Tighten the experience before calling the local-only MVP complete.

Tasks:

- Review first-run experience.
- Improve copy in empty states and prompts.
- Add clear local-only backup/export warning where appropriate.
- Test with multiple real artwork photos.
- Test multiple child profiles.
- Review layout on small and large iPhone simulators.
- Fix obvious accessibility issues, including labels and dynamic type basics.

Definition of done:

- The app supports the full capture-to-gallery-to-detail loop.
- The app feels coherent enough to use personally.
- Known MVP limitations are documented.
- A tagged MVP commit exists.

## Suggested Build Order

1. Milestone 0: Project Setup
2. Milestone 1: Domain Model And Persistence
3. Milestone 2: Child Profiles
4. Milestone 3: Artwork Import And Metadata Entry
5. Milestone 4: Gallery And Detail
6. Milestone 5: Edit, Delete, And Basic Search
7. Milestone 6: MVP Polish Pass

## Working Agreement With Codex

For each implementation session:

1. Pick one milestone or a small part of one milestone.
2. Inspect the current code before editing.
3. Make focused changes.
4. Build or test what changed.
5. Summarize changes and any tradeoffs.
6. Commit once the slice is in a good state.

## First Next Step

Start with Milestone 0 by creating the SwiftUI project shell. Before generating the project, decide:

- Minimum iOS version.
- Manual Xcode project creation versus command-line project generation.

