import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mega_movies/data/models/tmdb_movie_details.dart';
import 'package:mega_movies/data/services/tmdb_movie_service.dart';
import 'package:mega_movies/ui/core/app_colors.dart';
import 'package:mega_movies/ui/core/app_text_styles.dart';
import 'package:mega_movies/ui/core/widgets/app_button.dart';
import 'package:mega_movies/ui/core/widgets/glass_chip.dart';

const double _kMaxWidth = 1200;

/// Full-screen details page for a TMDB movie.
///
/// Fetches movie data from the TMDB API using the numeric [tmdbId] parameter.
class TmdbMovieDetailsScreen extends StatefulWidget {
  const TmdbMovieDetailsScreen({super.key, required this.tmdbId});

  final int tmdbId;

  @override
  State<TmdbMovieDetailsScreen> createState() => _TmdbMovieDetailsScreenState();
}

class _TmdbMovieDetailsScreenState extends State<TmdbMovieDetailsScreen> {
  final _service = TmdbMovieService();

  TmdbMovieDetails? _details;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      final details = await _service.getMovieDetails(widget.tmdbId);
      if (mounted) setState(() => _details = details);
    } on TmdbException catch (e) {
      if (mounted) {
        setState(
          () => _errorMessage = 'Erro ao carregar detalhes (${e.statusCode}).',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _errorMessage = 'Não foi possível conectar ao servidor.',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const _LoadingScaffold();
    if (_errorMessage != null) return _ErrorScaffold(message: _errorMessage!);
    return _DetailsView(movie: _details!);
  }
}

// ---------------------------------------------------------------------------
// Loading / error scaffolds
// ---------------------------------------------------------------------------

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.gold, strokeWidth: 2),
      ),
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GlassIconButton(
                icon: Icons.arrow_back,
                onTap: () => context.pop(),
              ),
              const Spacer(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.onSurfaceVariant,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main details view
// ---------------------------------------------------------------------------

class _DetailsView extends StatelessWidget {
  const _DetailsView({required this.movie});

  final TmdbMovieDetails movie;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final heroHeight = (size.height * 0.55).clamp(300.0, 620.0);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _Hero(movie: movie, height: heroHeight),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _kMaxWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _ActionButtons(movie: movie),
                      const SizedBox(height: 32),
                      if (movie.tagline != null &&
                          movie.tagline!.isNotEmpty) ...[
                        Text(
                          '"${movie.tagline}"',
                          style: AppTextStyles.bodyLg.copyWith(
                            color: AppColors.tertiary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      Text('Sinopse', style: AppTextStyles.headlineMd),
                      const SizedBox(height: 12),
                      Text(
                        movie.overview.isNotEmpty
                            ? movie.overview
                            : 'Sinopse não disponível.',
                        style: AppTextStyles.bodyLg.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 96),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero section (backdrop + metadata)
// ---------------------------------------------------------------------------

class _Hero extends StatelessWidget {
  const _Hero({required this.movie, required this.height});

  final TmdbMovieDetails movie;
  final double height;

  @override
  Widget build(BuildContext context) {
    final backdropUrl = movie.backdropUrl();

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Backdrop
          if (backdropUrl != null)
            Image.network(
              backdropUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: AppColors.graphite),
            )
          else
            Container(color: AppColors.graphite),
          // 15% safe-zone gradient (DESIGN.md requirement)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.4, 1.0],
                colors: [
                  Colors.transparent,
                  Color(0x99121317),
                  AppColors.surface,
                ],
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _GlassIconButton(
                      icon: Icons.arrow_back,
                      onTap: () => context.pop(),
                    ),
                    _GlassIconButton(icon: Icons.more_vert, onTap: () {}),
                  ],
                ),
              ),
            ),
          ),
          // Metadata pinned to bottom
          Positioned(
            bottom: 0,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (movie.genres.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: movie.genres
                        .map((g) => GlassChip(label: g))
                        .toList(),
                  ),
                const SizedBox(height: 8),
                Text(movie.title, style: AppTextStyles.displayLg),
                const SizedBox(height: 8),
                _MetadataRow(movie: movie),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.movie});

  final TmdbMovieDetails movie;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 0,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (movie.year != null)
          Text(
            '${movie.year}',
            style: AppTextStyles.labelLg.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        if (movie.runtime > 0) ...[
          _Dot(),
          Text(
            movie.formattedRuntime,
            style: AppTextStyles.labelLg.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
        _Dot(),
        const Icon(Icons.star, color: AppColors.tertiary, size: 16),
        const SizedBox(width: 4),
        Text(
          movie.voteAverage.toStringAsFixed(1),
          style: AppTextStyles.labelLg.copyWith(color: AppColors.tertiary),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.outlineVariant,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Action buttons
// ---------------------------------------------------------------------------

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.movie});

  final TmdbMovieDetails movie;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    if (isWide) {
      return Row(
        children: [
          Expanded(
            child: PrimaryButton(
              label: 'Assistir Agora',
              icon: Icons.play_arrow,
              onPressed: () {},
              isFullWidth: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SecondaryButton(
              label: 'Adicionar à Lista',
              icon: Icons.add,
              onPressed: () {},
              isFullWidth: true,
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(
          label: 'Assistir Agora',
          icon: Icons.play_arrow,
          onPressed: () {},
          isFullWidth: true,
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          label: 'Adicionar à Lista',
          icon: Icons.add,
          onPressed: () {},
          isFullWidth: true,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Glass icon button (identical to MovieDetailsScreen)
// ---------------------------------------------------------------------------

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.glassPanel,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Icon(icon, color: AppColors.onSurface, size: 20),
          ),
        ),
      ),
    );
  }
}
