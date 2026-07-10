import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mega_movies/data/local/app_database.dart';
import 'package:mega_movies/data/models/user_profile.dart';
import 'package:mega_movies/data/repositories/auth_repository.dart';
import 'package:mega_movies/ui/core/app_colors.dart';
import 'package:mega_movies/ui/core/app_text_styles.dart';
import 'package:mega_movies/ui/core/widgets/app_button.dart';
import 'package:mega_movies/ui/core/widgets/watchlist_scope.dart';

const double _kMaxWidth = 900;
const double _kBreakpoint = 600;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    final user = authRepository.currentUser!;

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
                        _ProfileHero(
                          profile: user,
                          authRepository: authRepository,
                        ),
                        const SizedBox(height: 48),
                        _WatchlistSection(
                          userId: user.id,
                          authRepository: authRepository,
                        ),
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
  const _ProfileHero({required this.profile, required this.authRepository});

  final UserProfile profile;
  final AuthRepository authRepository;

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
                Expanded(
                  child: _ProfileInfo(
                    profile: profile,
                    authRepository: authRepository,
                  ),
                ),
                const VerticalDivider(color: AppColors.glassBorder, width: 32),
                _QuickLinks(authRepository: authRepository),
              ],
            )
          : Column(
              children: [
                _Avatar(profile: profile),
                const SizedBox(height: 16),
                _ProfileInfo(profile: profile, authRepository: authRepository),
                const Divider(color: AppColors.glassBorder, height: 32),
                _QuickLinks(horizontal: true, authRepository: authRepository),
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
            child: profile.photo != null
                ? Image.network(
                    profile.photo!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        _InitialAvatar(initial: profile.initial),
                  )
                : _InitialAvatar(initial: profile.initial),
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

class _InitialAvatar extends StatelessWidget {
  const _InitialAvatar({required this.initial});
  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerHigh,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTextStyles.displayMd.copyWith(color: AppColors.gold),
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  const _ProfileInfo({required this.profile, required this.authRepository});

  final UserProfile profile;
  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    final memberYear = profile.joinedAt.year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(profile.fullName, style: AppTextStyles.displayMd),
        const SizedBox(height: 4),
        Text(
          profile.email,
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Cinephile since $memberYear',
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
  const _QuickLinks({this.horizontal = false, required this.authRepository});

  final bool horizontal;
  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    final staticLinks = [
      _QuickLinkTile(
        item: const _LinkItem(icon: Icons.settings_outlined, label: 'Settings'),
        horizontal: horizontal,
        onTap: () {},
      ),
      _QuickLinkTile(
        item: const _LinkItem(
          icon: Icons.credit_card_outlined,
          label: 'Billing',
        ),
        horizontal: horizontal,
        onTap: () {},
      ),
      _QuickLinkTile(
        item: const _LinkItem(icon: Icons.history, label: 'History'),
        horizontal: horizontal,
        onTap: () {},
      ),
      _QuickLinkTile(
        item: const _LinkItem(
          icon: Icons.logout,
          label: 'Sair',
          isDestructive: true,
        ),
        horizontal: horizontal,
        onTap: () => _confirmLogout(context, authRepository),
      ),
    ];

    return horizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: staticLinks,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: staticLinks,
          );
  }

  Future<void> _confirmLogout(BuildContext context, AuthRepository repo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.graphite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: Text('Sair da conta', style: AppTextStyles.headlineMd),
        content: Text(
          'Tem certeza que deseja sair?',
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancelar',
              style: AppTextStyles.labelLg.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Sair',
              style: AppTextStyles.labelLg.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await repo.logout();
      if (context.mounted) context.go('/');
    }
  }
}

class _QuickLinkTile extends StatefulWidget {
  const _QuickLinkTile({
    required this.item,
    this.horizontal = false,
    required this.onTap,
  });

  final _LinkItem item;
  final bool horizontal;
  final VoidCallback onTap;

  @override
  State<_QuickLinkTile> createState() => _QuickLinkTileState();
}

class _QuickLinkTileState extends State<_QuickLinkTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.item.isDestructive
        ? AppColors.error
        : AppColors.tertiary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.item.icon,
                color: _hovered ? activeColor : AppColors.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.item.label,
                style: AppTextStyles.labelLg.copyWith(
                  color: _hovered ? activeColor : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkItem {
  const _LinkItem({
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final bool isDestructive;
}

// ---------------------------------------------------------------------------
// Watchlist section — driven by WatchlistRepository via WatchlistScope
// ---------------------------------------------------------------------------

class _WatchlistSection extends StatelessWidget {
  const _WatchlistSection({required this.userId, required this.authRepository});

  final int userId;
  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    final watchlistRepo = WatchlistScope.of(context);

    if (watchlistRepo == null) return const SizedBox.shrink();

    return ListenableBuilder(
      listenable: watchlistRepo,
      builder: (context, _) {
        final entries = watchlistRepo.entries;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Minha Watchlist',
                    style: AppTextStyles.headlineLg,
                  ),
                ),
                Text(
                  '${entries.length} filme${entries.length == 1 ? '' : 's'}',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.glassBorder, height: 24),
            const SizedBox(height: 8),
            entries.isEmpty
                ? const _EmptyWatchlist()
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final crossCount = (constraints.maxWidth / 160)
                          .floor()
                          .clamp(2, 5);
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: entries.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2 / 3,
                        ),
                        itemBuilder: (context, i) => _WatchlistCard(
                          entry: entries[i],
                          onRemove: () =>
                              watchlistRepo.remove(userId, entries[i].movieId),
                        ),
                      );
                    },
                  ),
          ],
        );
      },
    );
  }
}

class _EmptyWatchlist extends StatelessWidget {
  const _EmptyWatchlist();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(
            Icons.bookmarks_outlined,
            size: 48,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Sua watchlist está vazia',
            style: AppTextStyles.headlineMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore filmes e adicione-os à sua lista.',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _WatchlistCard extends StatefulWidget {
  const _WatchlistCard({required this.entry, required this.onRemove});

  final WatchlistEntry entry;
  final VoidCallback onRemove;

  @override
  State<_WatchlistCard> createState() => _WatchlistCardState();
}

class _WatchlistCardState extends State<_WatchlistCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final posterUrl = widget.entry.posterPath != null
        ? 'https://image.tmdb.org/t/p/w342${widget.entry.posterPath}'
        : null;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push('/tmdb/${widget.entry.movieId}'),
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
                posterUrl != null
                    ? Image.network(
                        posterUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            Container(color: AppColors.graphite),
                      )
                    : Container(color: AppColors.graphite),
                // Overlay with title on hover
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
                              widget.entry.title,
                              style: AppTextStyles.headlineMd.copyWith(
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.entry.year != null)
                              Text(
                                '${widget.entry.year}',
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
                // Remove button — always visible in top-right corner
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: widget.onRemove,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(153),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const Icon(
                        Icons.bookmark_remove,
                        size: 16,
                        color: AppColors.onSurface,
                      ),
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
