import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mega_movies/data/models/movie.dart';
import 'package:mega_movies/data/repositories/movie_repository.dart';
import 'package:mega_movies/ui/core/app_colors.dart';
import 'package:mega_movies/ui/core/app_text_styles.dart';
import 'package:mega_movies/ui/core/widgets/app_button.dart';
import 'package:mega_movies/ui/core/widgets/glass_chip.dart';
import 'package:mega_movies/ui/core/widgets/movie_card.dart';

const double _kMaxWidth = 1200;

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, required this.movieId});
  final String movieId;

  @override
  Widget build(BuildContext context) {
    final movie = MovieRepository().getById(movieId);
    if (movie == null) {
      return const Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(child: Text('Movie not found')),
      );
    }
    return _MovieDetailsView(movie: movie);
  }
}

class _MovieDetailsView extends StatelessWidget {
  const _MovieDetailsView({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final heroHeight = (size.height * 0.55).clamp(300.0, 620.0);
    final similar = MovieRepository().similarTo;

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
                      // Action buttons
                      _ActionButtons(movie: movie),
                      const SizedBox(height: 32),
                      // Synopsis
                      Text('Synopsis', style: AppTextStyles.headlineMd),
                      const SizedBox(height: 12),
                      Text(
                        movie.synopsis,
                        style: AppTextStyles.bodyLg.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Cast
                      if (movie.cast.isNotEmpty) ...[
                        Text('Cast', style: AppTextStyles.headlineMd),
                        const SizedBox(height: 16),
                        _CastRow(cast: movie.cast),
                        const SizedBox(height: 48),
                      ],
                      // Similar
                      Text('Similar Classics', style: AppTextStyles.headlineMd),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 230,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: similar.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 16),
                          itemBuilder: (context, i) => MovieCard(
                            movie: similar[i],
                            onTap: () =>
                                context.push('/movie/${similar[i].id}'),
                          ),
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

class _Hero extends StatelessWidget {
  const _Hero({required this.movie, required this.height});
  final Movie movie;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            movie.backdropUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: AppColors.graphite),
          ),
          // Safe zone gradient
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
          // Back & more buttons
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
                Wrap(
                  spacing: 8,
                  children: movie.genres
                      .map((g) => GlassChip(label: g))
                      .toList(),
                ),
                const SizedBox(height: 8),
                Text(movie.title, style: AppTextStyles.displayLg),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${movie.year}',
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    _Dot(),
                    Text(
                      movie.ageRating,
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    _Dot(),
                    Text(
                      movie.formattedDuration,
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    _Dot(),
                    const Icon(Icons.star, color: AppColors.tertiary, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      movie.rating.toStringAsFixed(1),
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
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

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    if (isWide) {
      return Row(
        children: [
          Expanded(
            child: PrimaryButton(
              label: 'Watch Now',
              icon: Icons.play_arrow,
              onPressed: () {},
              isFullWidth: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SecondaryButton(
              label: 'Add to Watchlist',
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
          label: 'Watch Now',
          icon: Icons.play_arrow,
          onPressed: () {},
          isFullWidth: true,
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          label: 'Add to Watchlist',
          icon: Icons.add,
          onPressed: () {},
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _CastRow extends StatelessWidget {
  const _CastRow({required this.cast});
  final List<CastMember> cast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final member = cast[i];
          return SizedBox(
            width: 90,
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      member.photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Container(color: AppColors.graphite),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  member.name,
                  style: AppTextStyles.labelSm,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  member.character,
                  style: AppTextStyles.labelSm.copyWith(
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
