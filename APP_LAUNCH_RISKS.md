# Medpik — Pre-Launch Cross-Check

Tick these before go-live. Completed session work is listed at the bottom for reference.

Also see: [`BACKEND_TODO.md`](./BACKEND_TODO.md) for the paste-ready backend handoff.

---

## Still pending (must / should clear before launch)

### A. Backend payments — **critical**

Owner: **backend** · Risk if skipped: customer charged, order stays unpaid.

- [ ] Razorpay webhook endpoint (or dashboard webhooks) for `payment.captured`
- [ ] Razorpay webhook for `payment.failed`
- [ ] Server-side signature verification on webhook events
- [ ] On `payment.captured`: mark matching order **paid**; store payment id / order id / signature
- [ ] On `payment.failed`: mark order payment **failed** with reason
- [ ] Webhook handling is **idempotent** (duplicate deliveries safe)
- [ ] Existing `POST …/payment` verify is **idempotent** (same payment id → success, not error)
- [ ] Optional: support/admin tool to mark order paid given a Razorpay payment id
- [ ] Staging + production webhook URLs configured and tested end-to-end
- [ ] Confirm frontend pending-payment resume + verify retry against idempotent verify

### B. Crashlytics console confirmation — **critical**

Owner: **mobile + Firebase console** · Code/scripts are in place; console proof still needed.

- [ ] Crashlytics enabled for Android + iOS on project `medpik-ea048` (console)
- [ ] Non-fatal / crash appears in Firebase Console from a **physical** profile or release build:
      `flutter run --profile --dart-define-from-file=config/dart_defines.json --dart-define=CRASHLYTICS_TEST_NONFATAL=true`
- [ ] Next release build verifies Android R8 mapping upload (`uploadCrashlyticsMappingFileRelease`)
- [ ] Next release build verifies Flutter symbol upload via `tool/build_release_apk.sh` / `tool/build_release_ipa.sh` (or `./tool/upload_crashlytics_symbols.sh all`)
- [ ] iOS archive log shows FlutterFire / dSYM upload success

### C. Payment device smoke — **critical**

Owner: **mobile** · Hardenings are in code; still verify on devices.

**Frontend readiness (2026-11-11):** Code paths for all items below are present
(`orders_notifier.dart`, `razorpay_payment_service.dart`, `pending_payment_store.dart`).
Payment request/response unit tests pass (`flutter test test/order_payment_*`).
**Device smoke itself is still blocked** — needs a physical device (or emulator with
Razorpay test keys), logged-in staging account, cart → placeable order, and staging
backend that accepts init + verify (idempotent verify preferred for kill/resume).

**How to run (physical Android or iOS):**
1. Build/run with staging config, e.g.
   `flutter run --dart-define-from-file=config/dart_defines.json`
2. Log in; add a product; complete checkout until the order payment screen.
3. Use Razorpay **test** keys / test cards from the Razorpay dashboard.
4. For each case below, note pass/fail and paste results into this checklist.

| # | Checklist | Status |
|---|-----------|--------|
| C1 | Happy path | **Blocked — physical device + staging Razorpay** (procedure ready) |
| C2 | Cancel / checkout close | **Blocked — physical device** (procedure ready) |
| C3 | Kill / airplane after Razorpay success | **Blocked — physical device**; full reconcile also needs **backend idempotent verify** (see §A / `BACKEND_TODO.md`) |
| C4 | Double-tap Pay | **Blocked — physical device** (in-flight guard in code; procedure ready) |
| C5 | COD path | **Blocked — physical device + staging COD** (procedure ready) |
| C6 | Charge + verify fail → contact support | **Blocked — physical device**; simulating verify fail may need airplane mode or backend fault |

- [ ] **C1 Happy path:** init → Razorpay → verify → order refresh → success screen  
  **Steps:** Select Online/Razorpay → Pay → complete test payment in Razorpay sheet → expect success screen / paid order; loader clears; order detail refreshed.  
  **Pass if:** success UI + order shows paid/processing; no stuck loader.
- [ ] **C2 User cancel / checkout close → Failed reported, loader cleared, failure/cancel UI**  
  **Steps:** Pay → open Razorpay → tap close/back or cancel without paying.  
  **Pass if:** cancel/failure screen (or toast) with cancel/fail copy; `isPaymentLoading` cleared; app reported Failed via `POST …/payment` (confirm in staging logs if possible); can pay again.
- [ ] **C3 Airplane-mode / kill app after Razorpay success → relaunch resumes verify or clear prompt**  
  **Steps (kill):** Pay → complete Razorpay success → immediately force-quit before success screen → relaunch logged-in. Expect toast “We found an unfinished payment. Verifying it now…” then success or support prompt.  
  **Steps (airplane):** After Razorpay success, enable airplane mode during verify → expect retries then `paymentMayHaveGoneThrough` copy → disable airplane → relaunch or reopen order; resume verify if pending snapshot has payment id + signature.  
  **Pass if:** pending resume runs without charging twice (needs idempotent verify on backend).  
  **Blocked extra:** §A webhook/idempotent verify for money/order reconciliation if client verify never succeeds.
- [ ] **C4 Double-tap Pay does not start two checkouts**  
  **Steps:** On payment screen, rapidly double-tap Pay.  
  **Pass if:** only one Razorpay sheet; second tap shows “A payment is already in progress…” or is ignored; no two init calls (check logs).
- [ ] **C5 COD path still places order and refreshes**  
  **Steps:** Select Cash on Delivery → confirm → expect success / COD placed copy; order list/detail refreshed.  
  **Pass if:** no Razorpay sheet; order reflects COD; loader cleared.
- [ ] **C6 After charge + verify fail: user sees “payment may have gone through, contact support”**  
  **Steps:** Complete Razorpay success, then force verify failure (airplane mode for entire verify window, or staging verify 5xx).  
  **Pass if:** message matches `Strings.paymentMayHaveGoneThrough` (“Payment may have gone through. Please contact support before trying again.”); Failed report attempted with payment ids; pending kept for resume when network returns.

---

## Done in this session (no longer blocking)

- [x] Firebase Crashlytics app wiring (`crash_reporting_service.dart`, `main.dart`, `firebase_options.dart`, Android/iOS config for `medpik-ea048`)
- [x] Crashlytics symbol upload scripts (`tool/upload_crashlytics_symbols.sh`) + release build script hooks; Android Gradle mapping/native upload flags
- [x] Optional smoke define `CRASHLYTICS_TEST_NONFATAL`
- [x] Haptic feedback via `AppHaptics` (bottom nav, primary CTA, qty, wishlist, search tap, back, pull-to-refresh, emergency tabs, success/error toasts) — optional device spot-check closed as done this session
- [x] Payment frontend hardening (retries/backoff, in-flight guard, pending resume, Razorpay close handling, Failed report with payment ids, contact-support message)
- [x] Home bottom-nav retap scrolls home feed to top
- [x] Orders notifier aligned with session-aware fetch loaders + safer mutation messages
- [x] Backend handoff note: `BACKEND_TODO.md`

---

## Launch gate summary

| Area | Status |
|------|--------|
| A. Backend webhooks + idempotent verify | **Pending — critical** |
| B. Crashlytics console + release symbol proof | **Pending — critical** |
| C. Payment device smoke | **Pending — critical** (procedure + unit tests ready; device smoke not run) |
| Session code/docs above | **Done** |
