import 'package:flutter/material.dart';
import 'package:mega_movies/data/repositories/watchlist_repository.dart';

/// Makes [WatchlistRepository] available to any widget in the subtree
/// without prop-drilling through every screen.
///
/// Usage: `WatchlistScope.of(context)` — returns null if no scope is present.
class WatchlistScope extends InheritedWidget {
  const WatchlistScope({
    super.key,
    required this.repository,
    required super.child,
  });

  final WatchlistRepository repository;

  /// Returns the nearest [WatchlistRepository] in the widget tree, or null.
  static WatchlistRepository? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<WatchlistScope>()?.repository;

  @override
  bool updateShouldNotify(WatchlistScope oldWidget) =>
      repository != oldWidget.repository;
}
