# Light-Mode Card Border Treatment

## Goal

Improve separation between white cards, the floating bottom navigation, and the white
light-mode background without making the interface feel heavy.

## Design

- Change the light-mode semantic `cardBorder` color from `#EDEFF1` to `#D9DEE3`.
- Render standard card borders at full opacity with the existing responsive 1 px width.
- Apply the semantic border consistently through `CommonContainer` and direct card
  implementations, including order tiles and the floating bottom navigation.
- Preserve component-specific colored borders used for statuses, warnings, and other
  semantic states.
- Leave dark-mode colors and behavior unchanged.
- Do not add stronger shadows; separation should come from the neutral outline.

## Scope

This treatment covers all standard cards and the floating bottom navigation. It does not
redesign spacing, radii, surfaces, typography, or feature-specific visual states.

## Verification

- Run static analysis for modified Dart files.
- Run relevant widget tests where available.
- Visually inspect Home, Orders, Cart, and Profile in light mode.
- Confirm dark mode remains visually unchanged.
