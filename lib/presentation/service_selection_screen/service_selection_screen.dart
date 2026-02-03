import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/service_card_widget.dart';
import './widgets/service_carousel_widget.dart';
import './widgets/service_info_bottom_sheet.dart';

/// Service Selection Screen - Main hub for banking module selection
/// Implements Hub-and-Spoke navigation pattern with auto-sliding carousel
class ServiceSelectionScreen extends StatefulWidget {
  const ServiceSelectionScreen({super.key});

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  final PageController _pageController = PageController();
  Timer? _autoSlideTimer;
  int _currentPage = 0;
  bool _isDarkMode = false;

  final List<Map<String, dynamic>> _carouselItems = [
    {
      "title": "Smart Branch",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_16d5b7740-1766841180313.png",
      "semanticLabel":
          "Modern banking office interior with digital screens displaying financial data and comfortable seating areas",
    },
    {
      "title": "Agency Banking",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1dbceb335-1766845727744.png",
      "semanticLabel":
          "Professional banking agent assisting customer with mobile banking services at a service counter",
    },
    {
      "title": "Merchant Banking",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_15a8f6ab7-1769689328768.png",
      "semanticLabel":
          "Small business owner using point-of-sale terminal to process customer payment in modern retail store",
    },
  ];

  final List<Map<String, dynamic>> _serviceCards = [
    {
      "icon": "account_balance",
      "title": "Smart Branch",
      "subtitle": "Digital banking operations and account management",
      "description":
          "Access comprehensive digital banking services including account opening, loan applications, investment management, and real-time transaction monitoring with advanced security features.",
      "route": "/login-screen",
      "gradientColors": [Color(0xFF1B365D), Color(0xFF2E5A8F)],
    },
    {
      "icon": "people",
      "title": "Agency Banking",
      "subtitle": "Agent-powered banking services",
      "description":
          "Empower banking agents to provide essential financial services to customers in remote locations, including cash deposits, withdrawals, bill payments, and account inquiries with secure authentication.",
      "route": "/agency-banking-dashboard",
      "gradientColors": [Color(0xFF2E8B8B), Color(0xFF3FA5A5)],
    },
    {
      "icon": "store",
      "title": "Merchant Banking",
      "subtitle": "Payment and collection solutions",
      "description":
          "Complete merchant payment processing platform with QR code payments, invoice generation, sales analytics, inventory management, and multi-channel payment acceptance for growing businesses.",
      "route": "/login-screen",
      "gradientColors": [Color(0xFF059669), Color(0xFF10B981)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _carouselItems.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onDotTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _showServiceInfo(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceInfoBottomSheet(service: service),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _showSettingsDrawer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsDrawer(),
    );
  }

  Widget _buildSettingsDrawer() {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Settings',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          ListTile(
            leading: CustomIconWidget(
              iconName: _isDarkMode ? 'dark_mode' : 'light_mode',
              color: theme.colorScheme.primary,
              size: 24,
            ),
            title: Text('Theme Mode', style: theme.textTheme.bodyLarge),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) {
                _toggleTheme();
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'security',
              color: theme.colorScheme.primary,
              size: 24,
            ),
            title: Text('Security Settings', style: theme.textTheme.bodyLarge),
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'info',
              color: theme.colorScheme.primary,
              size: 24,
            ),
            title: Text('App Information', style: theme.textTheme.bodyLarge),
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onTap: () {
              Navigator.pop(context);
              _showAppInfo();
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _showAppInfo() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('BankingSuperApp', style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0', style: theme.textTheme.bodyMedium),
            SizedBox(height: 1.h),
            Text(
              'Enterprise-grade mobile banking platform',
              style: theme.textTheme.bodySmall,
            ),
            SizedBox(height: 2.h),
            Text(
              '© 2026 BankingSuperApp. All rights reserved.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Exit'),
              ),
            ],
          ),
        );

        if (shouldExit == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: 6.h,
              bottom: 2.h,
              left: 4.w,
              right: 4.w,
            ),
            child: Column(
              children: [
                _buildHeader(theme),
                SizedBox(height: 3.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ServiceCarouselWidget(
                          items: _carouselItems,
                          pageController: _pageController,
                          currentPage: _currentPage,
                          onPageChanged: _onPageChanged,
                          onDotTapped: _onDotTapped,
                        ),
                        SizedBox(height: 4.h),
                        _buildServiceCards(theme),
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

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'account_balance',
                  color: theme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BankingSuperApp',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'One App. Three Solutions',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: CustomIconWidget(
                iconName: 'settings',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              onPressed: _showSettingsDrawer,
              tooltip: 'Settings',
            ),
            SizedBox(width: 2.w),
            CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: CustomIconWidget(
                iconName: 'person',
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCards(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            'Select Banking Service',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _serviceCards.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            return ServiceCardWidget(
              service: _serviceCards[index],
              onTap: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(_serviceCards[index]["route"] as String);
              },
              onLongPress: () => _showServiceInfo(_serviceCards[index]),
            );
          },
        ),
      ],
    );
  }
}
