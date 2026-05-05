import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mega_movies/data/models/movie.dart';
import 'package:mega_movies/data/repositories/movie_repository.dart';
import 'package:mega_movies/ui/core/app_colors.dart';
import 'package:mega_movies/ui/core/app_text_styles.dart';

const double _kMaxWidth = 1200;
const double _kBreakpoint = 600;

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _repo = MovieRepository();
  final _controller = TextEditingController();
  List<Movie> _results = [];

  @override
  void initState() {
    super.initState();
    _results = _repo.getAll();
    _controller.addListener(_onSearch);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onSearch)
      ..dispose();
    super.dispose();
  }

  void _onSearch() {
    setState(() => _results = _repo.search(_controller.text));
  }

  static const List<_Genre> _genres = [
    _Genre(
      label: 'Film Noir',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDh2FI4s1aMNH_5WNQaHZxki-vpETDyF_BKbzzrAY1IH_C_firKJoIWRK8TB9YROElplLh146aAbstZlELGdKGkuHMAVzcsRXLbGFjFhn1WKEvlkg4B3s-HJJYsWHNbl4gAeu0h5kvJQZRlKS5ld2cbygt92ZGP_QFA1K4oyV6Jz21bZeOAs8DyB1lQ0RtJ5vu7KxyrEz29YmjUtS4NIzsk_FknMCg9TwmkgKGSErQuAK4-Zs_amMPM6ojQuBTsu1PUVe8NXbvBdsrI',
    ),
    _Genre(
      label: 'Classic Hollywood',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAmNTQlSR-dVEqVqNcsn1JsvdZmlfViqBaD_BpnfsxoNvB8L6QslNyeZzpLSBFiuUMUGmiyJ9NfCDwuW_W2lMUuMB1t8-iauQYzuSAw2hiPPYeiaZ62R6qV5XsD_73WT88AwkV1kjQgA_Whg1oqIBYv5rNIeiTAUvWEZglBAxEdzXRrrSJnuGhdjJSClBMusWED4p5DMKh0g9tzeHxBY3LaAQUAQyehJNcTzlE93q0mzIUqdXa_W5nOtD9nvSwmVnHUeZgxFtFlhCE',
    ),
    _Genre(
      label: 'French New Wave',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC_1iVTGPVZXcb7B8VrVTPQWGyi8FW4nxetpfvKqWxf1rfqeDpYxoXB_3sobg7-HexQJlm4O4G8hmsg73NSldyh1t91URI0JQ6CuTNj12X6kOwN-Loc5RO6h1avyAzO0cSXiKrdi_1eaoJmZqSAg-auxniWvfV0GbbJSoe61y9OsLJaYcGJRVNzdaM-4IZotL3V-woDylviF4IKHokEf3ZHdW-J3aZOhdmLCvSE9RIzoHeKo-GLHRfA8qrBlfTbH5TFfu3fthEHD2E',
    ),
    _Genre(
      label: 'Sci-Fi Visionaries',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDFHy3AftgrqkmknPsFdjx049Zm4TTIn08zOhWJP6yXULvjMT2HBYI8i-Oqoy5eg0sgKThryjabX-mocTeZYoLPq9sT3Awm5vRuVbYeSkH4ZvQc4shXFaWiVoO8ruXnuSOqN5HA0c5QAiPr3yAI6TnrMro_Oys327YUQSXx3ZoNdAAKRZw2_qz1PzzzCgOj2oalTzuTHZPZBWkFr_2gOw_ZiJTxbtLS7Rino-0xv1nmXjhHvKd4mQLbFytUuDoqcvWyGgiGDh0vaD8',
    ),
  ];

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
                        // Title
                        Center(
                          child: Text(
                            'Discover Cinema',
                            style: AppTextStyles.displayMd,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Search bar
                        _SearchBar(controller: _controller),
                        const SizedBox(height: 32),
                        // Genre bento grid
                        Text('Explore Genres', style: AppTextStyles.headlineMd),
                        const SizedBox(height: 16),
                        _GenreBentoGrid(genres: _genres),
                        const SizedBox(height: 32),
                        // Trending row
                        Row(
                          children: [
                            const Icon(
                              Icons.trending_up,
                              color: AppColors.tertiary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Trending Searches',
                              style: AppTextStyles.headlineMd,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Trending horizontal list
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _kMaxWidth),
                child: SizedBox(
                  height: 80,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: _results.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, i) =>
                        _TrendingCard(movie: _results[i]),
                  ),
                ),
              ),
            ),
          ),
          // Results grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _GridMovieTile(movie: _results[i]),
                childCount: _results.length,
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextField(
          controller: controller,
          style: AppTextStyles.bodyMd,
          decoration: InputDecoration(
            hintText: 'Search by title, director, or genre…',
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.onSurfaceVariant,
            ),
            filled: true,
            fillColor: AppColors.graphite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.metallicBlueDark),
            ),
          ),
        ),
      ),
    );
  }
}

class _GenreBentoGrid extends StatelessWidget {
  const _GenreBentoGrid({required this.genres});
  final List<_Genre> genres;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _kBreakpoint;
    final cols = isWide ? 4 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: genres.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isWide ? 1 : 4 / 3,
      ),
      itemBuilder: (context, i) => _GenreCard(genre: genres[i]),
    );
  }
}

class _GenreCard extends StatefulWidget {
  const _GenreCard({required this.genre});
  final _Genre genre;

  @override
  State<_GenreCard> createState() => _GenreCardState();
}

class _GenreCardState extends State<_GenreCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              scale: _hovered ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 400),
              child: Image.network(
                widget.genre.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: AppColors.graphite),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(_hovered ? 179 : 230),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                widget.genre.label,
                style: AppTextStyles.headlineMd.copyWith(
                  color: _hovered ? AppColors.tertiary : AppColors.onSurface,
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.glassBorder),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.graphite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                width: 36,
                height: 52,
                child: Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Container(color: AppColors.surfaceVariant),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: AppTextStyles.labelLg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    movie.director,
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridMovieTile extends StatefulWidget {
  const _GridMovieTile({required this.movie});
  final Movie movie;

  @override
  State<_GridMovieTile> createState() => _GridMovieTileState();
}

class _GridMovieTileState extends State<_GridMovieTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push('/movie/${widget.movie.id}'),
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
            child: Image.network(
              widget.movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: AppColors.graphite),
            ),
          ),
        ),
      ),
    );
  }
}

class _Genre {
  const _Genre({required this.label, required this.imageUrl});
  final String label;
  final String imageUrl;
}
