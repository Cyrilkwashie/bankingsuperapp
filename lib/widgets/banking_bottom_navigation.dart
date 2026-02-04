import 'package:flutter/material.dart';

/// Reusable Bottom Navigation Component for Banking Dashboards
class BankingBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  const BankingBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2328) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
          selectedItemColor: isDark ? Colors.white : const Color(0xFF1B365D),
          unselectedItemColor: isDark
              ? Colors.white54
              : const Color(0xFF6B7280),
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
          items: items,
        ),
      ),
    );
  }
}

/// Predefined navigation items for different banking services
class BankingNavigationItems {
  BankingNavigationItems._();

  static List<BottomNavigationBarItem> smartBranchItems = [
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.dashboard_outlined, size: 24),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.dashboard, size: 24),
      ),
      label: 'Dashboard',
      tooltip: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.receipt_long_outlined, size: 24),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.receipt_long, size: 24),
      ),
      label: 'Transactions',
      tooltip: 'Transaction History',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.settings_outlined, size: 24),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.settings, size: 24),
      ),
      label: 'Settings',
      tooltip: 'Settings',
    ),
  ];

  static List<BottomNavigationBarItem> agencyItems = [
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.dashboard_outlined, size: 24),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.dashboard, size: 24),
      ),
      label: 'Dashboard',
      tooltip: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.receipt_long_outlined, size: 24),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.receipt_long, size: 24),
      ),
      label: 'Transactions',
      tooltip: 'Transaction History',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.location_on_outlined, size: 24),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.location_on, size: 24),
      ),
      label: 'Locations',
      tooltip: 'Branch Locations',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.settings_outlined, size: 24),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.settings, size: 24),
      ),
      label: 'Settings',
      tooltip: 'Settings',
    ),
  ];

  static List<BottomNavigationBarItem> merchantItems = [
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.dashboard_outlined, size: 24),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.dashboard, size: 24),
      ),
      label: 'Dashboard',
      tooltip: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.receipt_long_outlined, size: 24),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.receipt_long, size: 24),
      ),
      label: 'Transactions',
      tooltip: 'Transaction History',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.settings_outlined, size: 24),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(Icons.settings, size: 24),
      ),
      label: 'Settings',
      tooltip: 'Settings',
    ),
  ];
}
