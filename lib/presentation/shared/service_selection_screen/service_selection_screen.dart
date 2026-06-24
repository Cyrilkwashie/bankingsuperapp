import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../models/banking_service_type.dart';
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

  final List<Map<String, dynamic>> _carouselItems = [
    {
      "serviceId": BankingServiceType.smartBranch,
      "title": "Smart Branch",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_16d5b7740-1766841180313.png",
      "semanticLabel":
          "Modern banking office interior with digital screens displaying financial data and comfortable seating areas",
    },
    {
      "serviceId": BankingServiceType.agency,
      "title": "Agency Banking",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1dbceb335-1766845727744.png",
      "semanticLabel":
          "Professional banking agent assisting customer with mobile banking services at a service counter",
    },
    {
      "serviceId": BankingServiceType.merchant,
      "title": "Merchant Banking",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_15a8f6ab7-1769689328768.png",
      "semanticLabel":
          "Small business owner using point-of-sale terminal to process customer payment in modern retail store",
    },
  ];

  final List<Map<String, dynamic>> _allServiceCards = [
    {
      "serviceId": BankingServiceType.smartBranch,
      "icon": "account_balance",
      "title": "Smart Branch",
      "subtitle": "Digital banking operations and account management",
      "description":
          "Access comprehensive digital banking services including account opening, loan applications, investment management, and real-time transaction monitoring with advanced security features.",
      "route": AppRoutes.smartBranchLogin,
      "gradientColors": [Color(0xFF1B365D), Color(0xFF2E5A8F)],
    },
    {
      "serviceId": BankingServiceType.agency,
      "icon": "people",
      "title": "Agency Banking",
      "subtitle": "Agent-powered banking services",
      "description":
          "Empower banking agents to provide essential financial services to customers in remote locations, including cash deposits, withdrawals, bill payments, and account inquiries with secure authentication.",
      "route": AppRoutes.agencyLogin,
      "gradientColors": [Color(0xFF2E8B8B), Color(0xFF3FA5A5)],
    },
    {
      "serviceId": BankingServiceType.merchant,
      "icon": "store",
      "title": "Merchant Banking",
      "subtitle": "Payment and collection solutions",
      "description":
          "Complete merchant payment processing platform with QR code payments, invoice generation, sales analytics, inventory management, and multi-channel payment acceptance for growing businesses.",
      "route": AppRoutes.merchantLogin,
      "gradientColors": [Color(0xFF059669), Color(0xFF10B981)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _openService(Map<String, dynamic> service) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed(service['route'] as String);
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final items = _carouselItems;
      if (items.isEmpty || !_pageController.hasClients) return;

      final nextPage = (_currentPage + 1) % items.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
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
              top: 1.h,
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
                          carouselItems: _carouselItems,
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
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'F',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fieldsmart',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? const Color(0xFFFAFBFC)
                      : const Color(0xFF1A1D23),
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 0.2.h),
              Text(
                'Select a banking service to continue',
                style: GoogleFonts.inter(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
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
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'Select Banking Service',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFFFAFBFC)
                      : const Color(0xFF1A1D23),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.5.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _allServiceCards.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
          itemBuilder: (context, index) {
            final service = _allServiceCards[index];
            return ServiceCardWidget(
              service: service,
              onTap: () => _openService(service),
              onLongPress: () => _showServiceInfo(service),
            );
          },
        ),
      ],
    );
  }
}
