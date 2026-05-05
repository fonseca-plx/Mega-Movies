import 'package:flutter/material.dart';
import 'package:mega_movies/router.dart';
import 'package:mega_movies/ui/core/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MegaMoviesApp());
}

class MegaMoviesApp extends StatelessWidget {
  const MegaMoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mega Movies',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
