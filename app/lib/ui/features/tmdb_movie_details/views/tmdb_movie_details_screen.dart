import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mega_movies/data/models/tmdb_cast_member.dart';
import 'package:mega_movies/data/models/tmdb_movie_details.dart';
import 'package:mega_movies/data/models/tmdb_search_result.dart';
import 'package:mega_movies/data/repositories/auth_repository.dart';
import 'package:mega_movies/data/repositories/movie_repository.dart';
import 'package:mega_movies/data/repositories/watchlist_repository.dart';
import 'package:mega_movies/data/services/tmdb_movie_service.dart';
import 'package:mega_movies/ui/core/app_colors.dart';
import 'package:mega_movies/ui/core/app_text_styles.dart';
import 'package:mega_movies/ui/core/widgets/app_button.dart';
import 'package:mega_movies/ui/core/widgets/glass_chip.dart';

const double _kMaxWidth = 1200;

/// Full-screen details page for a TMDB movie.
///
/// Fetches movie details (with cast) and recommendations in parallel.
///
/// Receives [authRepository] and [watchlistRepository] via constructor because
/// this route lives outside [StatefulShellRoute] and therefore cannot access
/// the [AuthScope] / [WatchlistScope] provided by [AppShell].
class TmdbMovieDetailsScreen extends StatefulWidget {
  const TmdbMovieDetailsScreen({
    super.key,
    required this.tmdbId,
    required this.authRepository,
    required this.watchlistRepository,
  });

  final int tmdbId;
  final AuthRepository authRepository;
  final WatchlistRepository watchlistRepository;

  @override
  State<TmdbMovieDetailsScreen> createState() => _TmdbMovieDetailsScreenState();
}

class _TmdbMovieDetailsScreenState extends State<TmdbMovieDetailsScreen> {
  final _repo = MovieRepository();

  TmdbMovieDetails? _details;
  List<TmdbSearchResult> _recommendations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    try {
      final results = await Future.wait([
        _repo.getMovieDetails(widget.tmdbId),
        _repo.getRecommendations(widget.tmdbId),
      ]);
      if (mounted) {
        setState(() {
          _details = results[0] as TmdbMovieDetails;
          _recommendations = (results[1] as List<TmdbSearchResult>)
              .where((m) => m.posterPath != null)
              .take(10)
              .toList();
        });
      }
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
    return _DetailsView(
      movie: _details!,
      recommendations: _recommendations,
      authRepository: widget.authRepository,
      watchlistRepository: widget.watchlistRepository,
    );
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
  const _DetailsView({
    required this.movie,
    required this.recommendations,
    required this.authRepository,
    required this.watchlistRepository,
  });

  final TmdbMovieDetails movie;
  final List<TmdbSearchResult> recommendations;
  final AuthRepository authRepository;
  final WatchlistRepository watchlistRepository;

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
                      _ActionButtons(
                        movie: movie,
                        authRepository: authRepository,
                        watchlistRepository: watchlistRepository,
                      ),
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
                      if (movie.credits.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Text('Elenco', style: AppTextStyles.headlineMd),
                        const SizedBox(height: 16),
                        _CastRow(cast: movie.credits),
                      ],
                      if (recommendations.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Text(
                          'Você Também Pode Gostar',
                          style: AppTextStyles.headlineMd,
                        ),
                        const SizedBox(height: 16),
                        _RecommendationsRow(movies: recommendations),
                      ],
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
// Hero section
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
          if (backdropUrl != null)
            Image.network(
              backdropUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: AppColors.graphite),
            )
          else
            Container(color: AppColors.graphite),
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
                        .take(3)
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
  const _ActionButtons({
    required this.movie,
    required this.authRepository,
    required this.watchlistRepository,
  });

  final TmdbMovieDetails movie;
  final AuthRepository authRepository;
  final WatchlistRepository watchlistRepository;

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
            child: _WatchlistButton(
              movie: movie,
              authRepository: authRepository,
              watchlistRepository: watchlistRepository,
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
        _WatchlistButton(
          movie: movie,
          authRepository: authRepository,
          watchlistRepository: watchlistRepository,
          isFullWidth: true,
        ),
      ],
    );
  }
}

/// Reactive watchlist toggle button.
///
/// Shows "Adicionar à Lista" when the movie is not saved, and "Adicionado"
/// when it is. Requires the user to be authenticated; otherwise shows a
/// [SnackBar] directing them to log in.
class _WatchlistButton extends StatelessWidget {
  const _WatchlistButton({
    required this.movie,
    required this.authRepository,
    required this.watchlistRepository,
    this.isFullWidth = false,
  });

  final TmdbMovieDetails movie;
  final AuthRepository authRepository;
  final WatchlistRepository watchlistRepository;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: watchlistRepository,
      builder: (context, _) {
        final inWatchlist = watchlistRepository.isInWatchlist(movie.id);

        return SecondaryButton(
          label: inWatchlist ? 'Adicionado' : 'Adicionar à Lista',
          icon: inWatchlist ? Icons.bookmark : Icons.bookmark_border,
          isFullWidth: isFullWidth,
          onPressed: () => _toggle(context, inWatchlist: inWatchlist),
        );
      },
    );
  }

  Future<void> _toggle(
    BuildContext context, {
    required bool inWatchlist,
  }) async {
    if (!authRepository.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Faça login para salvar filmes na sua watchlist'),
          action: SnackBarAction(
            label: 'Entrar',
            onPressed: () => context.push('/login'),
          ),
        ),
      );
      return;
    }

    final userId = authRepository.currentUser!.id;
    try {
      if (inWatchlist) {
        await watchlistRepository.remove(userId, movie.id);
      } else {
        await watchlistRepository.add(userId, movie);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar watchlist. Tente novamente.'),
          ),
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Cast row
// ---------------------------------------------------------------------------

class _CastRow extends StatelessWidget {
  const _CastRow({required this.cast});

  final List<TmdbCastMember> cast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: cast.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, i) => _CastCard(member: cast[i]),
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({required this.member});

  final TmdbCastMember member;

  @override
  Widget build(BuildContext context) {
    final photoUrl = member.profileUrl('w185');

    return SizedBox(
      width: 72,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.graphite,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? const Icon(Icons.person, color: AppColors.onSurfaceVariant)
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            member.name,
            style: AppTextStyles.labelSm,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Recommendations row
// ---------------------------------------------------------------------------

class _RecommendationsRow extends StatelessWidget {
  const _RecommendationsRow({required this.movies});

  final List<TmdbSearchResult> movies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) => _RecommendationCard(movie: movies[i]),
      ),
    );
  }
}

class _RecommendationCard extends StatefulWidget {
  const _RecommendationCard({required this.movie});

  final TmdbSearchResult movie;

  @override
  State<_RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<_RecommendationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final posterUrl = widget.movie.posterUrl('w185');

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push('/tmdb/${widget.movie.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.gold.withAlpha(60),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: posterUrl != null
                ? Image.network(
                    posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppColors.graphite,
                      child: Center(
                        child: Text(
                          widget.movie.title,
                          style: AppTextStyles.labelSm,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ),
                    ),
                  )
                : Container(color: AppColors.graphite),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Glass icon button
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
