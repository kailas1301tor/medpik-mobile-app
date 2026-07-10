# Medpik Specs

Spec-driven development artifacts for the Medpik user mobile app.

## Workflow

1. Read the SRS section for the screen
2. Write or update `screens/XX-<name>.md`
3. Complete the AGENTS.md checklist in the spec
4. Implement layers in order: model → state → repo → notifier → view
5. Run `dart run build_runner build --delete-conflicting-outputs`
6. Verify acceptance criteria

## Structure

- `00-foundation.md` — architecture, navigation, entities, mock strategy
- `flows/` — end-to-end user journeys
- `screens/` — per-screen specs (16 total)
- `api-contracts/` — mock/real API contracts

## Engineering Standard

All implementation MUST follow [AGENTS.md](../../AGENTS.md).
