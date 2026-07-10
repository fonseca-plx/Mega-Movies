import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mega_movies/data/repositories/auth_repository.dart';
import 'package:mega_movies/data/repositories/watchlist_repository.dart';
import 'package:mega_movies/ui/core/app_colors.dart';
import 'package:mega_movies/ui/core/app_text_styles.dart';
import 'package:mega_movies/ui/core/widgets/auth_scope.dart';
import 'package:mega_movies/ui/core/widgets/watchlist_scope.dart';

const double _kBreakpoint = 600;

/// Responsive navigation shell.
///
/// - **Narrow (< 600 px)**: bottom navigation bar (mobile / portrait).
/// - **Wide (≥ 600 px)**: top navigation bar in a glass header — no side rail.
///
/// Wraps the entire subtree in [AuthScope] so any descendant screen can access
/// the [AuthRepository] via `AuthScope.of(context)`.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
    required this.authRepository,
    required this.watchlistRepository,
  });

  final StatefulNavigationShell navigationShell;
  final AuthRepository authRepository;
  final WatchlistRepository watchlistRepository;

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    _NavItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      label: 'Explore',
    ),
    _NavItem(
      icon: Icons.bookmarks_outlined,
      activeIcon: Icons.bookmarks,
      label: 'Watchlist',
    ),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      repository: authRepository,
      child: WatchlistScope(
        repository: watchlistRepository,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= _kBreakpoint) {
              return _WideLayout(
                navigationShell: navigationShell,
                items: _items,
                currentIndex: navigationShell.currentIndex,
                onTap: _onTap,
                authRepository: authRepository,
              );
            }
            return _NarrowLayout(
              navigationShell: navigationShell,
              items: _items,
              currentIndex: navigationShell.currentIndex,
              onTap: _onTap,
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Auth header action — "Entrar" button or user avatar
// ---------------------------------------------------------------------------

class AuthHeaderAction extends StatelessWidget {
  const AuthHeaderAction({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authRepository,
      builder: (context, _) {
        final user = authRepository.currentUser;

        if (user == null) {
          return _EnterButton(onTap: () => context.push('/login'));
        }

        return _UserAvatar(
          photoUrl: user.photo,
          initial: user.initial,
          onTap: () => context.push('/profile'),
        );
      },
    );
  }
}

class _EnterButton extends StatefulWidget {
  const _EnterButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_EnterButton> createState() => _EnterButtonState();
}

class _EnterButtonState extends State<_EnterButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: _hovered
                ? const LinearGradient(
                    colors: [
                      AppColors.metallicBlueLight,
                      AppColors.metallicBlueDark,
                    ],
                  )
                : null,
            border: _hovered ? null : Border.all(color: AppColors.glassBorder),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.metallicBlueDark.withAlpha(77),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Text(
            'Entrar',
            style: AppTextStyles.labelLg.copyWith(
              color: _hovered ? Colors.white : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatefulWidget {
  const _UserAvatar({
    required this.photoUrl,
    required this.initial,
    required this.onTap,
  });
  final String? photoUrl;
  final String initial;
  final VoidCallback onTap;

  @override
  State<_UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<_UserAvatar> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _hovered ? AppColors.gold : AppColors.glassBorder,
              width: _hovered ? 2 : 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.gold.withAlpha(77),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
          child: ClipOval(
            child: widget.photoUrl != null
                ? Image.network(
                    widget.photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        _InitialFallback(initial: widget.initial),
                  )
                : _InitialFallback(initial: widget.initial),
          ),
        ),
      ),
    );
  }
}

class _InitialFallback extends StatelessWidget {
  const _InitialFallback({required this.initial});
  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerHigh,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTextStyles.labelLg.copyWith(color: AppColors.gold),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Narrow layout — bottom nav bar, NO top AppBar (header lives in each screen)
// ---------------------------------------------------------------------------

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({
    required this.navigationShell,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final StatefulNavigationShell navigationShell;
  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBody: true,
      // No AppBar here — each screen owns its narrow header via AuthScope
      body: navigationShell,
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(230),
              border: const Border(
                top: BorderSide(color: AppColors.glassBorder),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(128),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(items.length, (i) {
                    final item = items[i];
                    final active = currentIndex == i;
                    return _BottomNavItem(
                      item: item,
                      isActive: active,
                      onTap: () => onTap(i),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? item.activeIcon : item.icon,
              size: 24,
              color: isActive
                  ? AppColors.metallicBlueLight
                  : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              item.label.toUpperCase(),
              style: AppTextStyles.labelSm.copyWith(
                fontSize: 10,
                color: isActive
                    ? AppColors.metallicBlueLight
                    : AppColors.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Wide layout — top navigation bar with glass header
// ---------------------------------------------------------------------------

class _WideLayout extends StatelessWidget {
  const _WideLayout({
    required this.navigationShell,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.authRepository,
  });

  final StatefulNavigationShell navigationShell;
  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _GlassHeader(
              items: items,
              currentIndex: currentIndex,
              onTap: onTap,
              authRepository: authRepository,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassHeader extends StatelessWidget {
  const _GlassHeader({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.authRepository,
  });

  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(179),
            border: const Border(
              bottom: BorderSide(color: AppColors.glassBorder),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      'MEGA MOVIES',
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.gold,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: Row(
                        children: List.generate(items.length, (i) {
                          return _HeaderNavLink(
                            item: items[i],
                            isActive: currentIndex == i,
                            onTap: () => onTap(i),
                          );
                        }),
                      ),
                    ),
                    AuthHeaderAction(authRepository: authRepository),
                    const SizedBox(width: 8),
                  ],
                ),
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
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_HeaderNavLink> createState() => _HeaderNavLinkState();
}

class _HeaderNavLinkState extends State<_HeaderNavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive
        ? AppColors.onSurface
        : _hovered
        ? AppColors.onSurface
        : AppColors.onSurfaceVariant;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.item.label,
                style: AppTextStyles.labelLg.copyWith(color: color),
              ),
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isActive ? 20 : 0,
                decoration: BoxDecoration(
                  color: AppColors.metallicBlueLight,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
