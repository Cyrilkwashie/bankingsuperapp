import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SmartBranchAllServicesScreen extends StatefulWidget {
  const SmartBranchAllServicesScreen({super.key});

  @override
  State<SmartBranchAllServicesScreen> createState() =>
      _SmartBranchAllServicesScreenState();
}

class _SmartBranchAllServicesScreenState
    extends State<SmartBranchAllServicesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const Color _navy = Color(0xFF1B365D);
  static const Color _blue = Color(0xFF2563EB);

  final List<_ServiceCategory> _categories = const [
    _ServiceCategory(
      title: 'Customer Management',
      subtitle: 'Onboard & update customers',
      gradient: [Color(0xFF1B365D), Color(0xFF264A85)],
      services: [
        _ServiceItem(icon: 'person_add', label: 'Individual Acct'),
        _ServiceItem(icon: 'edit', label: 'Customer Update'),
      ],
    ),
    _ServiceCategory(
      title: 'Account Management',
      subtitle: 'Statements, cards & cheques',
      gradient: [Color(0xFF6366F1), Color(0xFF4F46E5)],
      services: [
        _ServiceItem(icon: 'description', label: 'Statement'),
        _ServiceItem(icon: 'lock', label: 'Lien'),
        _ServiceItem(icon: 'refresh', label: 'Reactivation'),
        _ServiceItem(icon: 'cancel', label: 'Close Account'),
        _ServiceItem(icon: 'block', label: 'Account Block'),
        _ServiceItem(icon: 'book', label: 'Cheque Book'),
        _ServiceItem(icon: 'credit_card', label: 'ATM Cards'),
        _ServiceItem(icon: 'stop', label: 'Stop Cheque'),
      ],
    ),
    _ServiceCategory(
      title: 'Teller Activities',
      subtitle: 'Cash & cheque operations',
      gradient: [Color(0xFF10B981), Color(0xFF059669)],
      services: [
        _ServiceItem(icon: 'arrow_upward', label: 'Cash Withdrawal'),
        _ServiceItem(icon: 'arrow_downward', label: 'Cash Deposit'),
        _ServiceItem(icon: 'receipt', label: 'Cheque W/drawal'),
        _ServiceItem(icon: 'receipt_long', label: 'Counter Cheque'),
      ],
    ),
    _ServiceCategory(
      title: 'Back Office',
      subtitle: 'Fixed deposits, credit & batch',
      gradient: [Color(0xFFF59E0B), Color(0xFFD97706)],
      services: [
        _ServiceItem(icon: 'savings', label: 'Fixed Deposit'),
        _ServiceItem(icon: 'account_balance', label: 'Credit'),
        _ServiceItem(icon: 'post_add', label: 'Batch Posting'),
        _ServiceItem(icon: 'upload_file', label: 'Uploads'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<_ServiceCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categories;
    return _categories
        .map((cat) {
          final filtered = cat.services
              .where((s) =>
                  s.label.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();
          if (filtered.isEmpty) return null;
          return _ServiceCategory(
            title: cat.title,
            subtitle: cat.subtitle,
            gradient: cat.gradient,
            services: filtered,
          );
        })
        .whereType<_ServiceCategory>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = _filteredCategories;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeIn,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Premium Header ──
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF111D2E), const Color(0xFF0D1117)]
                        : [_navy, _blue],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.5.h),
                        child: Row(
                          children: [
                            _buildBackButton(),
                            SizedBox(width: 3.5.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'All Services',
                                    style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  SizedBox(height: 0.2.h),
                                  Text(
                                    '${_categories.fold<int>(0, (sum, c) => sum + c.services.length)} services available',
                                    style: GoogleFonts.inter(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Colors.white.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.tune_rounded,
                                  color: Colors.white70,
                                  size: 19,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5.w, right: 5.w, bottom: 2.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.5.w, vertical: 0.2.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.18),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                color: Colors.white.withValues(alpha: 0.5),
                                size: 20,
                              ),
                              SizedBox(width: 2.5.w),
                              Expanded(
                                child: Theme(
                                  data: ThemeData(
                                    textSelectionTheme: const TextSelectionThemeData(
                                      cursorColor: Colors.white,
                                      selectionColor: Color(0x55FFFFFF),
                                      selectionHandleColor: Colors.white70,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (v) =>
                                        setState(() => _searchQuery = v),
                                    cursorColor: Colors.white,
                                    style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Search services...',
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 10.sp,
                                        color: Colors.white
                                            .withValues(alpha: 0.4),
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 1.h),
                                    ),
                                  ),
                                ),
                              ),
                              if (_searchQuery.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white
                                        .withValues(alpha: 0.5),
                                    size: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 2.h)),

            // ── Categories ──
            if (categories.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 48,
                            color: isDark
                                ? Colors.white24
                                : const Color(0xFFD1D5DB)),
                        SizedBox(height: 1.5.h),
                        Text(
                          'No services found',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.white38
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...categories.asMap().entries.expand((entry) {
                final cat = entry.value;
                return [
                  SliverToBoxAdapter(
                    child:
                        _buildCategoryCard(context, cat, isDark),
                  ),
                ];
              }),

            SliverToBoxAdapter(child: SizedBox(height: 4.h)),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 19,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    _ServiceCategory category,
    bool isDark,
  ) {
    final gradientStart = category.gradient[0];

    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161B22) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE5E7EB),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : gradientStart.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 4.w, vertical: 1.4.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    gradientStart.withValues(
                        alpha: isDark ? 0.12 : 0.06),
                    Colors.transparent,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: category.gradient,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: gradientStart.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        category.title[0],
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
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
                          category.title,
                          style: GoogleFonts.inter(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF111827),
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 0.15.h),
                        Text(
                          category.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 7.5.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.45)
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.5.w, vertical: 0.4.h),
                    decoration: BoxDecoration(
                      color: gradientStart.withValues(
                          alpha: isDark ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${category.services.length}',
                      style: GoogleFonts.inter(
                        fontSize: 7.5.sp,
                        fontWeight: FontWeight.w600,
                        color: gradientStart,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.5,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : const Color(0xFFF3F4F6),
            ),
            // Services grid
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.w, vertical: 1.5.h),
              child: Wrap(
                spacing: 0,
                runSpacing: 1.2.h,
                children: category.services.map((service) {
                  return SizedBox(
                    width: (100.w - 10.w - 6.w) / 4,
                    child: _buildServiceItem(
                      context,
                      service,
                      gradientStart,
                      isDark,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context,
    _ServiceItem service,
    Color color,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${service.label} — Coming Soon',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: isDark
                ? const Color(0xFF1E2328)
                : const Color(0xFF1F2937),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.12 : 0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: color.withValues(alpha: isDark ? 0.18 : 0.12),
                width: 1,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: service.icon,
                color: color,
                size: 22,
              ),
            ),
          ),
          SizedBox(height: 0.7.h),
          Text(
            service.label,
            style: GoogleFonts.inter(
              fontSize: 7.5.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.75)
                  : const Color(0xFF4B5563),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ServiceCategory {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final List<_ServiceItem> services;

  const _ServiceCategory({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.services,
  });
}

class _ServiceItem {
  final String icon;
  final String label;

  const _ServiceItem({required this.icon, required this.label});
}
