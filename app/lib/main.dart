import 'package:flutter/material.dart';
import 'package:mega_movies/data/repositories/auth_repository.dart';
import 'package:mega_movies/router.dart';
import 'package:mega_movies/ui/core/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authRepository = AuthRepository();
  await authRepository.loadSession();

  runApp(MegaMoviesApp(authRepository: authRepository));
}

class MegaMoviesApp extends StatelessWidget {
  const MegaMoviesApp({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mega Movies',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: createRouter(authRepository),
    );
  }
}
