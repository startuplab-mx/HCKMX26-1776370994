import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapts any [Stream] into a [ChangeNotifier] that [GoRouter] can use as
/// `refreshListenable`.
///
/// Every time the stream emits a value, listeners are notified and GoRouter
/// re-evaluates its `redirect` callback.  Works with Supabase's
/// `onAuthStateChange` stream.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
