import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mega_movies/data/models/tmdb_search_result.dart';
import 'package:mega_movies/data/repositories/movie_repository.dart';
import 'package:mega_movies/ui/core/app_colors.dart';
import 'package:mega_movies/ui/core/app_text_styles.dart';
import 'package:mega_movies/ui/core/widgets/app_button.dart';
import 'package:mega_movies/ui/core/widgets/glass_chip.dart';
import 'package:mega_movies/ui/features/home/view_models/home_view_model.dart';

const double _kMaxWidth = 1200;
const double _kBreakpoint = 600;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel(repository: MovieRepository());
    _viewModel.addListener(_rebuild);
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel
      ..removeListener(_rebuild)
      ..dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _AppHeader()),
          SliverToBoxAdapter(child: _buildHero()),
          SliverToBoxAdapter(child: _buildAcclaimed()),
          SliverToBoxAdapter(child: _buildNoirGrid()),
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
    );
  }

  Widget _buildHero() {
    if (_viewModel.isLoading || _viewModel.featuredMovie == null) {
      return const _HeroSkeleton();
    }
    return _HeroSection(movie: _viewModel.featuredMovie!);
  }

  Widget _buildAcclaimed() {
    return _SectionContainer(
      title: 'Critically Acclaimed',
      child: _viewModel.isLoading
          ? const _HorizontalSkeletonList()
          : _HorizontalMovieList(movies: _viewModel.acclaimed),
    );
  }

  Widget _buildNoirGrid() {
    return _SectionContainer(
      title: 'Curated Noir Collection',
      subtitle: 'Shadows, deceit, and moral ambiguity.',
      child: _viewModel.isLoading
          ? const _BentoSkeleton()
          : _BentoGrid(movies: _viewModel.noirGrid),
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
    final isWide = MediaQuery.sizeOf(context).width >= _kBreakpoint;

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
                    _HeaderNavLink(
                      label: 'Home',
                      isActive: true,
                      onTap: () => context.go('/'),
                    ),
                    const SizedBox(width: 32),
                    _HeaderNavLink(
                      label: 'Explore',
                      onTap: () => context.go('/explore'),
                    ),
                    const SizedBox(width: 32),
                    _HeaderNavLink(
                      label: 'Watchlist',
                      onTap: () => context.go('/profile'),
                    ),
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

class _HeaderNavLink extends StatefulWidget {
  const _HeaderNavLink({
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_HeaderNavLink> createState() => _HeaderNavLinkState();
}

class _HeaderNavLinkState extends State<_HeaderNavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppTextStyles.labelLg.copyWith(
            color: widget.isActive
                ? AppColors.metallicBlueLight
                : _hovered
                ? AppColors.onSurface
                : AppColors.onSurfaceVariant,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  const _AvatarButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/profile'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outlineVariant),
            color: AppColors.surfaceContainerHigh,
          ),
          child: const Icon(Icons.person, size: 18, color: AppColors.secondary),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hero section (real TMDB movie)
// ---------------------------------------------------------------------------

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.movie});

  final TmdbSearchResult movie;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final heroHeight = size.width >= _kBreakpoint
        ? 500.0
        : (size.height * 0.55).clamp(300.0, 500.0);
    final backdropUrl = movie.backdropUrl('w1280');

    return SizedBox(
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Backdrop image
          backdropUrl != null
              ? Image.network(
                  backdropUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Container(color: AppColors.graphite),
                )
              : Container(color: AppColors.graphite),
          // Gradient overlay
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
                          if (movie.year != null)
                            Text(
                              '${movie.year}',
                              style: AppTextStyles.labelLg.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          const _Dot(),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppColors.tertiary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: AppTextStyles.labelLg.copyWith(
                                  color: AppColors.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          PrimaryButton(
                            label: 'Play Now',
                            icon: Icons.play_arrow,
                            onPressed: () => context.push('/tmdb/${movie.id}'),
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
// Horizontal movie list (real data)
// ---------------------------------------------------------------------------

class _HorizontalMovieList extends StatelessWidget {
  const _HorizontalMovieList({required this.movies});

  final List<TmdbSearchResult> movies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, i) => _TmdbMovieCard(movie: movies[i]),
      ),
    );
  }
}

/// Compact poster card used in horizontal carousels.
class _TmdbMovieCard extends StatefulWidget {
  const _TmdbMovieCard({required this.movie});

  final TmdbSearchResult movie;

  @override
  State<_TmdbMovieCard> createState() => _TmdbMovieCardState();
}

class _TmdbMovieCardState extends State<_TmdbMovieCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posterUrl = widget.movie.posterUrl('w342');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) => _ctrl.reverse(),
      child: GestureDetector(
        onTap: () => context.push('/tmdb/${widget.movie.id}'),
        child: SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: _ctrl,
                builder: (context, child) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withAlpha(
                          (_ctrl.value * 77).toInt(),
                        ),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: child,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 180,
                    width: 130,
                    child: posterUrl != null
                        ? Image.network(
                            posterUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _PosterFallback(title: widget.movie.title),
                          )
                        : _PosterFallback(title: widget.movie.title),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.movie.title,
                style: AppTextStyles.labelLg,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.movie.year != null)
                Text(
                  '${widget.movie.year}',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.graphite,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            title,
            style: AppTextStyles.labelSm,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bento grid (real data)
// ---------------------------------------------------------------------------

class _BentoGrid extends StatelessWidget {
  const _BentoGrid({required this.movies});

  final List<TmdbSearchResult> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    final isWide = MediaQuery.sizeOf(context).width >= _kBreakpoint;
    final items = movies.take(3).toList();

    if (!isWide) {
      return Column(
        children: [
          _BentoCard(movie: items[0], height: 260),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _BentoCard(movie: items[1], height: 160)),
              const SizedBox(width: 16),
              Expanded(
                child: items.length > 2
                    ? _BentoCard(movie: items[2], height: 160)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      );
    }

    return SizedBox(
      height: 400,
      child: Row(
        children: [
          Expanded(flex: 2, child: _BentoCard(movie: items[0], height: 400)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _BentoCard(movie: items[1], height: 192)),
                const SizedBox(height: 16),
                Expanded(
                  child: items.length > 2
                      ? _BentoCard(movie: items[2], height: 192)
                      : const SizedBox.shrink(),
                ),
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

  final TmdbSearchResult movie;
  final double height;

  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final backdropUrl = widget.movie.backdropUrl('w780');

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push('/tmdb/${widget.movie.id}'),
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
                  child: backdropUrl != null
                      ? Image.network(
                          backdropUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              Container(color: AppColors.graphite),
                        )
                      : Container(color: AppColors.graphite),
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

// ---------------------------------------------------------------------------
// Skeleton loaders
// ---------------------------------------------------------------------------

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final h = size.width >= _kBreakpoint
        ? 500.0
        : (size.height * 0.55).clamp(300.0, 500.0);
    return _ShimmerBox(width: double.infinity, height: h, radius: 0);
  }
}

class _HorizontalSkeletonList extends StatelessWidget {
  const _HorizontalSkeletonList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, _) => const _ShimmerBox(width: 130, height: 240),
      ),
    );
  }
}

class _BentoSkeleton extends StatelessWidget {
  const _BentoSkeleton();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _kBreakpoint;
    if (!isWide) {
      return Column(
        children: [
          const _ShimmerBox(width: double.infinity, height: 260),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: _ShimmerBox(width: double.infinity, height: 160)),
              SizedBox(width: 16),
              Expanded(child: _ShimmerBox(width: double.infinity, height: 160)),
            ],
          ),
        ],
      );
    }
    return SizedBox(
      height: 400,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: const _ShimmerBox(width: double.infinity, height: 400),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: const [
                Expanded(
                  child: _ShimmerBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: _ShimmerBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A shimmer-effect placeholder box.
class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  final double width;
  final double height;
  final double radius;

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.graphite.withAlpha(180),
              Color.lerp(
                AppColors.graphite,
                AppColors.surfaceContainerHigh,
                _anim.value,
              )!,
              AppColors.graphite.withAlpha(180),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}
