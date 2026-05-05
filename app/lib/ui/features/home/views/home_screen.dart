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
const double _kBreakpoint = 600;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MovieRepository();
    final featured = repo.featuredMovie;
    final acclaimed = repo.criticallyAcclaimed;
    final all = repo.getAll();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // Transparent overlap so content scrolls under the glass header
          const SliverToBoxAdapter(child: _AppHeader()),
          SliverToBoxAdapter(child: _HeroSection(movie: featured)),
          SliverToBoxAdapter(
            child: _SectionContainer(
              title: 'Critically Acclaimed',
              child: _HorizontalMovieList(movies: acclaimed),
            ),
          ),
          SliverToBoxAdapter(
            child: _SectionContainer(
              title: 'Curated Noir Collection',
              subtitle: 'Shadows, deceit, and moral ambiguity.',
              child: _BentoGrid(movies: all),
            ),
          ),
          // Bottom padding for nav bar
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Glass app header
// ---------------------------------------------------------------------------

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= _kBreakpoint;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: Colors.black.withAlpha(204),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Text(
                    'MEGA MOVIES',
                    style: AppTextStyles.labelLg.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.gold,
                      letterSpacing: 3,
                    ),
                  ),
                  const Spacer(),
                  if (isWide) ...[
                    _HeaderLink(label: 'Home', isActive: true),
                    const SizedBox(width: 32),
                    _HeaderLink(label: 'Explore'),
                    const SizedBox(width: 32),
                    _HeaderLink(label: 'Watchlist'),
                    const SizedBox(width: 24),
                  ],
                  const _AvatarButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderLink extends StatelessWidget {
  const _HeaderLink({required this.label, this.isActive = false});
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.labelLg.copyWith(
        color: isActive
            ? AppColors.metallicBlueLight
            : AppColors.onSurfaceVariant,
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  const _AvatarButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.outlineVariant),
        color: AppColors.surfaceContainerHigh,
      ),
      child: const Icon(Icons.person, size: 18, color: AppColors.secondary),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero section
// ---------------------------------------------------------------------------

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final heroHeight = size.width >= _kBreakpoint
        ? 500.0
        : (size.height * 0.55).clamp(300.0, 500.0);

    return SizedBox(
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Backdrop image
          Image.network(
            movie.backdropUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: AppColors.graphite),
          ),
          // Safe zone gradient (15% from bottom per DESIGN.md)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.15, 0.7, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xCC121317),
                  AppColors.surface,
                ],
              ),
            ),
          ),
          // Content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _kMaxWidth),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const GlassChip(
                        label: '★  Classic of the Week',
                        isFeatured: true,
                      ),
                      const SizedBox(height: 12),
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
                          const _Dot(),
                          Text(
                            movie.formattedDuration,
                            style: AppTextStyles.labelLg.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const _Dot(),
                          Text(
                            movie.genres.join(', '),
                            style: AppTextStyles.labelLg.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        movie.synopsis,
                        style: AppTextStyles.bodyLg.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          PrimaryButton(
                            label: 'Play Now',
                            icon: Icons.play_arrow,
                            onPressed: () => context.push('/movie/${movie.id}'),
                          ),
                          SecondaryButton(
                            label: 'Watchlist',
                            icon: Icons.add,
                            onPressed: () {},
                          ),
                        ],
                      ),
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

class _Dot extends StatelessWidget {
  const _Dot();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.outline,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Section container
// ---------------------------------------------------------------------------

class _SectionContainer extends StatelessWidget {
  const _SectionContainer({
    required this.title,
    required this.child,
    this.subtitle,
  });
  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _kMaxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.headlineLg),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Horizontal movie list
// ---------------------------------------------------------------------------

class _HorizontalMovieList extends StatelessWidget {
  const _HorizontalMovieList({required this.movies});
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, i) => MovieCard(
          movie: movies[i],
          onTap: () => context.push('/movie/${movies[i].id}'),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bento grid
// ---------------------------------------------------------------------------

class _BentoGrid extends StatelessWidget {
  const _BentoGrid({required this.movies});
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _kBreakpoint;

    if (!isWide) {
      // Narrow: single featured card + small row
      return Column(
        children: [
          _BentoCard(movie: movies[0], height: 260),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _BentoCard(movie: movies[1], height: 160)),
              const SizedBox(width: 16),
              Expanded(child: _BentoCard(movie: movies[2], height: 160)),
            ],
          ),
        ],
      );
    }

    return SizedBox(
      height: 400,
      child: Row(
        children: [
          Expanded(flex: 2, child: _BentoCard(movie: movies[0], height: 400)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _BentoCard(movie: movies[1], height: 192)),
                const SizedBox(height: 16),
                Expanded(child: _BentoCard(movie: movies[2], height: 192)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoCard extends StatefulWidget {
  const _BentoCard({required this.movie, required this.height});
  final Movie movie;
  final double height;

  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push('/movie/${widget.movie.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: widget.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: _hovered ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  child: Image.network(
                    widget.movie.backdropUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        Container(color: AppColors.graphite),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xE6000000)],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Text(
                    widget.movie.title,
                    style: AppTextStyles.headlineMd,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Inner border per DESIGN.md Level 1
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
