import 'package:flutter/material.dart';
import 'package:mega_movies/data/repositories/auth_repository.dart';

/// Makes [AuthRepository] available to any widget in the subtree
/// without requiring explicit prop-drilling through every screen.
///
/// Usage: `AuthScope.of(context)` — returns null if no scope is present.
class AuthScope extends InheritedWidget {
  const AuthScope({super.key, required this.repository, required super.child});

  final AuthRepository repository;

  /// Returns the nearest [AuthRepository] in the widget tree, or null.
  static AuthRepository? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthScope>()?.repository;
  }

  @override
  bool updateShouldNotify(AuthScope oldWidget) =>
      repository != oldWidget.repository;
}
