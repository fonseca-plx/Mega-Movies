import 'package:flutter/material.dart';
import 'package:mega_movies/data/repositories/movie_repository.dart';
import 'package:mega_movies/router.dart';
import 'package:mega_movies/ui/core/app_theme.dart';
import 'package:mega_movies/ui/features/explore/view_models/explore_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MegaMoviesApp());
}

class MegaMoviesApp extends StatelessWidget {
  const MegaMoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExploreViewModel(MovieRepository()),
      child: MaterialApp.router(
        title: 'Mega Movies',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: appRouter,
      ),
    );
  }
}
