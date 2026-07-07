import 'package:go_router/go_router.dart';
import 'package:mega_movies/ui/core/widgets/app_shell.dart';
import 'package:mega_movies/ui/features/explore/views/explore_screen.dart';
import 'package:mega_movies/ui/features/home/views/home_screen.dart';
import 'package:mega_movies/ui/features/movie_details/views/movie_details_screen.dart';
import 'package:mega_movies/ui/features/profile/views/profile_screen.dart';
import 'package:mega_movies/ui/features/tmdb_movie_details/views/tmdb_movie_details_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
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
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    // Full-screen movie detail for local mock movies
    GoRoute(
      path: '/movie/:id',
      builder: (context, state) =>
          MovieDetailsScreen(movieId: state.pathParameters['id']!),
    ),
    // Full-screen movie detail for TMDB movies
    GoRoute(
      path: '/tmdb/:id',
      builder: (context, state) => TmdbMovieDetailsScreen(
        tmdbId: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);
