# Medpik — Remaining / Backend TODO

Clear checklist of work discussed in the Flutter session that still needs follow-through (mostly backend). Frontend payment hardening and Crashlytics wiring are already in the app unless noted below.

---

## 1. Backend — Razorpay payment webhook & reconciliation

**Context:** When Razorpay succeeds on the device but our verify/submit call fails (e.g. network), the order can stay unpaid even though the customer was charged. The app retries verify and shows a “contact support” message, and keeps a local pending snapshot for resume — but it **cannot fully reconcile** without server-side handling.

**Please implement:**

1. **Razorpay webhook** (dashboard or API) for `payment.captured` and `payment.failed`, handled **server-side independent of the client**.
2. **On `payment.captured`:** verify signature server-side, mark the matching order **paid**, and store Razorpay payment id / order id / signature.
3. **On `payment.failed`:** mark order payment **failed** with the failure reason.
4. **Idempotency** on webhook handling so duplicate deliveries do not double-credit or corrupt status.
5. **Optional:** support/admin reconcile path to mark an order paid from a Razorpay payment id (for support cases).
6. **Existing `POST …/payment` verify** must be **idempotent** — submitting the same payment id again should return success, not an error (needed for client retry / resume after kill).

This unblocks safe recovery when the client drops after a successful charge.

**Related frontend (already done):**
- Verify/submit retries with backoff on network errors
- Pending payment persisted locally and resumed on next launch (logged-in users)
- On final verify failure after charge: report Failed with payment ids + “payment may have gone through, contact support”
- Cancel / SDK error / checkout close reported to `POST …/payment` as Failed where applicable

---

## 2. Firebase Crashlytics (ops / console)

Frontend is wired to project **`medpik-ea048`** (Android + iOS).

**Still confirm in Firebase Console:**
- [ ] Crashlytics enabled for Android and iOS apps
- [ ] First release/profile crash appears in the Crashlytics dashboard
- [ ] Symbol upload works for release builds if obfuscation is enabled later

---

## 3. Haptic feedback — status

**Done in app (shared widgets):**
- Bottom nav tab taps
- Primary buttons
- Qty +/- controls
- Wishlist toggle
- App bar / floating circle / back controls
- List tiles
- Success / error toasts

**Optional follow-up (not blocking):**
- Audit feature-specific raw `GestureDetector` / `InkWell` taps that **bypass** shared widgets (chips, custom cards, payment method rows, etc.) and add `AppHaptics` where missing
- Helper: `lib/utils/helpers/haptic_helper.dart` (`AppHaptics`)

---

## 4. Other session notes (no open code required unless product asks)

| Item | Status |
|------|--------|
| Firebase Crashlytics connect (`medpik-ea048`) | Done in app; enable/monitor in console |
| Home tab scroll-to-top on retap | Done |
| Orders notifier aligned with home-style session-aware fetch loaders | Done |
| Payment frontend robustness (retries, guards, pending resume, Razorpay event handling) | Done in app |
| Backend webhook / idempotent verify / support reconcile | **Open — this file §1** |

---

## Suggested handoff message (paste)

> When Razorpay succeeds on the device but verify/submit fails, the order can stay unpaid while money was charged. Please add Razorpay webhooks for `payment.captured` / `payment.failed` with server-side signature verification, mark orders paid/failed, make webhook handling idempotent, optionally add a support tool to mark paid by Razorpay payment id, and make `POST …/payment` verify idempotent for client retries. Details are in `BACKEND_TODO.md`.
