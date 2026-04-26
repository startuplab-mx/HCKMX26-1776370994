import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';

/// Maps the four main bottom-nav tabs to their canonical routes.
///
/// Tab order must match [AppBottomNav._items]:
///   0 → Aprender  → /home-kids
///   1 → Duki      → /ask-duki
///   2 → Reportar  → /report-form
///   3 → Recompensas → /achievements
abstract final class NavHelper {
  /// Ordered list of routes — index == tab position.
  static const List<String> _tabRoutes = [
    AppRoutes.homeKids,
    AppRoutes.askDuki,
    AppRoutes.reportForm,
    AppRoutes.achievements,
  ];

  /// Returns the tab index for [location], or -1 if not a main-nav route.
  static int indexForLocation(String location) {
    for (var i = 0; i < _tabRoutes.length; i++) {
      if (location == _tabRoutes[i] ||
          location.startsWith('${_tabRoutes[i]}/')) {
        return i;
      }
    }
    return -1;
  }

  /// Returns the canonical route for [index].
  static String routeForIndex(int index) => _tabRoutes[index];

  /// Navigates to the tab at [index] unless it is already active.
  /// Uses [context.go] so no stack is duplicated.
  static void goToTab(BuildContext context, int index) {
    final current = GoRouterState.of(context).uri.toString();
    final target = routeForIndex(index);
    if (current == target) return; // already there — no-op
    context.go(target);
  }
}
