import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mega_movies/ui/core/app_colors.dart';
import 'package:mega_movies/ui/core/app_text_styles.dart';

const double _kBreakpoint = 600;

/// Responsive navigation shell.
///
/// - **Narrow (< 600 px)**: bottom navigation bar (mobile / portrait).
/// - **Wide (≥ 600 px)**: top navigation bar in a glass header — no side rail.
///
/// Uses [LayoutBuilder] on `maxWidth` as recommended by the
/// `flutter-build-responsive-layout` skill (never checks hardware type or
/// orientation directly).
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _kBreakpoint) {
          return _WideLayout(
            navigationShell: navigationShell,
            items: _items,
            currentIndex: navigationShell.currentIndex,
            onTap: _onTap,
          );
        }
        return _NarrowLayout(
          navigationShell: navigationShell,
          items: _items,
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Narrow layout — bottom nav bar
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
// Wide layout — top navigation bar only (no side rail)
// ---------------------------------------------------------------------------

class _WideLayout extends StatelessWidget {
  const _WideLayout({
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
      body: navigationShell,
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
