# Foundation Spec

## App Identity

- Package: `tsuite`
- Display name: `medpik` via `Strings.appName`

## Navigation

### Authenticated bottom tabs

| Index | Tab | Screen |
|-------|-----|--------|
| 0 | Home | `HomeScreen` |
| 1 | Orders | `OrdersScreen` |
| 2 | Cart | `CartScreen` |
| 3 | Profile | `ProfileScreen` |

### Stack routes

Search, Product Detail, Prescription Upload, Checkout, Confirmation, Order Detail, Tracking, Address Book.

## Entry Flow

```
Splash → (session?) → MainScreen
Splash → (no session) → Phone Login → OTP → MainScreen
OTP → suspended → blocked error, no entry
```

## Domain Entities

- User: id, name, phone, status
- Address: id, label, lines, city, state, pincode, isDefault
- Product: id, name, category, price, imageUrl, requiresPrescription
- CartItem: product ref, quantity, lineTotal
- PrescriptionDraft: file, notes
- Order: id, items, amount, status, address, timestamps

## Order Statuses

placed, confirmed, packed, outForDelivery, delivered, cancelled

## Mock Strategy

- `AppConstants.useMockData = true` switches repo DI to mock implementations
- All mocks return `Either<ResponseError, T>`
- Test OTP: `123456`
- Suspended test phone: `9999999999`

## AGENTS.md Checklist (per screen)

- [ ] Feature folder structure complete
- [ ] Freezed state with `LoaderState`
- [ ] Notifier: fold + handleResponseError + catchError
- [ ] Controllers in notifier only
- [ ] Shared widgets only in views
- [ ] Strings / ColorPalette / FontPalette — no hardcoding
- [ ] `.select()` on all ref.watch
- [ ] File path comment on every Dart file
- [ ] File line limits respected
- [ ] build_runner run after codegen
