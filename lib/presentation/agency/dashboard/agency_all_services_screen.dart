import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AgencyAllServicesScreen extends StatefulWidget {
  const AgencyAllServicesScreen({super.key});

  @override
  State<AgencyAllServicesScreen> createState() =>
      _AgencyAllServicesScreenState();
}

class _AgencyAllServicesScreenState extends State<AgencyAllServicesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  static const Color _accent = Color(0xFF2E8B8B);

  final List<_ServiceCategory> _categories = const [
    _ServiceCategory(
      title: 'Cash Services',
      subtitle: 'Deposits & withdrawals',
      color: Color(0xFF10B981),
      icon: 'account_balance_wallet',
      services: [
        _ServiceItem(icon: 'add_circle', label: 'Cash Deposit'),
        _ServiceItem(icon: 'remove_circle', label: 'Cash Withdrawal'),
      ],
    ),
    _ServiceCategory(
      title: 'Transfers',
      subtitle: 'Move money seamlessly',
      color: Color(0xFF6366F1),
      icon: 'swap_horiz',
      services: [
        _ServiceItem(icon: 'account_balance', label: 'Same Bank'),
        _ServiceItem(icon: 'send', label: 'Other Bank'),
      ],
    ),
    _ServiceCategory(
      title: 'QR Services',
      subtitle: 'Scan & pay instantly',
      color: Color(0xFF8B5CF6),
      icon: 'qr_code_scanner',
      services: [
        _ServiceItem(icon: 'qr_code_scanner', label: 'QR Deposit'),
        _ServiceItem(icon: 'qr_code', label: 'QR Withdraw'),
      ],
    ),
    _ServiceCategory(
      title: 'Account Services',
      subtitle: 'Manage customer accounts',
      color: Color(0xFF0EA5E9),
      icon: 'person',
      services: [
        _ServiceItem(icon: 'person_add', label: 'Open Account'),
        _ServiceItem(icon: 'account_balance_wallet', label: 'Balance Enquiry'),
        _ServiceItem(icon: 'receipt', label: 'Mini Statement'),
      ],
    ),
    _ServiceCategory(
      title: 'Account Requests',
      subtitle: 'Cards, cheques & more',
      color: Color(0xFFF59E0B),
      icon: 'credit_card',
      services: [
        _ServiceItem(icon: 'description', label: 'Full Statement'),
        _ServiceItem(icon: 'credit_card', label: 'ATM Card'),
        _ServiceItem(icon: 'book', label: 'Cheque Book'),
        _ServiceItem(icon: 'block', label: 'Block Card'),
        _ServiceItem(icon: 'cancel', label: 'Stop Cheque'),
      ],
    ),
    _ServiceCategory(
      title: 'Agent Tools',
      subtitle: 'Operational utilities',
      color: Color(0xFF64748B),
      icon: 'build',
      services: [_ServiceItem(icon: 'undo', label: 'Reverse Txn')],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<_ServiceCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categories;
    return _categories
        .map((cat) {
          final filtered = cat.services
              .where(
                (s) =>
                    s.label.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();
          if (filtered.isEmpty) return null;
          return _ServiceCategory(
            title: cat.title,
            subtitle: cat.subtitle,
            color: cat.color,
            icon: cat.icon,
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
    final scaffoldBg = isDark
        ? const Color(0xFF0D1117)
        : const Color(0xFFF8FAFC);

    // Compute scroll offsets for tap-to-scroll
    final gridWidth = 100.w - 8.w;
    final cellWidth = gridWidth / 4;
    final cellHeight = cellWidth / 0.78;
    final headerH = 7.2.h;
    List<double> offsets = [];
    double cumulative = 0;
    for (final cat in categories) {
      offsets.add(cumulative);
      final rows = (cat.services.length / 4).ceil();
      cumulative += headerH + rows * cellHeight;
    }

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: FadeTransition(
        opacity: _fadeIn,
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── Empty State ──
                  if (categories.isEmpty)
                    SliverToBoxAdapter(child: _buildEmptyState(isDark)),

                  // ── Sticky Category Sections ──
                  if (categories.isNotEmpty)
                    ...categories.asMap().entries.expand((entry) {
                      final i = entry.key;
                      final cat = entry.value;
                      return [
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _CategoryHeaderDelegate(
                            title: cat.title,
                            subtitle: cat.subtitle,
                            accentColor: cat.color,
                            categoryIcon: cat.icon,
                            isDark: isDark,
                            scaffoldBg: scaffoldBg,
                            expandedHeight: 7.2.h,
                            collapsedHeight: 5.4.h,
                            onTap: () {
                              final collapsedH = 5.4.h;
                              final target = (offsets[i] - i * collapsedH)
                                  .clamp(
                                    0.0,
                                    _scrollController.position.maxScrollExtent,
                                  );
                              _scrollController.animateTo(
                                target,
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeOutCubic,
                              );
                            },
                          ),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.78,
                                  mainAxisSpacing: 0,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildServiceItem(
                                context,
                                cat.services[index],
                                cat.color,
                                isDark,
                                index,
                              ),
                              childCount: cat.services.length,
                            ),
                          ),
                        ),
                      ];
                    }),

                  SliverToBoxAdapter(child: SizedBox(height: 60.h)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : [const Color(0xFF1B365D), _accent],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
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
                            color: Colors.white.withValues(alpha: 0.6),
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
                        color: Colors.white.withValues(alpha: 0.08),
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
            // Search bar
            Padding(
              padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.h),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.5.w,
                  vertical: 0.2.h,
                ),
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
                          onChanged: (v) => setState(() => _searchQuery = v),
                          cursorColor: Colors.white,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search services...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 1.h),
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
                          color: Colors.white.withValues(alpha: 0.5),
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
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: const Center(
          child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 19),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
            ),
            SizedBox(height: 1.5.h),
            Text(
              'No services found',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Service Item ──
  Widget _buildServiceItem(
    BuildContext context,
    _ServiceItem service,
    Color color,
    bool isDark,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 60)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          if (service.label == 'Cash Deposit') {
            Navigator.of(context).pushNamed(AppRoutes.agencyCashDeposit);
            return;
          }
          if (service.label == 'Cash Withdrawal') {
            Navigator.of(context).pushNamed(AppRoutes.agencyCashWithdrawal);
            return;
          }
          if (service.label == 'Same Bank') {
            Navigator.of(context).pushNamed(AppRoutes.agencySameBankTransfer);
            return;
          }
          if (service.label == 'Other Bank') {
            Navigator.of(context).pushNamed(AppRoutes.agencyOtherBankTransfer);
            return;
          }
          if (service.label == 'QR Deposit') {
            Navigator.of(context).pushNamed(AppRoutes.agencyQrDeposit);
            return;
          }
          if (service.label == 'QR Withdraw') {
            Navigator.of(context).pushNamed(AppRoutes.agencyQrWithdrawal);
            return;
          }
          if (service.label == 'Full Statement') {
            Navigator.of(context).pushNamed(AppRoutes.agencyFullStatement);
            return;
          }
          if (service.label == 'ATM Card') {
            Navigator.of(context).pushNamed(AppRoutes.agencyAtmCard);
            return;
          }
          if (service.label == 'Cheque Book') {
            Navigator.of(context).pushNamed(AppRoutes.agencyChequeBook);
            return;
          }
          if (service.label == 'Block Card') {
            Navigator.of(context).pushNamed(AppRoutes.agencyBlockCard);
            return;
          }
          if (service.label == 'Stop Cheque') {
            Navigator.of(context).pushNamed(AppRoutes.agencyStopCheque);
            return;
          }
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
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.12 : 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: service.icon,
                  color: color,
                  size: 23,
                ),
              ),
            ),
            SizedBox(height: 0.8.h),
            Text(
              service.label,
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : const Color(0xFF374151),
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sticky Category Header Delegate ──
class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String subtitle;
  final Color accentColor;
  final String categoryIcon;
  final bool isDark;
  final Color scaffoldBg;
  final double expandedHeight;
  final double collapsedHeight;
  final VoidCallback? onTap;

  _CategoryHeaderDelegate({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.categoryIcon,
    required this.isDark,
    required this.scaffoldBg,
    required this.expandedHeight,
    required this.collapsedHeight,
    this.onTap,
  });

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final isPinned = overlapsContent || progress > 0.05;

    // Subtle tint of accent color when pinned
    final bgColor =
        Color.lerp(scaffoldBg, accentColor, 0.018 * progress) ?? scaffoldBg;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: isPinned
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: isDark ? 0.08 : 0.06),
                    blurRadius: 8 * progress,
                    offset: Offset(0, 2 * progress),
                  ),
                ]
              : null,
          border: Border(
            bottom: BorderSide(
              color: accentColor.withValues(alpha: 0.08 + 0.10 * progress),
              width: 0.5 + progress,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            children: [
              // Animated accent bar
              Container(
                width: 3.5,
                height: 28 - 8 * progress,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [accentColor, accentColor.withValues(alpha: 0.5)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: (10.5 - 0.5 * progress).sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (progress < 0.7) ...[
                      SizedBox(height: 0.15.h),
                      Opacity(
                        opacity: (1 - progress * 1.5).clamp(0.0, 1.0),
                        child: Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 7.5.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? Colors.white38
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Small icon badge
              Container(
                width: 28 - 4 * progress,
                height: 28 - 4 * progress,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: categoryIcon,
                    color: accentColor,
                    size: 15 - 2 * progress,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _CategoryHeaderDelegate oldDelegate) {
    return title != oldDelegate.title ||
        subtitle != oldDelegate.subtitle ||
        accentColor != oldDelegate.accentColor ||
        isDark != oldDelegate.isDark ||
        scaffoldBg != oldDelegate.scaffoldBg;
  }
}

class _ServiceCategory {
  final String title;
  final String subtitle;
  final Color color;
  final String icon;
  final List<_ServiceItem> services;

  const _ServiceCategory({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.services,
  });
}

class _ServiceItem {
  final String icon;
  final String label;

  const _ServiceItem({required this.icon, required this.label});
}
