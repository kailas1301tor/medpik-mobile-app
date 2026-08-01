# AGENTS.md — Flutter Production Engineering Rules

## PROJECT ADAPTERS (Medpik)

This repo uses the following mappings from generic rule names to actual project code:

| Rule / template name | Medpik implementation |
|----------------------|------------------------|
| Package imports | `package:medpik/...` |
| Font styles | [`FontPalette`](lib/res/styles/font_palette.dart) (`onest` family) |
| Primary CTA button | [`PrimaryButton`](lib/utils/common_widgets/primary_button.dart) |
| Text inputs | [`CommonTextFormField`](lib/utils/common_widgets/common_text_form_field.dart) |
| Body text | `Text` with `FontPalette` styles (no `CommonTextWidget` in this repo yet) |
| App display name | `Strings.appName` → **medpik** |

---

## ROLE

You are a Senior Flutter Engineer (8+ years experience) working on this codebase.
Generate production-grade Dart/Flutter code only.
Priority order: Maintainability > Readability > Safety > Performance.
Never take shortcuts. Never generate beginner patterns.

---

## REPO STRUCTURE AWARENESS

Before generating any code:
1. Scan existing folder structure to stay consistent.
2. Never create files outside the established feature pattern.
3. Never modify files outside the scope of the task.
4. Check `res/constants/string_constants.dart`, `res/styles/color_palette.dart`, and `res/styles/font_palette.dart` before hardcoding any value.

---

## FEATURE ARCHITECTURE

Every feature MUST use this exact structure. Generate all layers unless told otherwise.

```
feature_name/
├── model/
│   └── feature_model.dart
├── state/
│   └── feature_state.dart
├── notifier/
│   └── feature_notifier.dart
├── repo/
│   └── feature_repository.dart
└── view/
    ├── feature_screen.dart
    └── widget/
        └── feature_content_widget.dart
```

Rules:
- Features are fully self-contained. Never import across feature boundaries except for `utils/`, `res/`, and `data/`.
- Business logic lives in `notifier/` and `repo/` only.
- UI lives in `view/`. Sub-widgets live in `view/widget/`.
- If generating a full feature, output ALL layers in order: model → state → repo → notifier → view.

---

## STATE MANAGEMENT — RIVERPOD CODE GEN

ALWAYS use Riverpod with code generation. NEVER use `StateNotifierProvider`, `ChangeNotifier`, or manual providers.

```dart
// notifier/feature_notifier.dart
part 'feature_notifier.g.dart';

@Riverpod(keepAlive: false)
class FeatureNotifier extends _$FeatureNotifier {
  @override
  FeatureState build() => const FeatureState();

  Future<void> fetchData() async {
    state = state.copyWith(loaderState: LoaderState.loading);

    return await ref.read(featureRepositoryProvider)
        .getFeatureData()
        .fold(
          (left) {
            // left.key is ApiErrorTypes — always map via handleResponseError
            final loaderState = handleResponseError(left.key);
            debugPrint("🔴 API ERROR: ${left.message}");
            state = state.copyWith(loaderState: loaderState);
          },
          (right) {
            if (right.results?.data == null) {
              state = state.copyWith(loaderState: LoaderState.noData);
              return;
            }
            debugPrint("🟢 API SUCCESS: ${right.results?.data}");
            state = state.copyWith(
              loaderState: LoaderState.loaded,
              data: right.results?.data,
            );
          },
        )
        .catchError((e) {
          debugPrint("🔴 UNEXPECTED ERROR: $e");
          state = state.copyWith(loaderState: LoaderState.error);
        });
  }
}
```

Rules:
- Call `.fold()` directly on the repo future — do NOT await into a variable first.
- Left branch (error): ALWAYS call `handleResponseError(left.key)` to map `ApiErrorTypes` → `LoaderState`. NEVER hardcode `LoaderState.error` directly.
- Right branch (success): check for null data first — set `LoaderState.noData` if null, otherwise `LoaderState.loaded`.
- ALWAYS chain `.catchError()` after `.fold()` to guard against unexpected exceptions.
- Use `debugPrint` with emoji prefix for all log lines — NEVER `print()` or `log()`.
- If the success branch needs to trigger a subsequent async call (e.g. fetch related data), use `async` on the right lambda and `await` inside it.
- UI reads state via `ref.watch(featureNotifierProvider)`.
- UI triggers actions via `ref.read(featureNotifierProvider.notifier).fetchData()`.
- One notifier per feature. Never nest providers unnecessarily.

Provider naming:
- Notifier → `featureNotifierProvider`
- Repository → `featureRepositoryProvider`

---

## STATE — FREEZED

ALL state classes MUST be Freezed. NEVER use mutable state.

```dart
// state/feature_state.dart
part 'feature_state.freezed.dart';

@freezed
sealed class FeatureState with _$FeatureState {
  const factory FeatureState({
    @Default(LoaderState.loaded) LoaderState loaderState,
    FeatureData? data,
    String? errorMessage,
    // Use bool flags only for button/inline action loaders; use LoaderState for screen content.
  }) = _FeatureState;
}
```

- Always use `copyWith` for updates.
- Always include `LoaderState loaderState` for API-backed screen/content loading.
- Use `bool` flags only for button/inline action loaders (see **Button and inline loaders** below).
- Never store derived or computed values in state.

**Loader type choice:**
- **Screen / content / list loading** → `LoaderState` (`loaderState`, `detailLoaderState`, etc.) with full switch (`loading`, `error`, `noData`, `networkError`, `serverError`, `loaded`)
- **Button / inline / small loaders** → `bool isSubmitting` / `isPaymentLoading` / `isBillActionLoading` — `true` only while an action is in-flight; reset to `false` in `finally`; surface errors via toast/dialog, not via the bool

---

## LOADER STATE

Use `LoaderState` for **screen and content** loading (lists, detail fetches, full-page shimmers).
NEVER substitute raw booleans for screen/content loaders.

For **button spinners** and **inline loaders**, use `bool` instead — see **Button and inline loaders** below.

```dart
enum LoaderState {
  loaded,
  loading,
  error,
  noData,
  networkError,   // no internet / connection timeout
  serverError,    // 5xx internal server error
}
```

UI MUST switch exhaustively on `loaderState`. Use `CommonSwitchState` for standard
list/scroll screens (inside `CommonRefreshIndicator` when pull-to-refresh is needed), and a
manual switch for custom layouts:

```dart
// Standard screens — use the shared widget:
CommonRefreshIndicator(
  onRefresh: () => ref.read(featureNotifierProvider.notifier).fetchData(),
  child: CommonSwitchState(
    loaderState: state.loaderState,
    reload: () => ref.read(featureNotifierProvider.notifier).fetchData(),
    loader: const FeatureShimmerWidget(),
    buttonText: Strings.refresh,
    child: FeatureContentWidget(data: state.data),
  ),
)

// Custom layouts — switch manually:
switch (state.loaderState) {
  case LoaderState.loading      => const FeatureShimmerWidget(),
  case LoaderState.error        => ErrorWidget(message: state.errorMessage ?? ''),
  case LoaderState.networkError => const NoInternetWidget(),
  case LoaderState.serverError  => const ServerErrorWidget(),
  case LoaderState.noData       => const EmptyStateWidget(),
  case LoaderState.loaded       => FeatureContentWidget(data: state.data),
}
```

### Button and inline loaders (bool)

Use a `bool` for `PrimaryButton.isLoading`, inline spinners, and sheet action buttons.
Do NOT use `LoaderState` for these — they only need loading vs idle.

```dart
// state/feature_state.dart
@Default(false) bool isPaymentLoading,

// notifier/feature_notifier.dart
state = state.copyWith(isPaymentLoading: true);
try {
  await repo.submit(...).fold(
    (error) { showCustomErrorToast(...); },
    (right) { ... },
  );
} finally {
  state = state.copyWith(isPaymentLoading: false);
}

// view — use .select()
final isLoading = ref.watch(
  featureNotifierProvider.select((s) => s.isPaymentLoading),
);
PrimaryButton(
  isLoading: isLoading,
  onPressed: isLoading ? null : _submit,
);
```

Rules:
- `handleResponseError` maps to `LoaderState` for **screen** loaders only.
- Button/inline actions: toast on error + `false` in `finally` — never assign `LoaderState` to a button bool.
- During Razorpay checkout (SDK modal), set the button bool to `false` so the UI is not blocked behind the modal.

---

## handleResponseError — MANDATORY

ALWAYS use `handleResponseError` to map `ApiErrorTypes` → `LoaderState` in notifier error branches.
NEVER manually assign `LoaderState.error` from a raw error — always go through this function.

```dart
// utils/helpers/api_error_handler.dart
LoaderState handleResponseError(ApiErrorTypes errorType) {
  return switch (errorType) {
    ApiErrorTypes.noInternet          => LoaderState.networkError,
    ApiErrorTypes.internalServerError => LoaderState.serverError,
    ApiErrorTypes.serviceUnavailable  => LoaderState.serverError,
    ApiErrorTypes.cancel              => LoaderState.error,
    ApiErrorTypes.badCertificate      => LoaderState.error,
    ApiErrorTypes.badResponse         => LoaderState.error,
    ApiErrorTypes.connectionError     => LoaderState.error,
    ApiErrorTypes.connectionTimeout   => LoaderState.error,
    ApiErrorTypes.badRequest          => LoaderState.error,
    ApiErrorTypes.jsonParsing         => LoaderState.error,
    ApiErrorTypes.sendTimeout         => LoaderState.error,
    ApiErrorTypes.notFound            => LoaderState.error,
    ApiErrorTypes.oops                => LoaderState.error,
    ApiErrorTypes.unAuthorized        => LoaderState.error,
    ApiErrorTypes.receiveTimeout      => LoaderState.error,
    _                                 => LoaderState.error,
  };
}
```

---

## ERROR HANDLING, VALIDATION, AND API RULES — MANDATORY

### Field validation (state)

- State error fields are **only** for inline validation beneath text fields or other form inputs (e.g. `firstNameError`, `lastNameError`).
- **Every validated input must have its own dedicated error state.** If a form has `firstName` and `lastName`, state must include `firstNameError` and `lastNameError`. Never reuse one error field for multiple inputs or leave validated fields without a matching error state.
- Clear the matching error state when the user edits that field (controller listener in the notifier).
- Do **not** store general API error messages in state.

### API error handling (toast)

- For all API calls (GET, POST, PUT, PATCH, DELETE), do **not** store error messages in state for UI display.
- Display API errors with `showCustomErrorToast`. Display success with `showCustomToast` where appropriate.
- Screen/content loaders still use `LoaderState` via `handleResponseError` — toasts are additive, not a replacement for loader state.

### Avoid redundant try-catch

- Do **not** wrap API `.fold()` chains in extra `try-catch` unless there is a specific, justified need.
- Rely on `.fold()` left/right branches plus `.catchError()` for unexpected failures.
- Do **not** add `try-catch` solely for toast or notification display.

```dart
// GET — loader state + toast on failure
return await ref.read(featureRepositoryProvider)
    .getFeatureData()
    .fold(
      (left) {
        final loaderState = handleResponseError(left.key);
        debugPrint("🔴 API ERROR: ${left.message}");
        showCustomErrorToast(message: left.message ?? Strings.somethingWentWrong);
        state = state.copyWith(loaderState: loaderState);
      },
      (right) { /* success */ },
    )
    .catchError((e) {
      debugPrint("🔴 UNEXPECTED ERROR: $e");
      showCustomErrorToast(message: Strings.somethingWentWrong);
      state = state.copyWith(loaderState: LoaderState.error);
    });

// PUT — bool action loader + toast; per-field errors in state only
if (firstName.isEmpty) {
  state = state.copyWith(firstNameError: Strings.firstNameRequired);
  return false;
}
state = state.copyWith(isSaving: true, firstNameError: null, lastNameError: null);
return await repo.update(payload).fold(
  (left) {
    state = state.copyWith(isSaving: false);
    showCustomErrorToast(message: left.message ?? Strings.somethingWentWrong);
    return false;
  },
  (right) async {
    state = state.copyWith(isSaving: false);
    showCustomToast(message: Strings.saved, isSuccess: true);
    return true;
  },
).catchError((e) {
  state = state.copyWith(isSaving: false);
  showCustomErrorToast(message: Strings.somethingWentWrong);
  return false;
});
```

| Concern | Approach |
|---------|----------|
| Inline field validation | Dedicated `fieldNameError` per validated input in Freezed state |
| API errors / success | Toast only — never `errorMessage` in state |
| Screen loading | `LoaderState` via `handleResponseError` |
| Button / inline actions | `bool isSaving` — reset in `.fold()` / `.catchError()`, not `try-finally` unless justified |

---

## REPOSITORIES — EITHER PATTERN

ALL repository methods MUST return `Either<ResponseError, T>`. NEVER throw errors to the UI.

```dart
// repo/feature_repository.dart
abstract class FeatureRepo {
  Future<Either<ResponseError, FeatureResponse>> getFeatureData();
}

class FeatureRepoImpl implements FeatureRepo {
  final _services = container.read(networkServicesProvider);

  @override
  Future<Either<ResponseError, FeatureResponse>> getFeatureData() async {
    return await _services
        .safe(_services.getRequest(endPoint: AppConstants.featureEndpoint))
        .thenRight(_services.checkHttpStatus)
        .thenRight(_services.parseJson)
        .mapRight((right) => FeatureResponse.fromJson(convertToMap(right)));
  }
}
```

- Repositories handle: API calls, response validation, model parsing only.
- Repositories NEVER modify UI state.
- Chain MUST be: `.safe()` → `.thenRight(checkHttpStatus)` → `.thenRight(parseJson)` → `.mapRight(Model.fromJson)`.
- **Pass the full JSON envelope** into `Model.fromJson` — NEVER unwrap `results` / `data` (or other nested keys) inside the repository. Envelope drilling belongs in the model layer.

---

## MODELS — MANUAL JSON PARSING

NEVER use `json_serializable`. ALWAYS write manual `fromJson` factories using safe converters.

### API envelope — `results` / `data` (MANDATORY for backend responses)

Backend payloads follow `{ message?, status?, results: { data: { … } } }`.
Response models MUST mirror that shape with nested types. The repository passes the **whole** JSON map; models unwrap.

```dart
// model/feature_model.dart
class FeatureResponse {
  const FeatureResponse({
    required this.results,
    this.message = '',
    this.status = true,
  });

  final FeatureResultsModel results;
  final String message;
  final bool status;

  /// Optional convenience getters for UI (delegate into results.data).
  List<ItemModel> get items => results.data?.items ?? const [];

  factory FeatureResponse.fromJson(Map<String, dynamic> json) {
    final hasStatus = json.containsKey('status');
    return FeatureResponse(
      message: convertToString(json['message']),
      status: hasStatus ? convertToBool(json['status']) : true,
      results: FeatureResultsModel.fromJson(convertToMap(json['results'])),
    );
  }
}

class FeatureResultsModel {
  const FeatureResultsModel({this.data});

  final FeatureDataModel? data;

  factory FeatureResultsModel.fromJson(Map<String, dynamic> json) =>
      FeatureResultsModel(
        data: json['data'] == null
            ? null
            : FeatureDataModel.fromJson(convertToMap(json['data'])),
      );
}

class FeatureDataModel {
  const FeatureDataModel({this.items = const []});

  final List<ItemModel> items;

  factory FeatureDataModel.fromJson(Map<String, dynamic> json) =>
      FeatureDataModel(
        items: convertToList(json['items'])
            .map((e) => ItemModel.fromJson(convertToMap(e)))
            .toList(),
      );
}
```

Rules:
- NEVER peel `right['results']['data']` in the repository — pass `convertToMap(right)` to the top-level response `fromJson`.
- Top-level response model owns `results` (and optional `message` / `status`).
- `results` model owns `data`.
- Payload fields (`offers`, `categories`, `products`, etc.) live on the `data` model.
- Local-only UI overlays (greeting name, delivery hint, etc.) may sit on the top-level response and be filled by the notifier via `copyWith` — not from JSON.
- Convenience getters on the top-level model that delegate into `results.data` are allowed so UI stays clean.

### Nested / leaf models

```dart
class FeatureModel {
  const FeatureModel({
    required this.id,
    required this.name,
    this.child,
    this.items = const [],
  });

  final int id;
  final String name;
  final ChildModel? child;
  final List<ItemModel> items;

  factory FeatureModel.fromJson(Map<String, dynamic> json) => FeatureModel(
    id: convertToInt(json['id']),
    name: convertToString(json['name']),
    child: json['child'] == null
        ? null
        : ChildModel.fromJson(convertToMap(json['child'])),
    items: convertToList(json['items'])
        .map((e) => ItemModel.fromJson(convertToMap(e)))
        .toList(),
  );
}
```

Safe converters (`convertToString`, `convertToInt`, `convertToMap`, `convertToList`) handle null,
wrong type, and empty values without throwing.

---

## UI RULES

### Widget Type Selection

| Widget Type              | When to Use                                                       |
|--------------------------|-------------------------------------------------------------------|
| `StatelessWidget`        | Default. Pure UI, no state, no Riverpod.                          |
| `ConsumerWidget`         | Reads Riverpod state. No lifecycle needed.                        |
| `ConsumerStatefulWidget` | Needs Riverpod AND a purely visual lifecycle (e.g. AnimationController that has NO business logic). Rare. |
| `StatefulWidget`         | Purely local animation state only. Zero Riverpod. Extremely rare. |

NEVER use `StatefulWidget` or `ConsumerStatefulWidget` to hold `TextEditingController`,
`ScrollController`, or `FocusNode`. These belong in the notifier (see below).
NEVER use `StatefulWidget` for business logic, API calls, or app state.

---

## CONTROLLERS IN NOTIFIER — MANDATORY

**All `TextEditingController`, `ScrollController`, and `FocusNode` instances MUST live in the
feature notifier, not in the widget tree.**

### Why
- `ref.onDispose` inside `build()` auto-disposes them when the autoDispose provider is removed from the tree — no `StatefulWidget` lifecycle needed.
- Keeps ALL screens as lean `ConsumerWidget`.
- The notifier can add listeners directly and react without touching UI.
- Controllers are accessible to any widget in the subtree via `ref.read(featureNotifierProvider.notifier).controller` — no prop-drilling.
- Lifecycle is tied to the feature scope, not an arbitrary widget's subtree.

### Pattern

```dart
// notifier/feature_notifier.dart
@Riverpod(keepAlive: false)
class FeatureNotifier extends _$FeatureNotifier {
  late final TextEditingController searchController;
  late final ScrollController scrollController;
  late final FocusNode searchFocusNode;

  @override
  FeatureState build() {
    // Initialise
    searchController = TextEditingController();
    scrollController = ScrollController();
    searchFocusNode  = FocusNode();

    // Register disposal — fires automatically when autoDispose removes the provider
    ref.onDispose(() {
      searchController.dispose();
      scrollController.dispose();
      searchFocusNode.dispose();
    });

    // Attach listener if needed
    searchController.addListener(_onSearchChanged);

    return const FeatureState();
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();
    state = state.copyWith(searchQuery: query);
    // debounce, trigger API, etc.
  }

  void clearSearch() {
    searchController.clear();
    state = state.copyWith(searchQuery: '');
  }
}
```

### Accessing controllers in the widget

```dart
// In a ConsumerWidget — access via ref.read (never ref.watch for controllers)
class FeatureScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(featureNotifierProvider.notifier);

    return CommonScaffold(
      body: CommonSearchBar(
        controller: notifier.searchController,    // direct reference
        focusNode: notifier.searchFocusNode,
        onChanged: notifier.onSearch,
        onClear: notifier.clearSearch,
      ),
    );
  }
}
```

### Rules
- Declare controllers as `late final` fields on the notifier class.
- Initialise in `build()` — NOT in the constructor.
- Register ALL disposals with `ref.onDispose` in `build()`.
- NEVER call `.dispose()` manually from UI.
- Access controllers via `ref.read(notifierProvider.notifier).controller` — NEVER via `ref.watch`.
- Listeners added in `build()` are automatically removed when the provider is disposed.
- `AnimationController` requires a `TickerProvider` (from a `StatefulWidget` mixin) and therefore is the ONLY controller that MUST stay in a `StatefulWidget` / `ConsumerStatefulWidget`. Every other controller goes in the notifier.

### Exception — AnimationController only

```dart
// ConsumerStatefulWidget is justified ONLY for AnimationController
class FeatureAnimatedCard extends ConsumerStatefulWidget { ... }

class _FeatureAnimatedCardState extends ConsumerState<FeatureAnimatedCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: Durations.medium2);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }
}
```

---

## GRANULAR REBUILD RULES — MANDATORY

### Rule 1 — Always use `.select()` for `ref.watch`

NEVER watch the full provider state if only one or a few fields are used.
ALWAYS use `.select()` to watch only the fields the widget needs.

```dart
// WRONG — rebuilds on every state change
final state = ref.watch(featureNotifierProvider);
Text(state.title)

// CORRECT — rebuilds only when title changes
final title = ref.watch(featureNotifierProvider.select((s) => s.title));
Text(title)
```

### Rule 2 — Use `Tuple` for multi-field selection

When a widget needs multiple fields, use `Tuple` from the `tuple` package to group them
in a single `.select()`. Prefer Tuple2–Tuple4. If more than 4 fields are needed,
extract a dedicated sub-widget.

```dart
// Correct multi-field selection
final data = ref.watch(
  featureNotifierProvider.select(
    (s) => Tuple3(s.loaderState, s.items, s.selectedDate),
  ),
);
final loaderState = data.item1;
final items       = data.item2;
final selectedDate = data.item3;
```

### Rule 3 — Inline `Consumer` for isolated hot fields

Wrap **only** the widget that actually depends on state (card, text, badge, counter, or
timer) with a `Consumer`. Inside that `Consumer`, use `.select()` to watch only the specific
state fields the widget requires. If multiple fields are needed, group them using
Tuple2–Tuple4. This ensures each widget subscribes only to the data it needs, minimizing
unnecessary rebuilds.

Steps:

1. Keep the parent as `StatelessWidget` when possible.
2. Wrap **only** the state-dependent leaf in `Consumer`.
3. Inside `Consumer`, always `ref.watch(...select(...))`.
4. For 2–4 fields from the same provider, group with `Tuple2`–`Tuple4` in one `.select()`.
5. Never `ref.watch(provider)` on a notifier when only a subset of fields is used.

```dart
// Isolate the rebuild to only the changing text
Consumer(
  builder: (context, ref, _) {
    final count = ref.watch(cartNotifierProvider.select((s) => s.itemCount));
    return Text('$count', style: FontPalette.f0E0F0C_14_400);
  },
)

// Parent stays StatelessWidget — isolate wishlist state in a child Consumer
class HomeProductCard extends StatelessWidget {
  const HomeProductCard({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return _HomeProductCardWishlistScope(product: product);
  }
}

class _HomeProductCardWishlistScope extends ConsumerWidget {
  const _HomeProductCardWishlistScope({required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWishlisted = ref.watch(isProductWishlistedProvider(product.id));
    return CommonGlassProductCard(
      product: product,
      isWishlisted: isWishlisted,
      onWishlistTap: () => ref.read(wishlistFacadeServiceProvider).toggle(product),
    );
  }
}
```

### Rule 4 — Widget type selection (rebuild scope)

| Widget | When to Use |
|--------|-------------|
| `StatelessWidget` | Default for layout shells, static sections, list item chrome |
| `Consumer` (inline) | **Only** the badge, counter, button, text, or card leaf that reads Riverpod state |
| `ConsumerWidget` | Entire subtree genuinely depends on watched state (e.g. loader-switch screens with no stable children) |
| `ConsumerStatefulWidget` | AnimationController only (see exception above) |

Decision rule: if fewer than ~80% of the build tree needs state, use `StatelessWidget` +
inline `Consumer` on the hot leaf — do NOT promote the whole parent to `ConsumerWidget`.

---

## SHARED UI SYSTEM — MANDATORY

ALWAYS use existing shared widgets. NEVER create one-off implementations of these patterns.
Check `utils/common_widgets/` and `utils/extensions/` before writing any new UI code.

### CommonScaffold
Use for ALL screens instead of raw `Scaffold`.

```dart
CommonScaffold(
  appBar: CustomAppBar(title: Strings.featureTitle),
  body: const FeatureBody(),
)
```

### CommonAppBar
Use for ALL screen app bars. NEVER use raw `AppBar`.

```dart
CommonAppBar(
  title: Strings.featureTitle,
  actions: [
    CommonNavBarButton(icon: AppIcons.filter, onTap: _onFilter),
  ],
)
```

### CommonNavBarButton
Use for ALL icon buttons inside app bars and navigation areas.

```dart
CommonNavBarButton(
  icon: AppIcons.notifications,
  badgeCount: unreadCount,   // optional
  onTap: () => _onTap(),
)
```

### CommonSearchBar
Use for ALL search input fields. NEVER build a raw `TextField` for search.

```dart
CommonSearchBar(
  controller: _searchController,
  hintText: Strings.searchHint,
  onChanged: (q) => ref.read(featureNotifierProvider.notifier).onSearch(q),
  onClear: () => ref.read(featureNotifierProvider.notifier).clearSearch(),
)
```

### CommonContainer
Use for ALL styled card / box containers instead of raw `Container` with repeated decoration.

```dart
CommonContainer(
  padding: AppSpacing.all16,
  borderRadius: AppRadius.r12,
  color: ColorPalette.surfaceWhite,
  child: const FeatureCardContent(),
)
```

### CommonCachedNetworkImage
Use for ALL network images. NEVER use raw `Image.network` or `NetworkImage` directly.
Wraps `CachedNetworkImage` with a consistent placeholder, error widget, and memory cache constraints.

```dart
CommonCachedNetworkImage(
  url: item.imageUrl,
  width: 80,
  height: 80,
  borderRadius: AppRadius.r8,
  fit: BoxFit.cover,
)
```

Rules:
- Always pass explicit `width` and `height` to avoid layout thrash.
- Set `memCacheWidth` / `memCacheHeight` to the rendered pixel size to prevent oversized bitmaps.
- Never load full-resolution images into small thumbnails.

### Body text
Use `Text` with `FontPalette` styles for labels and copy. Do not hardcode `TextStyle(...)`.

```dart
Text(
  item.title,
  style: FontPalette.base400(14, color: colors.primaryText),
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

### CommonLoader
Use for ALL full-screen or overlay loading states. NEVER build ad-hoc spinners.

```dart
CommonLoader()            // Full-screen centred loader
CommonLoader.overlay()    // Semi-transparent overlay loader (blocks input)
```

### CommonRefreshIndicator
Use for ALL pull-to-refresh lists/scrolls. NEVER use raw `RefreshIndicator`.

```dart
CommonRefreshIndicator(
  onRefresh: () => ref.read(featureNotifierProvider.notifier).fetchData(),
  child: ListView.builder(...),
)
```

### CommonBottomSheet
Use for ALL bottom sheets via the shared helper. NEVER call `showModalBottomSheet` directly.

```dart
// Show:
CommonBottomSheet.show(
  context: context,
  title: Strings.filterOptions,
  child: const FilterOptionsContent(),
);

// Widget (when embedded):
CommonBottomSheet(
  title: Strings.sortBy,
  child: const SortContent(),
)
```

### CommonDialogBox
Use for ALL confirmation/alert dialogs. NEVER call `showDialog` with a raw `AlertDialog`.

```dart
CommonDialogBox.show(
  context: context,
  title: Strings.deleteConfirmTitle,
  message: Strings.deleteConfirmMessage,
  primaryLabel: Strings.confirm,
  onPrimary: () => _onConfirmDelete(),
  secondaryLabel: Strings.cancel,
);
```

### PrimaryButton
Use for ALL primary CTA buttons.

```dart
PrimaryButton(
  buttonText: Strings.next,
  isEnable: isValid,
  isLoading: isLoading,
  onPressed: isValid ? _handleSubmit : () {},
)
```

### CommonTextFormField
Use for ALL text input fields.

```dart
CommonTextFormField(
  controller: controller,
  hintText: Strings.fullName,
  onChanged: (val) => ref.read(featureNotifierProvider.notifier).onChanged(val),
)
```

### CommonSwitchState
Use for ALL loader/error/empty/content switching in scrollable or list screens.
Defined in `utils/common_widgets/common_switch_state.dart`. Does **not** wrap the loaded
child in `Expanded`, so `ListView` / `CustomScrollView` children are safe.

For `CustomScrollView` / sliver-based screens, use `CommonSwitchStateSliver` instead.

```dart
CommonRefreshIndicator(
  onRefresh: () => ref.read(featureNotifierProvider.notifier).fetchData(),
  child: CommonSwitchState(
    loaderState: loaderState,
    reload: () => ref.read(featureNotifierProvider.notifier).fetchData(),
    loader: const FeatureShimmerWidget(),
    buttonText: Strings.refresh,
    noData: const FeatureEmptyState(), // optional — overrides default empty UI
    child: const FeatureContent(),
  ),
)
```

When the switch sits below a fixed header inside a `Column`, wrap it in `Expanded`:

```dart
Column(
  children: [
    const FeatureHeader(),
    Expanded(
      child: CommonSwitchState(
        loaderState: loaderState,
        child: const FeatureContent(),
      ),
    ),
  ],
)
```

If a needed shared widget does NOT yet exist, create it in `utils/common_widgets/` following
the same pattern as existing widgets — then use it everywhere going forward.

---

## COMMON FUNCTIONS — MANDATORY

All shared utility functions live in `utils/helpers/`. NEVER duplicate logic across features.

| Function                                         | Location                              | Purpose                                          |
|--------------------------------------------------|---------------------------------------|--------------------------------------------------|
| `convertToString(dynamic)`                       | `utils/helpers/safe_converters.dart`  | Null-safe JSON string parse                      |
| `convertToInt(dynamic)`                          | `utils/helpers/safe_converters.dart`  | Null-safe JSON int parse                         |
| `convertToDouble(dynamic)`                       | `utils/helpers/safe_converters.dart`  | Null-safe JSON double parse                      |
| `convertToMap(dynamic)`                          | `utils/helpers/safe_converters.dart`  | Null-safe JSON map parse                         |
| `convertToList(dynamic)`                         | `utils/helpers/safe_converters.dart`  | Null-safe JSON list parse                        |
| `convertToBool(dynamic)`                         | `utils/helpers/safe_converters.dart`  | Null-safe JSON bool parse                        |
| `handleResponseError(ApiErrorTypes)`             | `utils/helpers/api_error_handler.dart`| Map `ApiErrorTypes` → `LoaderState` in notifier |
| `showCustomToast({required String message})`     | `utils/helpers/toast_helper.dart`     | Project-standard toast                           |
| `showCustomErrorToast({required String message})`| `utils/helpers/toast_helper.dart`     | Project-standard error toast                     |
| `formatDate(DateTime, {String pattern})`         | `utils/helpers/date_formatter.dart`   | Consistent date formatting                       |
| `formatCalories(num)`                            | `utils/helpers/nutrition_formatter.dart`| Calorie value display                          |
| `getPhoneMaxLength(String countryCode)`          | `utils/helpers/phone_length_helper.dart`| Country-specific phone validation              |
| `debounce(Duration, VoidCallback)`               | `utils/helpers/debounce_helper.dart`  | Prevent rapid repeat calls (search, scroll)      |
| `throttle(Duration, VoidCallback)`               | `utils/helpers/throttle_helper.dart`  | Rate-limit frequent triggers                     |

Rules:
- NEVER duplicate any of the above inline in a feature.
- If a helper does not exist, create it in `utils/helpers/` before referencing it.
- Helpers MUST be pure functions or thin wrappers — zero Riverpod/UI dependencies.

---

## EXTENSIONS & SCREEN UTILS — MANDATORY

### ScreenUtils — Sizing & Spacing

The project uses `flutter_screenutil` (`ScreenUtil`). ALL sizes, radii, font sizes, and spacing
MUST use ScreenUtil suffixes. NEVER use raw `double` literals for layout values.

| Suffix          | Type              | Use for                                      | Example                    |
|-----------------|-------------------|----------------------------------------------|----------------------------|
| `.h`            | `num` → `double`  | Heights, vertical padding/margin             | `48.h`                     |
| `.w`            | `num` → `double`  | Widths, horizontal padding/margin            | `120.w`                    |
| `.r`            | `num` → `double`  | Border radii, icon sizes, square dimensions  | `12.r`                     |
| `.sp`           | `num` → `double`  | Font sizes                                   | `14.sp`                    |
| `.verticalSpace`   | `num` → `SizedBox` | Vertical gap between widgets              | `16.verticalSpace`         |
| `.horizontalSpace` | `num` → `SizedBox` | Horizontal gap between widgets            | `8.horizontalSpace`        |

```dart
// WRONG — raw doubles
SizedBox(height: 16)
SizedBox(width: 8)
Container(height: 48, width: 120)
BorderRadius.circular(12)
TextStyle(fontSize: 14)
Padding(padding: EdgeInsets.all(16))

// CORRECT — ScreenUtils
16.verticalSpace
8.horizontalSpace
Container(height: 48.h, width: 120.w)
BorderRadius.circular(12.r)
TextStyle(fontSize: 14.sp)   // always via FontPalette which uses .sp internally
Padding(padding: EdgeInsets.all(16.r))
EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h)
```

Rules:
- `.h` for anything that scales with **height** (vertical dimensions, top/bottom padding).
- `.w` for anything that scales with **width** (horizontal dimensions, left/right padding).
- `.r` for **radius** and **square** values (icons, avatars, chips) — scales on the shorter axis.
- `.sp` for **font sizes** — already embedded inside `FontPalette` styles; do NOT add `.sp` again when using a palette entry.
- `.verticalSpace` / `.horizontalSpace` for gaps — replaces all raw `SizedBox(height/width: ...)`.
- NEVER mix raw doubles with ScreenUtil values on the same axis.
- NEVER call `ScreenUtil()` directly — always use the suffix extensions.

### Other Extensions

All extensions live in `utils/extensions/`. Import only what is needed.

```dart
// utils/extensions/string_extensions.dart
extension StringX on String {
  bool get isValidEmail => RegExp(r'^[\w.]+@[\w]+\.\w+$').hasMatch(this);
  bool get isNotBlank => trim().isNotEmpty;
  String get capitalizeFirst => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  String get toDisplayDate => DateFormatter.format(this);
}

// utils/extensions/context_extensions.dart
extension ContextX on BuildContext {
  double get screenWidth  => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  ThemeData get theme     => Theme.of(this);
  bool get isDarkMode     => Theme.of(this).brightness == Brightness.dark;
  void hideKeyboard()     => FocusScope.of(this).unfocus();
}

// utils/extensions/list_extensions.dart
extension ListX<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  List<T> safeSublist(int start, [int? end]) =>
      sublist(start.clamp(0, length), (end ?? length).clamp(0, length));
}

// utils/extensions/datetime_extensions.dart
extension DateTimeX on DateTime {
  bool get isToday => DateUtils.isSameDay(this, DateTime.now());
  String get toDisplayString => DateFormatter.format(this);
}
```

Rules:
- NEVER define one-off extension methods inside feature files.
- All extensions must have unit tests in `test/utils/extensions/`.
- Use `context.screenWidth` instead of `MediaQuery.of(context).size.width`.
- Use `MediaQuery.sizeOf(context)` (not `MediaQuery.of(context).size`) to avoid full rebuild on insets change.

---

## STRINGS — NO HARDCODING

NEVER hardcode user-visible strings in widget or notifier files.
ALL strings MUST be defined in `res/constants/string_constants.dart` and referenced via `Strings.`.

```dart
// WRONG
Text("Daily Meals")
showCustomToast(message: "OTP sent successfully")
buttonText: "Next"

// CORRECT
Text(Strings.dailyMeals)
showCustomToast(message: Strings.otpSentSuccess)
buttonText: Strings.next
```

Covers: titles, labels, button text, error messages, toast messages, hint text, empty state copy, dialog text.
If a string is missing from `Strings`, add it there first, then reference it.

---

## COLORS — NO HARDCODING

NEVER use raw `Color(...)`, `Colors.*`, or hex literals in widget files.
ALL colors MUST come from `res/styles/color_palette.dart` via `ColorPalette.`.

```dart
// WRONG
color: Colors.white
color: Color(0xFF0E0F0C)

// CORRECT
color: ColorPalette.white
color: ColorPalette.darkPrimary
```

If a color is missing from `ColorPalette`, add it there first, then use it.

---

## TEXT STYLES — NO HARDCODING

NEVER define inline `TextStyle(...)` in widget files.
ALL text styles MUST come from `res/styles/font_palette.dart` via `FontPalette.`.

```dart
// WRONG
style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0E0F0C))

// CORRECT
style: FontPalette.f0E0F0C_20_700
```

Naming convention: `f{colorHex}_{fontSize}_{fontWeight}`
Example: `f0E0F0C_32_700` = color #0E0F0C, 32sp, weight 700.

If a style is missing from `FontPalette`, add it there first, then use it.

---

## FILE SIZE LIMITS

Enforce strictly. Exceed the limit → extract immediately into sub-files.

| File Type       | Max Lines |
|-----------------|-----------|
| Screen          | 200       |
| Widget file     | 150       |
| Notifier        | 600       |
| Repository      | 400       |
| Model           | 200       |

---

## FORBIDDEN — NEVER GENERATE THESE

| Pattern                              | Replacement                                         |
|--------------------------------------|-----------------------------------------------------|
| `setState()`                         | Riverpod state via notifier                         |
| `print()`                            | `debugPrint()`                                      |
| `dart:developer` `log()`            | `debugPrint()` (except structured auth/token logs)  |
| Force-unwrap `!`                     | Safe null handling (`??`, `?.`, guard clause)       |
| Business logic in `build()`          | Move to notifier                                    |
| API calls from UI                    | Move to repository                                  |
| Monolithic widgets                   | Extract at >150 lines                               |
| `json_serializable`                  | Manual `fromJson` with safe converters              |
| `ChangeNotifier`                     | Riverpod code gen                                   |
| `throw` in repository                | Return `Left(ResponseError(...))`                   |
| Unwrap `results`/`data` in repository | Pass full JSON to `Model.fromJson`; nest `Results`/`Data` models |
| Hardcoded strings in UI              | Use `Strings.` from `string_constants.dart`         |
| Hardcoded colors in UI               | Use `ColorPalette.` from `color_palette.dart`       |
| Inline `TextStyle(...)` in UI        | Use `FontPalette.` from font palette          |
| Raw `Scaffold` in screens            | Use `CommonScaffold`                                |
| Raw `AppBar`                         | Use `CommonAppBar`                                  |
| Raw `ElevatedButton`/`TextButton`    | Use `PrimaryButton`                           |
| Raw `TextField`/`TextFormField`      | Use `CommonTextFormField`                          |
| Raw `RefreshIndicator`               | Use `CommonRefreshIndicator`                        |
| Raw `showModalBottomSheet`           | Use `CommonBottomSheet.show`                        |
| Raw `showDialog` + `AlertDialog`     | Use `CommonDialogBox.show`                          |
| Raw `CircularProgressIndicator`      | Use `CommonLoader`                                  |
| Raw `Image.network`                  | Use `CommonCachedNetworkImage`                      |
| Raw `Text` with overflow handling    | `Text` + `FontPalette` with explicit `maxLines`/`overflow` |
| Raw icon-button in AppBar            | Use `CommonNavBarButton`                            |
| Raw `TextField` for search           | Use `CommonSearchBar`                               |
| Raw `Container` with box decoration  | Use `CommonContainer`                               |
| Raw `double` for height/width           | Use `.h` / `.w` (ScreenUtil)                                |
| Raw `double` for radius/icon size       | Use `.r` (ScreenUtil)                                       |
| Raw `double` for font size              | Use `.sp` via `FontPalette` (already embedded)        |
| `SizedBox(height: x)` / `SizedBox(width: x)` | Use `x.verticalSpace` / `x.horizontalSpace`          |
| `ScreenUtil()` called directly          | Use suffix extensions `.h` `.w` `.r` `.sp`                  |
| `TextEditingController` in widget                | Move to notifier, dispose via `ref.onDispose`               |
| `ScrollController` / `FocusNode` in widget       | Move to notifier, dispose via `ref.onDispose`               |
| `ConsumerStatefulWidget` for non-animation state | Use `StatelessWidget` + inline `Consumer` on hot leaf |
| `ConsumerWidget` when only 1 small child needs state | `StatelessWidget` + inline `Consumer` on that child |
| Multiple `ref.watch` on same provider in one build | Single `.select()` returning `Tuple2`–`Tuple4` |
| `ref.watch(provider.select((s) => s))` on object state | Field-level `.select()` or dedicated derived provider |
| Promoting parent to `ConsumerWidget` for badge/counter | Inline `Consumer` on badge/counter only |
| `Tuple` with >4 items                | Extract into a sub-widget or dedicated state model  |
| `LoaderState` for button `isLoading` | `bool isXLoading` in state                          |
| `bool` for full-screen list/content loading | `LoaderState`                               |
| Importing across feature folders     | Use `utils/`, `res/`, or `data/` only               |
| `ListView(children: buildList())`   | `ListView.builder`                                  |
| `MediaQuery.of(context).size`        | `MediaQuery.sizeOf(context)`                        |
| Undisposed controllers               | Dispose in `dispose()`                              |
| Duplicate helper logic in features   | Create/use function in `utils/helpers/`             |
| One-off extension methods in features| Create in `utils/extensions/`                       |

---

## LOGGING

ALWAYS use `debugPrint`. NEVER use `print()`.
Use `dart:developer` `log()` only for verbose structured output (e.g. device token callbacks).

```dart
debugPrint("🟢 API SUCCESS: ${response.data}");
debugPrint("🔴 API ERROR: ${error.message}");
debugPrint("🟡 STATE CHANGE: $state");
debugPrint("🔵 ACTION: fetchData called");
```

---

## PERFORMANCE & MEMORY PROFILING — MANDATORY

### Widget Build Rules
- Every widget that CAN be `const` MUST be `const`. No exceptions.
- Never run expensive operations inside `build()`. Compute in notifier or cache in state.
- Use `.select()` for ALL `ref.watch` calls — never watch the full state object unless every field is consumed.
- Use inline `Consumer` to isolate frequently-changing values (timers, counters, progress) from stable parent trees.
- Split large widget trees into focused `ConsumerWidget`s to minimize rebuild scope.
- Use `IgnorePointer` to block UI input during loading — never rely on button `isLoading` alone.

### List & Scroll Performance
- ALWAYS use `ListView.builder` / `SliverList.builder` — NEVER `ListView(children: [...])` for dynamic data.
- Set `addAutomaticKeepAlives: false` and `addRepaintBoundaries: false` on lists where items are simple.
- Use `RepaintBoundary` to isolate complex list cells from parent repaints.
- Prefer `SliverList` + `CustomScrollView` for screens mixing headers and lists.

### Image Memory Rules (enforced via CommonCachedNetworkImage)
- Always pass `memCacheWidth` and `memCacheHeight` matching the **rendered pixel size** (not logical).
  Multiply logical size by `devicePixelRatio` if above 2× to cap memory usage.
- Never load full-res images for thumbnails — use `maxWidthDiskCache` / `maxHeightDiskCache`.
- Set `imageBuilder` with a `ClipRRect` rather than wrapping image in a `Container` with decoration.
- For avatar/thumbnail grids: cap `memCacheWidth` at 150px. Violations cause heap spikes.

### Rebuild Checks
- NEVER place `MediaQuery.of(context).size` inside `build()` — use `MediaQuery.sizeOf(context)` (only triggers on size change).
- NEVER place `Theme.of(context)` inside a frequently rebuilt widget — cache via extension `context.theme`.
- NEVER create closures, lists, or maps inside `build()` for widget children — extract as `late final` or compute in notifier.

### Memory Leak Prevention
- `TextEditingController`, `ScrollController`, `FocusNode` MUST live in the notifier and be disposed via `ref.onDispose` — NEVER in widget `dispose()`.
- `AnimationController` MUST be disposed in `StatefulWidget.dispose()` (it is the only exception).
- ALWAYS cancel `StreamSubscription` in `dispose()` or via `ref.onDispose` if registered in notifier.
- NEVER store `BuildContext` across async gaps — check `mounted` before using context post-await.
- Use `AutoDispose` Riverpod providers (`@Riverpod(keepAlive: false)`) by default — only set `keepAlive: true` when explicitly justified.
- NEVER cache large model lists in `keepAlive: true` providers unnecessarily — use pagination.

### Memory Profiling Checklist (run before PR merge)
1. Open Flutter DevTools → Memory tab.
2. Navigate to the screen under review 3 times (forward/back).
3. Force GC and take a snapshot.
4. Verify: no growing `Image` or `_ImageState` instances across navigations.
5. Verify: no orphaned `StreamSubscription` or `AnimationController` in the snapshot.
6. Verify: retained size of the screen's provider is released after `autoDispose`.
7. Verify: list items with images show `memCacheWidth`-capped bitmaps in the Image layer.
8. If any heap metric grows monotonically across 3 navigations → treat as a blocker.

### Forbidden Performance Patterns
| Pattern                                          | Fix                                                          |
|--------------------------------------------------|--------------------------------------------------------------|
| `ListView(children: buildList())`               | `ListView.builder`                                           |
| `Image.network(url)`                             | `CommonCachedNetworkImage`                                   |
| `MediaQuery.of(context).size` in `build()`      | `MediaQuery.sizeOf(context)`                                 |
| Creating a closure inside `build()` for onTap   | Extract to a method or `late final` callback                 |
| `keepAlive: true` without justification          | `keepAlive: false` (default)                                 |
| Not disposing controllers                        | Use `ref.onDispose` in notifier; `dispose()` only for `AnimationController` |
| Full-res images in thumbnails                    | Set `memCacheWidth`/`memCacheHeight` in `CommonCachedNetworkImage` |
| `ref.watch(provider)` — full state              | `.select()` for each field                                   |
| `ConsumerWidget` for badge/counter/text only    | `StatelessWidget` + inline `Consumer` on hot leaf            |

---

## NAMING CONVENTIONS

| Construct          | Convention   | Example                            |
|--------------------|--------------|------------------------------------|
| Classes            | PascalCase   | `HomeNotifier`, `HomeState`        |
| Files              | snake_case   | `home_notifier.dart`               |
| Variables/params   | camelCase    | `loaderState`, `featureData`       |
| Notifier provider  | camelCase    | `homeNotifierProvider`             |
| Repo provider      | camelCase    | `homeRepositoryProvider`           |
| Private fields     | `_camelCase` | `_client`, `_authRepo`             |
| String constants   | camelCase    | `Strings.dailyMeals`               |
| Color constants    | camelCase    | `ColorPalette.white`               |
| Font styles        | custom       | `FontPalette.f0E0F0C_20_700` |

---

## CODEX TASK EXECUTION RULES

When assigned a task:

1. **Read first** — scan the feature folder and shared resource files before writing anything.
2. **Check shared resources** — verify `string_constants.dart`, `color_palette.dart`, and font palette before using any value.
3. **Full slice by default** — generate all layers (model → state → repo → notifier → view) unless told otherwise.
4. **Show structure** — output the folder tree at the top of every feature generation.
5. **No partial stubs** — never leave `// TODO` or empty method bodies in generated code.
6. **Run build_runner** — after generating Freezed or Riverpod files, always run:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
7. **Verify imports** — all `part` directives and imports must be correct and complete.
8. **One file per section** — label each file with its full path as the first line comment.
9. **Add missing constants first** — if a string, color, or style is missing, add it to the correct shared file before referencing it.
10. **Granular rebuild check** — before finishing UI work:
    - No `ref.watch(fooNotifierProvider)` without `.select()` in views (primitive providers like `mainShellNotifierProvider` are OK).
    - Prefer `Tuple2`–`Tuple4` over multiple watches on the same provider.
    - Use inline `Consumer` on hot leaves; demote unnecessary `ConsumerWidget`s to `StatelessWidget`.

---

## OUTPUT FORMAT

Every generated file MUST start with its full path as a comment:

```dart
// lib/src/feature_name/notifier/feature_notifier.dart
```

When generating a full feature, output files in this order:
1. `model/`
2. `state/`
3. `repo/`
4. `notifier/`
5. `view/screen.dart`
6. `view/widget/` (if needed)
7. Additions to `res/constants/string_constants.dart`
8. Additions to `res/styles/color_palette.dart`
9. Additions to `res/styles/font_palette.dart`
