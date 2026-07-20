# Light-Mode Card Borders Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make all standard cards and the floating bottom navigation visibly distinct from the white light-mode background.

**Architecture:** Strengthen the existing semantic light-mode `cardBorder` token and remove opacity reduction at shared and direct standard-card call sites. Components that already consume `cardBorder` at full opacity inherit the improvement automatically; dark mode and semantic status borders remain unchanged.

**Tech Stack:** Flutter, Dart, Material `ThemeExtension`, `flutter_screenutil`, `smooth_corner`, Flutter widget tests.

## Global Constraints

- Light-mode `cardBorder` must be exactly `#D9DEE3`.
- Standard borders use the existing responsive 1 px width at full opacity.
- Dark-mode `cardBorder` remains exactly `#2F3844`.
- Status, warning, glass, selected-chip, and other component-specific borders remain unchanged.
- Do not add shadows or change spacing, radii, surfaces, or typography.
- Do not create a git commit unless the user explicitly requests one.

---

### Task 1: Strengthen the semantic border and standard card rendering

**Files:**
- Create: `test/light_mode_card_border_test.dart`
- Modify: `lib/res/styles/color_palette.dart:141-145`
- Modify: `lib/utils/common_widgets/common_container.dart:52-57`
- Modify: `lib/src/orders/view/widget/order_tile.dart:33-38`
- Modify: `lib/src/orders/view/widget/orders_shimmer_widget.dart:25-31`
- Modify: `lib/src/main/view/widget/bottom_navigation_section.dart:43-49`

**Interfaces:**
- Consumes: `AppColors.light.cardBorder`, `AppColors.dark.cardBorder`, and `CommonContainer`.
- Produces: a full-opacity `Color(0xFFD9DEE3)` standard border in light mode while preserving `Color(0xFF2F3844)` in dark mode.

- [ ] **Step 1: Write the failing semantic and shared-widget tests**

Create `test/light_mode_card_border_test.dart`:

```dart
// test/light_mode_card_border_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:tsuite/res/styles/color_palette.dart';
import 'package:tsuite/utils/common_widgets/common_container.dart';

void main() {
  test('light mode uses the stronger neutral card border', () {
    expect(AppColors.light.cardBorder, const Color(0xFFD9DEE3));
    expect(AppColors.dark.cardBorder, const Color(0xFF2F3844));
  });

  testWidgets('CommonContainer renders cardBorder at full opacity', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, child) => MaterialApp(
          theme: ThemeData(
            extensions: const <ThemeExtension<dynamic>>[AppColors.light],
          ),
          home: child,
        ),
        child: const CommonContainer(child: SizedBox()),
      ),
    );

    final container = tester.widget<SmoothContainer>(
      find.byType(SmoothContainer),
    );

    expect(container.side.color, AppColors.light.cardBorder);
    expect(container.side.color.a, 1);
  });
}
```

- [ ] **Step 2: Run the test and verify it fails**

Run:

```bash
flutter test test/light_mode_card_border_test.dart
```

Expected: FAIL because the light token is still `#EDEFF1` and `CommonContainer` reduces its alpha to 0.6.

- [ ] **Step 3: Strengthen the light-mode token**

In `lib/res/styles/color_palette.dart`, update the clean product-card token:

```dart
static const productCardBorder = Color(0xFFD9DEE3);
```

Keep `AppColors.light.cardBorder` mapped to `ColorPalette.productCardBorder` and leave `AppColors.dark.cardBorder` unchanged.

- [ ] **Step 4: Remove opacity reduction from standard borders**

In `lib/utils/common_widgets/common_container.dart`, use:

```dart
BorderSide(
  color: context.appColors.cardBorder,
  width: 1.w,
),
```

Apply the same full-opacity `colors.cardBorder` expression to:

```dart
// lib/src/orders/view/widget/order_tile.dart
side: BorderSide(
  color: colors.cardBorder,
  width: 1.w,
),
```

```dart
// lib/src/orders/view/widget/orders_shimmer_widget.dart
side: BorderSide(
  color: colors.cardBorder,
  width: 1.w,
),
```

```dart
// lib/src/main/view/widget/bottom_navigation_section.dart
border: Border.all(
  color: colors.cardBorder,
  width: 1.w,
),
```

- [ ] **Step 5: Format and run focused verification**

Run:

```bash
dart format lib/res/styles/color_palette.dart lib/utils/common_widgets/common_container.dart lib/src/orders/view/widget/order_tile.dart lib/src/orders/view/widget/orders_shimmer_widget.dart lib/src/main/view/widget/bottom_navigation_section.dart test/light_mode_card_border_test.dart
flutter test test/light_mode_card_border_test.dart
flutter analyze lib/res/styles/color_palette.dart lib/utils/common_widgets/common_container.dart lib/src/orders/view/widget/order_tile.dart lib/src/orders/view/widget/orders_shimmer_widget.dart lib/src/main/view/widget/bottom_navigation_section.dart test/light_mode_card_border_test.dart
```

Expected: formatting completes without changes afterward, both tests pass, and analysis reports no issues.

- [ ] **Step 6: Verify scope and visual behavior**

Run:

```bash
rg "cardBorder\\.withValues" lib
git diff --check
```

Expected: no remaining opacity reduction for standard `cardBorder` usage except any deliberately component-specific treatment documented in the design spec; `git diff --check` prints no output.

Visually inspect Home, Orders, Cart, and Profile in light mode and confirm:

- white cards have a restrained but visible neutral outline;
- the floating bottom navigation is separated from the page background;
- dark mode is visually unchanged;
- status and glass borders retain their prior colors.
