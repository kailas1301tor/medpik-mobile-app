# Screen 01 — Splash

## SRS Reference
§8.1 Authentication — Splash

## Routes
- Entry: app launch (`/` or `/splash`)
- Exit: `/main` (session exists) or `/login` (no session)

## Behavior
- Show branded splash with app name and tagline
- Check secure storage for access token
- Navigate after ~1.2s bootstrap

## States
- `LoaderState.loading` during bootstrap
- `LoaderState.loaded` when route decision ready

## Acceptance
- [ ] Shows medpik branding
- [ ] Routes to home when token exists
- [ ] Routes to login when no token
