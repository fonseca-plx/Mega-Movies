import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mega_movies/data/models/tmdb_genre.dart';
import 'package:mega_movies/data/models/tmdb_search_result.dart';
import 'package:mega_movies/data/repositories/movie_repository.dart';
import 'package:mega_movies/ui/core/app_colors.dart';
import 'package:mega_movies/ui/core/app_text_styles.dart';
import 'package:mega_movies/ui/features/explore/view_models/explore_view_model.dart';

const double _kMaxWidth = 1200;
const double _kBreakpoint = 600;

/// Featured genre IDs (TMDB) shown in the genre bento grid.
///
/// Each entry maps a display label to its TMDB genre ID.
const List<({String label, int id})> _kFeaturedGenres = [
  (label: 'Crime', id: 80),
  (label: 'Drama', id: 18),
  (label: 'Ficção Científica', id: 878),
  (label: 'Thriller', id: 53),
  (label: 'Ação', id: 28),
  (label: 'Animação', id: 16),
  (label: 'Comédia', id: 35),
  (label: 'Terror', id: 27),
];

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _controller = TextEditingController();
  late final ExploreViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ExploreViewModel(repository: MovieRepository());
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadDefaultContent();
  }

  @override
  void dispose() {
    _viewModel
      ..removeListener(_onViewModelChanged)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onViewModelChanged() => setState(() {});

  void _onSearch(String query) => _viewModel.search(query);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _kMaxWidth),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Discover Cinema',
                            style: AppTextStyles.displayMd,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _SearchBar(
                          controller: _controller,
                          onSubmitted: _onSearch,
                        ),
                        const SizedBox(height: 32),
                        if (_viewModel.hasSearched) ...[
                          _TmdbSearchResults(viewModel: _viewModel),
                        ] else ...[
                          Text(
                            'Explore Genres',
                            style: AppTextStyles.headlineMd,
                          ),
                          const SizedBox(height: 16),
                          _GenreGrid(
                            featuredGenres: _kFeaturedGenres,
                            allGenres: _viewModel.genres,
                            isLoading: _viewModel.isLoadingDefault,
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              const Icon(
                                Icons.trending_up,
                                color: AppColors.tertiary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Em Alta Esta Semana',
                                style: AppTextStyles.headlineMd,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Trending horizontal list — only when not searching
          if (!_viewModel.hasSearched)
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _kMaxWidth),
                  child: _viewModel.isLoadingDefault
                      ? const _TrendingSkeletonRow()
                      : SizedBox(
                          height: 80,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            scrollDirection: Axis.horizontal,
                            itemCount: _viewModel.trendingMovies.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, i) => _TrendingChip(
                              movie: _viewModel.trendingMovies[i],
                            ),
                          ),
                        ),
                ),
              ),
            ),

          // Popular movies grid — only when not searching
          if (!_viewModel.hasSearched)
            _viewModel.isLoadingDefault
                ? SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (_, _) => const _SkeletonTile(),
                        childCount: 12,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) =>
                            _TmdbMovieTile(result: _viewModel.popularMovies[i]),
                        childCount: _viewModel.popularMovies.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                    ),
                  ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search bar
// ---------------------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextField(
          controller: controller,
          onSubmitted: onSubmitted,
          style: AppTextStyles.bodyLg,
          decoration: InputDecoration(
            hintText: 'Search films, directors, genres…',
            hintStyle: AppTextStyles.bodyLg.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.onSurfaceVariant,
            ),
            suffixIcon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, _) => value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      color: AppColors.onSurfaceVariant,
                      onPressed: () {
                        controller.clear();
                        onSubmitted('');
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            filled: true,
            fillColor: AppColors.glassPanel,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.glassBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.tertiary, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search results
// ---------------------------------------------------------------------------

class _TmdbSearchResults extends StatelessWidget {
  const _TmdbSearchResults({required this.viewModel});

  final ExploreViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: CircularProgressIndicator(
            color: AppColors.gold,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off_outlined,
                color: AppColors.onSurfaceVariant,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage!,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off,
                color: AppColors.onSurfaceVariant,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhum filme encontrado.',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tente um título diferente.',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _SearchResultsGrid(results: viewModel.searchResults);
  }
}

class _SearchResultsGrid extends StatelessWidget {
  const _SearchResultsGrid({required this.results});

  final List<TmdbSearchResult> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.video_library_outlined,
              color: AppColors.tertiary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text('Resultados', style: AppTextStyles.headlineMd),
            const SizedBox(width: 8),
            Text(
              '(${results.length})',
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: results.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 2 / 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (context, i) => _TmdbMovieTile(result: results[i]),
        ),
        const SizedBox(height: 96),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Genre grid with real posters
// ---------------------------------------------------------------------------

class _GenreGrid extends StatelessWidget {
  const _GenreGrid({
    required this.featuredGenres,
    required this.allGenres,
    required this.isLoading,
  });

  final List<({String label, int id})> featuredGenres;
  final List<TmdbGenre> allGenres;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _kBreakpoint;
    final crossAxisCount = isWide ? 4 : 2;

    if (isLoading) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 16 / 9,
        ),
        itemCount: featuredGenres.length,
        itemBuilder: (_, _) => ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const _SkeletonTile(),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 16 / 9,
      ),
      itemCount: featuredGenres.length,
      itemBuilder: (context, i) {
        final g = featuredGenres[i];
        return _GenreCard(label: g.label, genreId: g.id);
      },
    );
  }
}

/// Genre card that lazily loads its backdrop from TMDB.
class _GenreCard extends StatefulWidget {
  const _GenreCard({required this.label, required this.genreId});

  final String label;
  final int genreId;

  @override
  State<_GenreCard> createState() => _GenreCardState();
}

class _GenreCardState extends State<_GenreCard> {
  bool _hovered = false;
  String? _backdropUrl;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBackdrop();
  }

  Future<void> _loadBackdrop() async {
    try {
      final repo = MovieRepository();
      final movies = await repo.discoverByGenres(
        [widget.genreId],
        sortBy: 'popularity.desc',
        limit: 1,
      );
      if (mounted && movies.isNotEmpty && movies.first.backdropPath != null) {
        setState(() {
          _backdropUrl = movies.first.backdropUrl('w780');
          _imageLoaded = true;
        });
      }
    } catch (_) {
      // Silent failure — card keeps the gradient fallback.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push(
          '/explore/genre/${widget.genreId}?label=${Uri.encodeComponent(widget.label)}',
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: AppColors.graphite,
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppColors.gold.withAlpha(50),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_imageLoaded && _backdropUrl != null)
                  AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 400),
                    child: AnimatedScale(
                      scale: _hovered ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Image.network(
                        _backdropUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                // Gradient overlay
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x44000000), Color(0xCC000000)],
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    widget.label,
                    style: AppTextStyles.headlineMd.copyWith(fontSize: 14),
                    textAlign: TextAlign.center,
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
// Trending chip (compact horizontal tile)
// ---------------------------------------------------------------------------

class _TrendingChip extends StatefulWidget {
  const _TrendingChip({required this.movie});

  final TmdbSearchResult movie;

  @override
  State<_TrendingChip> createState() => _TrendingChipState();
}

class _TrendingChipState extends State<_TrendingChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push('/tmdb/${widget.movie.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.surfaceContainerHigh
                : AppColors.glassPanel,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: _hovered ? AppColors.tertiary : AppColors.glassBorder,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.tertiary.withAlpha(40),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department,
                color: AppColors.tertiary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                widget.movie.title,
                style: AppTextStyles.labelLg.copyWith(
                  color: _hovered
                      ? AppColors.onSurface
                      : AppColors.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendingSkeletonRow extends StatelessWidget {
  const _TrendingSkeletonRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, _) => const _SkeletonChip(),
      ),
    );
  }
}

class _SkeletonChip extends StatelessWidget {
  const _SkeletonChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.graphite,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TMDB movie tile (poster + overlay)
// ---------------------------------------------------------------------------

class _TmdbMovieTile extends StatefulWidget {
  const _TmdbMovieTile({required this.result});

  final TmdbSearchResult result;

  @override
  State<_TmdbMovieTile> createState() => _TmdbMovieTileState();
}

class _TmdbMovieTileState extends State<_TmdbMovieTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final posterUrl = widget.result.posterUrl('w342');

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push('/tmdb/${widget.result.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.gold.withAlpha(77),
                      blurRadius: 15,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                posterUrl != null
                    ? Image.network(
                        posterUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _PosterFallback(title: widget.result.title),
                      )
                    : _PosterFallback(title: widget.result.title),
                // Gradient overlay for title legibility
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(230),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.result.title,
                          style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.result.year != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${widget.result.year}',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
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

/// Fallback widget shown when a poster image is unavailable.
class _PosterFallback extends StatelessWidget {
  const _PosterFallback({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.graphite,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.movie_outlined,
                color: AppColors.onSurfaceVariant,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Skeleton tile for grids
// ---------------------------------------------------------------------------

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.graphite,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
