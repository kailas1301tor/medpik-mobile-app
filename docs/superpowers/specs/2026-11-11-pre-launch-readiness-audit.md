# Medpik Pre-Launch Readiness Audit

**Date:** 2026-11-11  
**Scope:** Client-side Flutter app (`medpik`) — findings only; no code changes in this phase  
**Audience:** Engineering + product before production store launch  
**Phase 2:** Implement fix backlog only after explicit approval

---

## 1. Executive summary

**Current posture: NO-GO for production users** until Critical items below are resolved.

- Release builds still target the **stage** backend (`AppEnvironment.stage` in both debug and release). Shipping as-is puts real users on non-production APIs.
- There is **no crash reporting** and no global Flutter error hooks — production failures will be invisible.
- Auth/session risk is high: tokens live in **plaintext Sembast**, **refresh token is unused**, and OTP success **force-unwraps** `authModel`.
- Money path is mostly API-wired (good), but concurrent Razorpay checkout can throw and leave payment UI in a **stuck loading** state; release signing can silently fall back to **debug** keystore.
- Core commerce features (cart, checkout, orders, prescription, wishlist, notifications, emergency) are **not mocked** — the bigger gaps are environment, observability, session security, and a few hardcoded UX surfaces (home banners, delivery zone).

---

## 2. Severity rubric

| Severity | Meaning |
|----------|---------|
| **Critical** | Blocks launch or can cause data loss, wrong-environment traffic, unpaid/stuck money UX, or silent production outages |
| **High** | Likely user-facing failure, security weakness, or ops gap that will hurt shortly after launch |
| **Medium** | Quality / maintainability / incomplete product surface; shippable with known follow-up if accepted |
| **Low** | Cleanup, unused code, or latent risk with low current impact |

---

## 3. Findings by domain

### 3.1 Environment / flavors

#### C-ENV-01 — Release always uses stage API
- **Severity:** Critical  
- **Evidence:** [`lib/main.dart`](../../../lib/main.dart) calls `configureAppEnvironment(kDebugMode ? AppEnvironment.stage : AppEnvironment.stage)`. Prod base URL exists in [`lib/res/enums/app_environment.dart`](../../../lib/res/enums/app_environment.dart) (`https://production-backend.medpik.in`) but is never selected.  
- **Impact:** “Release” APK/IPA still hits stage; prod data, payments, and ops monitoring will not match reality.  
- **Recommended fix:** Select `AppEnvironment.prod` for release (or flavors / `--dart-define=APP_ENV=prod`). Fail CI if release build is not prod.

---

### 3.2 Crash / error observability

#### C-OBS-01 — No crash reporting or global error handlers
- **Severity:** Critical  
- **Evidence:** `pubspec.yaml` has no `firebase_crashlytics` / `sentry_flutter`. [`lib/services/firebase_service.dart`](../../../lib/services/firebase_service.dart) is a stub. Grep finds no `FlutterError.onError`, `PlatformDispatcher.instance.onError`, or `runZonedGuarded` in [`lib/main.dart`](../../../lib/main.dart).  
- **Impact:** Crashes and uncaught async errors are invisible after store release; cannot triage or roll back with data.  
- **Recommended fix:** Wire Crashlytics or Sentry before launch; attach Flutter + zone + isolate handlers; upload symbols with obfuscated builds.

#### H-OBS-02 — No product analytics
- **Severity:** High  
- **Evidence:** No Firebase Analytics / Mixpanel / Amplitude / Segment packages. Only Razorpay SDK analytics → `debugPrint` in [`lib/services/razorpay_payment_service.dart`](../../../lib/services/razorpay_payment_service.dart).  
- **Impact:** Cannot measure funnel drop-off (OTP → cart → pay) or detect silent UX breakage.  
- **Recommended fix:** Add minimal analytics for auth, add-to-cart, place-order, payment success/fail/cancel.

---

### 3.3 Security & secrets

#### C-SEC-01 — Access / refresh tokens stored in plaintext Sembast
- **Severity:** Critical  
- **Evidence:** [`lib/data/local/sembast_services.dart`](../../../lib/data/local/sembast_services.dart) writes `accessToken` / `refreshToken` into `auth_tokens` and duplicates them in `user_session` via unencrypted `databaseFactoryIo` under app documents. No `flutter_secure_storage` (or equivalent) in dependencies.  
- **Impact:** On a rooted/jailbroken or backup-extracted device, session tokens are readable.  
- **Recommended fix:** Store tokens in platform secure storage; keep non-secret profile fields in Sembast if needed.

#### C-SEC-02 — OneSignal App ID default baked into source
- **Severity:** Critical (config leakage / wrong-project risk)  
- **Evidence:** [`lib/res/constants/app_constants.dart`](../../../lib/res/constants/app_constants.dart) — `ONESIGNAL_APP_ID` `defaultValue: 'bc15686a-2431-4099-8916-1f2c0ff361ac'`.  
- **Impact:** Release can silently target a hardcoded project; ID is in VCS forever. Prefer empty default + fail-closed init (pattern already used for Maps).  
- **Recommended fix:** Empty default; require dart-define / CI secret; document rotation.

#### H-SEC-03 — Google Maps key empty unless dart-define (good fail-closed; release risk if skipped)
- **Severity:** High  
- **Evidence:** [`app_constants.dart`](../../../lib/res/constants/app_constants.dart), [`location_config.dart`](../../../lib/services/location/location_config.dart). [`tool/build_release_apk.sh`](../../../tool/build_release_apk.sh) correctly refuses empty key when used; plain `flutter build apk --release` does not.  
- **Impact:** Address search / reverse geocode broken if someone builds without the script.  
- **Recommended fix:** Enforce key presence in all release pipelines; restrict key by package/SHA/bundle in Google Cloud.

#### H-SEC-04 — Legal WebView allows unrestricted JavaScript; no URL allowlist
- **Severity:** High  
- **Evidence:** [`lib/src/profile/view/legal_document_screen.dart`](../../../lib/src/profile/view/legal_document_screen.dart) — `JavaScriptMode.unrestricted`; `NavigationDelegate` does not block navigation to unexpected hosts. URLs come from [`AppConstants.privacyPolicyUrl` / `termsAndConditionsUrl`](../../../lib/res/constants/app_constants.dart) → `environment.webBaseUrl` (currently same dashboard host for all envs).  
- **Impact:** If URL ever changes or is MITM’d / misconfigured, WebView can load arbitrary pages with JS.  
- **Recommended fix:** Restrict navigation to allowlisted hosts; consider local packaged legal HTML as fallback.

#### M-SEC-05 — No certificate pinning
- **Severity:** Medium  
- **Evidence:** Dio client in [`network_services.dart`](../../../lib/data/remote/network_services.dart); HTTPS used via env base URLs; no pinning / custom `badCertificate` handling beyond enum mapping.  
- **Impact:** Standard TLS trust model only; acceptable for many apps, higher risk for payments/auth if threat model requires pinning.  
- **Recommended fix:** Decide with security owner; if required, pin prod API with rotation plan.

#### M-SEC-06 — iOS declares Always location usage strings
- **Severity:** Medium  
- **Evidence:** [`ios/Runner/Info.plist`](../../../ios/Runner/Info.plist) includes `NSLocationAlwaysAndWhenInUseUsageDescription` and `NSLocationAlwaysUsageDescription` while product copy says location is not for background tracking. Android uses fine/coarse only (no background).  
- **Impact:** App Store review questions; permission overstatement vs actual use.  
- **Recommended fix:** Remove Always keys if only When-In-Use is used.

#### L-SEC-07 — Network logger gated (good)
- **Severity:** Low (positive)  
- **Evidence:** [`lib/utils/helpers/network_logger.dart`](../../../lib/utils/helpers/network_logger.dart) returns early unless `kDebugMode`; tokens masked in request logs.  
- **Impact:** Release builds should not dump full API bodies via this helper.  
- **Recommended fix:** Keep as-is; audit any other `debugPrint` of PII in payment/auth paths for volume only.

**Permissions note (Android):** [`AndroidManifest.xml`](../../../android/app/src/main/AndroidManifest.xml) — INTERNET, CAMERA, fine/coarse location, POST_NOTIFICATIONS. No broad storage/gallery permission (aligned with system pickers). No `usesCleartextTraffic` override found — good default HTTPS posture.

**Payment keys:** Razorpay key is loaded from **backend** `payment/init` (`OrderPaymentCheckoutData.razorpayKey`), not hardcoded — correct pattern. Signature verification must remain server-side (assume backend responsibility; client only submits ids/signature).

---

### 3.4 Auth & session

#### C-AUTH-01 — Token refresh not implemented
- **Severity:** Critical  
- **Evidence:** [`network_services.dart`](../../../lib/data/remote/network_services.dart) `getAccessTokenWithRefreshToken()` always returns `false` with comment “No refresh endpoint”. Stored refresh token is unused. 401 path forces logout via `_forceLogout`.  
- **Impact:** Users bounced to login whenever access token expires mid-session (cart/checkout especially painful).  
- **Recommended fix:** Implement refresh endpoint + client rotation, or document short-lived UX and accept forced re-auth with clear messaging.

#### C-AUTH-02 — OTP success force-unwraps nullable `authModel`
- **Severity:** Critical  
- **Evidence:** [`lib/src/auth/notifier/auth_notifier.dart`](../../../lib/src/auth/notifier/auth_notifier.dart) line ~170: `final authModel = right.authModel!;` while model exposes `AuthModel?`.  
- **Impact:** Malformed success payload crashes login (bad first impression / store review risk).  
- **Recommended fix:** Null-guard; show toast and stay on OTP screen.

---

### 3.5 Payments & money flows

#### C-PAY-01 — Concurrent Razorpay open can leave payment loading stuck
- **Severity:** Critical  
- **Evidence:** [`razorpay_payment_service.dart`](../../../lib/services/razorpay_payment_service.dart) `openCheckout` returns `Future.error(StateError(...))` if checkout already in progress. [`orders_notifier.payOrder`](../../../lib/src/orders/notifier/orders_notifier.dart) sets `isPaymentLoading: true`, awaits `_payOnline` / COD, then sets false — **no try/finally**. UI uses `PopScope(canPop: !isPaymentLoading)`.  
- **Impact:** Uncaught error → spinner forever, back blocked, user cannot complete pay.  
- **Recommended fix:** try/finally around pay; return cancelled/error result instead of `Future.error`; disable double-tap at UI + service.

#### H-PAY-02 — Razorpay email prefill fallback
- **Severity:** High (data quality / Razorpay risk)  
- **Evidence:** [`razorpay_checkout_options_helper.dart`](../../../lib/utils/helpers/razorpay_checkout_options_helper.dart) — `customer@medpik.app` when profile email empty.  
- **Impact:** Wrong customer email on Razorpay side; support/refund friction.  
- **Recommended fix:** Omit email prefill when missing, or require email in profile before online pay.

#### Money-flow wiring status (spot-check)

| Flow | Status |
|------|--------|
| Cart CRUD | API-wired |
| Checkout place order | API-wired |
| Payment init → Razorpay → submit | API-wired (key from backend) |
| COD submit | API-wired |
| Prescription multipart order | API-wired |
| Orders list/detail/bill | API-wired |
| Wishlist / notifications / emergency | API-wired |

No full mock/stub repositories found on these paths. Residual risk is error handling and observability, not “fake checkout.”

---

### 3.6 API completeness vs mocks / hardcodes

#### H-API-01 — Home offers / featured brands use hardcoded assets
- **Severity:** High  
- **Evidence:** [`home_feed_slivers.dart`](../../../lib/src/home/view/widget/home_feed_slivers.dart) comment: “Hardcoded image banners until home API returns offer image URLs.” Uses [`HomePromoBannerCarousel`](../../../lib/src/home/view/widget/home_promo_banner_carousel.dart) + [`MedpikImageAssets`](../../../lib/res/constants/medpik_image_assets.dart). API-driven `HomeOfferCarousel` exists but is unused in the feed. Offers parse `promoCode` in models but banners are non-interactive.  
- **Impact:** Cannot update promos without app release; marketing mismatch with backend offers.  
- **Recommended fix:** Wire API image URLs / reuse `HomeOfferCarousel`, or hide section until CMS ready.

#### H-API-02 — Delivery serviceability hardcoded to Kerala hub
- **Severity:** High  
- **Evidence:** [`location_config.dart`](../../../lib/services/location/location_config.dart) — Thrissur hub, 150 km radius, `deliveryState = 'Kerala'`, Kerala bounding box. Not driven by store profile API.  
- **Impact:** Expansion or backend zone changes require app release; wrong reject/accept near borders.  
- **Recommended fix:** Drive zones from store/backend config.

#### H-API-03 — Coupon apply missing on client
- **Severity:** High (product completeness)  
- **Evidence:** Models/strings support coupons (`OfferModel.promoCode`, `applied_coupon_code`, `Strings.couponApplied`) but no cart/checkout apply-coupon API/UI found.  
- **Impact:** Users see promo language without ability to apply codes (or only server-side unknown to UX).  
- **Recommended fix:** Ship apply-coupon end-to-end or remove promo affordances until ready.

#### M-API-04 — Unused / orphaned API & routes
- **Severity:** Medium  
- **Evidence:** `AppConstants.products` / `categories` unused; tab route constants (`routeCartScreen`, etc.) not registered in `RouteGenerator` (tabs via IndexedStack — OK if never `pushNamed`); [`lib/src/empty/empty_screen.dart`](../../../lib/src/empty/empty_screen.dart) demo leftover.  
- **Impact:** Confusion / accidental navigation to “No route defined”.  
- **Recommended fix:** Remove or register; delete empty demo screen from release tree if unused.

---

### 3.7 Network / offline

#### H-NET-01 — Dio timeouts map to generic `unknown`, not network LoaderState
- **Severity:** High  
- **Evidence:** On `DioException` without response, [`_executeRequest`](../../../lib/data/remote/network_services.dart) returns `BaseResponse(statusCode: error.response?.statusCode, …)` → often null → `_resolveHttpStatus` `_` branch → `ApiErrorTypes.unknown`. [`handleResponseError`](../../../lib/utils/helpers/api_error_handler.dart) maps many timeout types to `LoaderState.error` (and those types are often unreachable). Timeouts ~60s; no retry interceptor.  
- **Impact:** Offline/flaky networks show generic error, long waits, poor recovery UX.  
- **Recommended fix:** Map Dio types to `connectionTimeout` / `connectionError` / `noInternet`; prefer `LoaderState.networkError`; add bounded retry with jitter for idempotent GETs.

#### H-NET-02 — Connectivity snackbar effectively broken
- **Severity:** High  
- **Evidence:** [`ConnectivityObserver`](../../../lib/utils/common_widgets/connectivity_observer.dart) docs say place under `MaterialApp.builder`, but [`medpik_app.dart`](../../../lib/src/root/medpik_app.dart) wraps **outside** `MaterialApp`. Uses `ScaffoldMessenger.maybeOf(context)` → typically null. Hardcoded snackbar strings/colors (violates project string/palette rules).  
- **Impact:** Users get no global online/offline toast; only screen-level `CommonSwitchState` when loader mapped correctly.  
- **Recommended fix:** Move observer under `MaterialApp.builder`; use `Strings` + `ColorPalette`.

---

### 3.8 Release build / signing / obfuscation

#### C-REL-01 — Release signing falls back to debug keystore
- **Severity:** Critical  
- **Evidence:** [`android/app/build.gradle.kts`](../../../android/app/build.gradle.kts) — if release `storeFile` missing, uses `signingConfigs.getByName("debug")`.  
- **Impact:** Accidental Play upload or sideload with debug identity; update path broken; security posture weak.  
- **Recommended fix:** Fail the release build if keystore props incomplete.

#### H-REL-02 — Minify / shrink / Dart obfuscation not enabled
- **Severity:** High  
- **Evidence:** Release Gradle sets `proguardFiles` but does not set `isMinifyEnabled` / `isShrinkResources`. [`tool/build_release_apk.sh`](../../../tool/build_release_apk.sh) / IPA script: `flutter build … --release` only — no `--obfuscate --split-debug-info`.  
- **Impact:** Larger APK; easier reverse engineering of Dart; ProGuard rules unused.  
- **Recommended fix:** Enable minify+shrink; obfuscate with stored symbols for crash deobfuscation.

#### H-REL-03 — No force-update / min-version gate
- **Severity:** High  
- **Evidence:** [`splash_notifier.dart`](../../../lib/src/splash/notifier/splash_notifier.dart) — delay + session check only; no `PackageInfo` / remote min version.  
- **Impact:** Cannot force broken clients off after a critical hotfix.  
- **Recommended fix:** Splash/remote config min version + store URL dialog (soft + hard).

---

### 3.9 Performance & memory

#### M-PERF-01 — Large in-memory image cache caps
- **Severity:** Medium  
- **Evidence:** [`configureImageCache`](../../../lib/utils/helpers/common_functions.dart) — 500 entries / 200MB.  
- **Impact:** Mid/low-end devices may OOM under heavy browse.  
- **Recommended fix:** Lower caps for production (e.g. 100–200 / 50–100MB) and validate on low-end hardware.

#### L-PERF-02 — List / image patterns mostly sound
- **Severity:** Low (positive)  
- **Evidence:** Dynamic lists use builders; `CommonCachedNetworkImage` sets mem cache bounds. Static detail screens use `ListView(children:)` — acceptable for small fixed trees.  
- **Recommended fix:** Keep; profile home GIF / carousel memory on device.

---

### 3.10 Crashable code (selected)

| ID | Severity | Evidence | Impact |
|----|----------|----------|--------|
| C-AUTH-02 | Critical | `authModel!` | Login crash |
| C-PAY-01 | Critical | Razorpay `Future.error` without finally | Stuck pay UI |
| M-CRASH-01 | Medium | Theme `extension<AppColors>()!` in palette helpers | Crash if theme misconfigured |
| L-CRASH-02 | Low | Several `!` after explicit guards (bill PDF, location confirm) | Low if guards hold |

---

### 3.11 Store / compliance / ops

| ID | Severity | Finding |
|----|----------|---------|
| H-OPS-01 | High | No force update (see H-REL-03) |
| H-OPS-02 | High | No analytics (see H-OBS-02) |
| M-OPS-03 | Medium | Legal only via remote WebView; no offline asset fallback |
| M-OPS-04 | Medium | Money-flow notifier/integration tests largely missing (helpers/models only) |
| M-OPS-05 | Medium | App version `1.0.0+3` — confirm store listing, privacy policy URL live, account deletion flow tested (delete-account API exists) |

---

## 4. What looks solid

Do **not** re-litigate these unless regressions appear:

- **Commerce is real API**, not mock data: cart, checkout, orders, payment init, prescription upload, wishlist, in-app notifications, emergency services.
- **HTTPS base URLs** for stage/prod backends; no cleartext traffic flag found on Android main manifest.
- **Razorpay key from backend** payment init (not a client-hardcoded secret).
- **Network logger** is debug-only with token masking.
- **Controllers** for forms/search generally live in notifiers with `ref.onDispose`.
- **Image decode bounding** via `CommonCachedNetworkImage` mem cache width/height.
- **OneSignal init** is defensive (empty app id skips; try/catch; double-init guards).
- **Release Maps script** refuses empty `GOOGLE_MAPS_API_KEY` when using `tool/build_release_*.sh`.
- **Permissions** are relatively lean (camera for Rx, location for address, notifications).

---

## 5. Feature map (`lib/src/`)

| Feature | API-backed? | Launch note |
|---------|-------------|-------------|
| `auth/` | Yes | Refresh missing; `authModel!` risk |
| `splash/` | Local | No version gate |
| `home/` | Yes (+ hardcoded banners) | Wire CMS banners |
| `search/` | Yes | OK |
| `product_detail/` | Yes | OK |
| `cart/` | Yes | OK |
| `checkout/` | Yes | No coupon apply |
| `orders/` | Yes | Payment hang risk |
| `prescription/` | Yes | OK |
| `wishlist/` | Yes | OK |
| `address/` | Yes + Google geocode | Needs Maps key; zone hardcoded |
| `profile/` | Yes; legal WebView | JS unrestricted |
| `notifications/` | Yes + OneSignal | App ID default in source |
| `emergency/` | Yes | OK |
| `device/` | Yes | OK |
| `main/` / `root/` | Local shell | ConnectivityObserver placement bug |
| `empty/` | Local demo | Remove from release awareness |

---

## 6. Prioritized fix backlog

### P0 — Must fix before production users (app / DevOps)

| # | Finding | Owner |
|---|---------|-------|
| 1 | Wire release → `AppEnvironment.prod` (C-ENV-01) | App + DevOps |
| 2 | Crash reporting + global error hooks (C-OBS-01) | App |
| 3 | Fail release if Android keystore missing (C-REL-01) | DevOps / App |
| 4 | Secure token storage (C-SEC-01) | App |
| 5 | Guard `authModel!` (C-AUTH-02) | App |
| 6 | Payment try/finally + no `Future.error` hang (C-PAY-01) | App |
| 7 | OneSignal App ID: empty default + CI dart-define (C-SEC-02) | App + DevOps |
| 8 | Token refresh or accepted re-auth product decision (C-AUTH-01) | App + Backend |

### P1 — Strongly recommended before or immediately after soft launch

| # | Finding | Owner |
|---|---------|-------|
| 9 | Force-update / min-version on splash (H-REL-03) | App + Backend |
| 10 | Dio → network LoaderState + ConnectivityObserver under MaterialApp (H-NET-01/02) | App |
| 11 | Minify + obfuscate + split-debug-info (H-REL-02) | App + DevOps |
| 12 | Home banners from API or hide (H-API-01) | App + Backend |
| 13 | Delivery zones from backend (H-API-02) | App + Backend |
| 14 | Coupon story: ship or remove (H-API-03) | Product + App + Backend |
| 15 | Maps/OneSignal keys required in all release pipelines (H-SEC-03) | DevOps |
| 16 | Legal WebView host allowlist (H-SEC-04) | App |
| 17 | Minimal analytics funnel (H-OBS-02) | App |
| 18 | Razorpay email prefill policy (H-PAY-02) | App |

### P2 — Follow-ups

| # | Finding | Owner |
|---|---------|-------|
| 19 | Lower image cache caps (M-PERF-01) | App |
| 20 | Remove Always location plist keys if unused (M-SEC-06) | App |
| 21 | Clean unused endpoints / orphan routes / empty screen (M-API-04) | App |
| 22 | Money-flow notifier/integration tests (M-OPS-04) | App |
| 23 | Certificate pinning decision (M-SEC-05) | Security + App |
| 24 | Offline/local legal fallback (M-OPS-03) | App |

---

## 7. Launch gate checklist

Must be **green** before production store rollout:

- [ ] Release binary talks to **production** backend only  
- [ ] Crash reporting receiving test events from release/profile build  
- [ ] Android release signed with **upload/release** keystore (debug fallback removed)  
- [ ] Tokens in secure storage (or accepted risk signed off by security owner)  
- [ ] OTP success null-safe; payment path cannot stick in loading  
- [ ] OneSignal + Maps keys injected via CI; no accidental empty Maps key  
- [ ] Soft/hard force-update path tested  
- [ ] Offline / timeout shows network error UX (spot-check airplane mode)  
- [ ] Privacy policy + T&C URLs load on device; account deletion verified  
- [ ] Payment: success, cancel, failure, COD — manual QA on real devices  
- [ ] Staged rollout plan (e.g. 5% → 20% → 100%) + rollback owner named  

Residual risk explicitly accepted if still open at launch (document who signed off):

- [ ] No cert pinning  
- [ ] Hardcoded home creatives / Kerala delivery rules  
- [ ] No coupon apply UI  
- [ ] Limited automated money-flow tests  

---

## 8. Out of scope / residual

- Backend threat modeling, API authz, Razorpay webhook verification, PCI (assume Razorpay hosted)  
- Store listing copy, screenshots, Play Data Safety / Apple privacy nutrition labels (process, not code)  
- Full DAST / pen-test of production hosts  
- Implementing fixes (Phase 2 — separate approval)

---

## 9. Phase 2 handoff

This document is **findings only**. When ready to remediate:

1. Approve P0 backlog (section 6).  
2. Open an implementation plan / PR wave starting with C-ENV-01, C-OBS-01, C-REL-01, C-AUTH-02, C-PAY-01.  
3. Re-run this checklist after fixes; do not treat this audit as a living status board until updated.

**Report status:** Complete for client-side read-only audit as of 2026-11-11.

---

## 10. Remediation status (Phase 2 — 2026-11-11)

P0 items addressed in code (verify before store submit):

| ID | Status |
|----|--------|
| C-ENV-01 Release → prod | Done — `main.dart` uses `AppEnvironment.prod` when `!kDebugMode` |
| C-OBS-01 Crash reporting | Done — Firebase Crashlytics + global hooks (soft-fails if Firebase config missing) |
| C-REL-01 Debug signing fallback | Done — release build throws if keystore missing |
| C-SEC-01 Plaintext tokens | Done — `flutter_secure_storage` + Sembast migration/scrub |
| C-AUTH-02 `authModel!` | Done — null/empty access guarded |
| C-PAY-01 Payment hang | Done — try/finally + no `Future.error` on concurrent checkout |
| C-SEC-02 OneSignal default ID | Done — empty default; bootstrap/release scripts require `ONESIGNAL_APP_ID` |
| C-AUTH-01 Token refresh | Done client-side — calls `POST /api/auth/token/refresh`; **backend must implement** this endpoint or users still re-login after expiry |

**Ops follow-ups still required:** ensure `google-services.json` / `GoogleService-Info.plist` present for Crashlytics; confirm backend refresh-token route; CI secrets + keystore.

### Phase 3 — P1 (2026-11-11) — deferred intentionally

Left for later (per product): home banners API, delivery zones from backend, coupons, backend refresh confirmation.

| ID | Status |
|----|--------|
| H-REL-03 Force update | Done — `MIN_APP_VERSION` dart-define + splash gate |
| H-NET-01/02 Offline UX | Done — Dio transport → `networkError`; ConnectivityObserver under `MaterialApp.builder` |
| H-REL-02 Minify/obfuscate | Done — Gradle minify/shrink + release scripts `--obfuscate --split-debug-info` |
| H-SEC-04 Legal allowlist | Done — HTTPS + `webBaseUrl` host only |
| H-OBS-02 Analytics | Done — light Firebase Analytics funnel (login/cart/place/pay) |
| H-PAY-02 Razorpay email | Done — omit empty email (no fake fallback) |
| M-PERF-01 Image cache | Done — 150 entries / 80MB |
| M-SEC-06 Always location plist | Done — When-In-Use only |
