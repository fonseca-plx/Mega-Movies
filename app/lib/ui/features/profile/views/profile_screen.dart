import 'package:flutter/material.dart';
import 'package:mega_movies/data/models/movie.dart';
import 'package:mega_movies/data/models/user_profile.dart';
import 'package:mega_movies/data/repositories/movie_repository.dart';
import 'package:mega_movies/ui/core/app_colors.dart';
import 'package:mega_movies/ui/core/app_text_styles.dart';
import 'package:mega_movies/ui/core/widgets/app_button.dart';
import 'package:go_router/go_router.dart';

const double _kMaxWidth = 900;
const double _kBreakpoint = 600;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MovieRepository();
    final profile = repo.getProfile();
    final watchlist = repo.getWatchlist(profile.watchlistIds);

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
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      children: [
                        _ProfileHero(profile: profile),
                        const SizedBox(height: 48),
                        _WatchlistSection(watchlist: watchlist),
                        const SizedBox(height: 96),
                      ],
                    ),
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
// Profile hero card
// ---------------------------------------------------------------------------

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _kBreakpoint;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.graphite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiary.withAlpha(26),
            blurRadius: 60,
            offset: const Offset(40, -20),
          ),
        ],
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Avatar(profile: profile),
                const SizedBox(width: 24),
                Expanded(child: _ProfileInfo(profile: profile)),
                const VerticalDivider(color: AppColors.glassBorder, width: 32),
                _QuickLinks(),
              ],
            )
          : Column(
              children: [
                _Avatar(profile: profile),
                const SizedBox(height: 16),
                _ProfileInfo(profile: profile),
                const Divider(color: AppColors.glassBorder, height: 32),
                _QuickLinks(horizontal: true),
              ],
            ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 2),
            boxShadow: [
              BoxShadow(color: AppColors.gold.withAlpha(77), blurRadius: 15),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              profile.avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: AppColors.graphite),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerHigh,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: const Icon(Icons.edit, size: 14, color: AppColors.onSurface),
          ),
        ),
      ],
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  const _ProfileInfo({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(profile.displayName, style: AppTextStyles.displayMd),
        const SizedBox(height: 4),
        Text(
          'Cinephile since ${profile.memberSince} • ${profile.moviesWatched} Movies Watched',
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            PrimaryButton(label: 'Edit Profile', onPressed: () {}),
            SecondaryButton(
              label: 'Premium Plan',
              icon: Icons.star,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({this.horizontal = false});
  final bool horizontal;

  static const List<_LinkItem> _links = [
    _LinkItem(icon: Icons.settings_outlined, label: 'Settings'),
    _LinkItem(icon: Icons.credit_card_outlined, label: 'Billing'),
    _LinkItem(icon: Icons.history, label: 'History'),
  ];

  @override
  Widget build(BuildContext context) {
    final children = _links
        .map((l) => _QuickLinkTile(item: l, horizontal: horizontal))
        .toList();

    return horizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
  }
}

class _QuickLinkTile extends StatefulWidget {
  const _QuickLinkTile({required this.item, this.horizontal = false});
  final _LinkItem item;
  final bool horizontal;

  @override
  State<_QuickLinkTile> createState() => _QuickLinkTileState();
}

class _QuickLinkTileState extends State<_QuickLinkTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.item.icon,
              color: _hovered ? AppColors.tertiary : AppColors.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              widget.item.label,
              style: AppTextStyles.labelLg.copyWith(
                color: _hovered
                    ? AppColors.tertiary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkItem {
  const _LinkItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

// ---------------------------------------------------------------------------
// Watchlist section
// ---------------------------------------------------------------------------

class _WatchlistSection extends StatelessWidget {
  const _WatchlistSection({required this.watchlist});
  final List<Movie> watchlist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text('My Watchlist', style: AppTextStyles.headlineLg),
            ),
            GhostButton(
              label: 'Filter',
              icon: Icons.filter_list,
              onPressed: () {},
            ),
          ],
        ),
        const Divider(color: AppColors.glassBorder, height: 24),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            // Adaptive column count based on width
            final crossCount = (constraints.maxWidth / 160).floor().clamp(2, 5);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: watchlist.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, i) => _WatchlistCard(movie: watchlist[i]),
            );
          },
        ),
      ],
    );
  }
}

class _WatchlistCard extends StatefulWidget {
  const _WatchlistCard({required this.movie});
  final Movie movie;

  @override
  State<_WatchlistCard> createState() => _WatchlistCardState();
}

class _WatchlistCardState extends State<_WatchlistCard> {
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
                      color: AppColors.metallicBlueDark.withAlpha(77),
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
                Image.network(
                  widget.movie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Container(color: AppColors.graphite),
                ),
                // Hover overlay
                AnimatedOpacity(
                  opacity: _hovered ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha(204),
                        ],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie.title,
                              style: AppTextStyles.headlineMd.copyWith(
                                fontSize: 14,
                              ),
                              maxLines: 2,
                            ),
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
                  ),
                ),
                // Bookmark badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(128),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bookmark,
                      size: 14,
                      color: AppColors.onSurface,
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
