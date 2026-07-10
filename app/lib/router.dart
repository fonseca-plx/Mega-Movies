import 'package:go_router/go_router.dart';
import 'package:mega_movies/data/repositories/auth_repository.dart';
import 'package:mega_movies/ui/core/widgets/app_shell.dart';
import 'package:mega_movies/ui/features/auth/views/login_screen.dart';
import 'package:mega_movies/ui/features/auth/views/register_screen.dart';
import 'package:mega_movies/ui/features/explore/views/explore_screen.dart';
import 'package:mega_movies/ui/features/home/views/home_screen.dart';
import 'package:mega_movies/ui/features/movie_details/views/movie_details_screen.dart';
import 'package:mega_movies/ui/features/profile/views/profile_screen.dart';
import 'package:mega_movies/ui/features/tmdb_movie_details/views/tmdb_movie_details_screen.dart';

/// Creates the application router, wiring the [authRepository] into guards
/// and screen constructors that require it.
GoRouter createRouter(AuthRepository authRepository) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authRepository,
    routes: [
      // -----------------------------------------------------------------------
      // Main shell — always accessible
      // -----------------------------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(
          navigationShell: navigationShell,
          authRepository: authRepository,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                redirect: (context, state) {
                  if (!authRepository.isAuthenticated) {
                    return '/login?from=/profile';
                  }
                  return null;
                },
                builder: (context, state) =>
                    ProfileScreen(authRepository: authRepository),
              ),
            ],
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // Auth routes — outside the shell
      // -----------------------------------------------------------------------
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final from = state.uri.queryParameters['from'];
          return LoginScreen(authRepository: authRepository, from: from);
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) =>
            RegisterScreen(authRepository: authRepository),
      ),

      // -----------------------------------------------------------------------
      // Full-screen movie details
      // -----------------------------------------------------------------------
      GoRoute(
        path: '/movie/:id',
        builder: (context, state) =>
            MovieDetailsScreen(movieId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tmdb/:id',
        builder: (context, state) => TmdbMovieDetailsScreen(
          tmdbId: int.parse(state.pathParameters['id']!),
        ),
      ),
    ],
  );
}
