import 'package:flutter/material.dart';

/// Custom bottom navigation bar widget for enterprise banking application.
/// Implements Hub-and-Spoke navigation pattern with Service Selection as central hub.
///
/// Features:
/// - Fixed bottom navigation with 3 primary banking modules
/// - Parameterized for reusability across different implementations
/// - Supports both light and dark themes
/// - Enhanced touch targets (56pt height) for one-handed operation
/// - Material Design 3 styling with banking-appropriate aesthetics
///
/// Usage:
/// ```dart
/// CustomBottomBar(
///   currentIndex: _selectedIndex,
///   onTap: (index) {
///     setState(() => _selectedIndex = index);
///     // Handle navigation
///   },
/// )
/// ```
class CustomBottomBar extends StatelessWidget {
  /// Current selected index (0-2)
  final int currentIndex;

  /// Callback when navigation item is tapped
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: theme.brightness == Brightness.light
              ? const Color(0xFF6B7280)
              : const Color(0xFF9CA3AF),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            height: 1.33,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
            height: 1.33,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(Icons.dashboard_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(Icons.dashboard, size: 24),
              ),
              label: 'Services',
              tooltip: 'Service Selection Hub',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(Icons.account_balance_outlined, size: 24),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(Icons.account_balance, size: 24),
              ),
              label: 'Banking',
              tooltip: 'Core Banking Module',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(Icons.person_outline, size: 24),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(Icons.person, size: 24),
              ),
              label: 'Profile',
              tooltip: 'User Profile & Settings',
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation item data model for bottom bar configuration
class BottomBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final String tooltip;

  const BottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    required this.tooltip,
  });
}

/// Predefined navigation items for enterprise banking
class BankingBottomBarItems {
  BankingBottomBarItems._();

  static const List<BottomBarItem> items = [
    BottomBarItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Services',
      route: '/service-selection-screen',
      tooltip: 'Service Selection Hub',
    ),
    BottomBarItem(
      icon: Icons.account_balance_outlined,
      activeIcon: Icons.account_balance,
      label: 'Banking',
      route: '/service-selection-screen',
      tooltip: 'Core Banking Module',
    ),
    BottomBarItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/service-selection-screen',
      tooltip: 'User Profile & Settings',
    ),
  ];
}
