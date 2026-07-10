import 'package:flutter/material.dart';
import 'package:mega_movies/data/local/app_database.dart';
import 'package:mega_movies/data/repositories/auth_repository.dart';
import 'package:mega_movies/data/repositories/watchlist_repository.dart';
import 'package:mega_movies/router.dart';
import 'package:mega_movies/ui/core/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final authRepository = AuthRepository();
  final watchlistRepository = WatchlistRepository(db: db);

  await authRepository.loadSession();

  // Keep the watchlist in sync with the auth session:
  // - On login/restore: load the new user's watchlist
  // - On logout (currentUser == null): clear the in-memory state
  authRepository.addListener(() {
    final user = authRepository.currentUser;
    if (user != null) {
      watchlistRepository.load(user.id);
    } else {
      watchlistRepository.clear();
    }
  });

  // Pre-load on startup if a session was already restored.
  final user = authRepository.currentUser;
  if (user != null) {
    await watchlistRepository.load(user.id);
  }

  runApp(
    MegaMoviesApp(
      authRepository: authRepository,
      watchlistRepository: watchlistRepository,
    ),
  );
}

class MegaMoviesApp extends StatelessWidget {
  const MegaMoviesApp({
    super.key,
    required this.authRepository,
    required this.watchlistRepository,
  });

  final AuthRepository authRepository;
  final WatchlistRepository watchlistRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mega Movies',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: createRouter(
        authRepository: authRepository,
        watchlistRepository: watchlistRepository,
      ),
    );
  }
}
