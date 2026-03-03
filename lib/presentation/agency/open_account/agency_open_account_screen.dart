import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../cash_deposit/agency_cash_deposit_screen.dart';

part 'open_account_personal_screen.dart';
part 'open_account_id_contact_screen.dart';
part 'open_account_requirements_screen.dart';
part 'open_account_review_screen.dart';
part 'open_account_success_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Agency Open Account – Requirements Overview (Entry Screen) ──
// ══════════════════════════════════════════════════════════════

class AgencyOpenAccountScreen extends StatefulWidget {
  const AgencyOpenAccountScreen({super.key});

  @override
  State<AgencyOpenAccountScreen> createState() =>
      _AgencyOpenAccountScreenState();
}

class _AgencyOpenAccountScreenState extends State<AgencyOpenAccountScreen>
    with SingleTickerProviderStateMixin {
  static const Color _accent = Color(0xFF2E8B8B);
  static const List<Color> _gradient = [
    Color(0xFF1B365D),
    Color(0xFF2E8B8B),
  ];

  late AnimationController _animController;
  late Animation<double> _fadeIn;

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
    super.dispose();
  }

  void _onStart() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const _OpenAccountTypeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIntroBanner(isDark),
                    SizedBox(height: 3.h),

                    Text(
                      'What You\'ll Need',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 0.4.h),
                    Text(
                      'Ensure the customer has the following before proceeding.',
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    _buildGroupLabel(
                        'REQUIRED', const Color(0xFF2E8B8B), isDark),
                    SizedBox(height: 1.h),
                    _buildReqCard(
                      icon: Icons.badge_outlined,
                      iconColor: const Color(0xFF2E8B8B),
                      title: 'Valid Government-Issued ID',
                      subtitle:
                          'Ghana Card, Voter ID, Passport or Driver\'s License',
                      isDark: isDark,
                    ),
                    SizedBox(height: 1.2.h),
                    _buildReqCard(
                      icon: Icons.photo_camera_outlined,
                      iconColor: const Color(0xFF2E8B8B),
                      title: 'Passport-Sized Photograph',
                      subtitle:
                          'A recent, clear front-facing photo of the customer',
                      isDark: isDark,
                    ),
                    SizedBox(height: 1.2.h),
                    _buildReqCard(
                      icon: Icons.phone_outlined,
                      iconColor: const Color(0xFF2E8B8B),
                      title: 'Active Phone Number',
                      subtitle:
                          'Ghanaian mobile number for SMS alerts and OTP',
                      isDark: isDark,
                    ),
                    SizedBox(height: 1.2.h),
                    _buildReqCard(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: const Color(0xFF2E8B8B),
                      title: 'Initial Deposit',
                      subtitle:
                          'Minimum amount varies by the selected account type',
                      isDark: isDark,
                    ),
                    SizedBox(height: 2.5.h),

                    _buildGroupLabel(
                        'GOOD TO HAVE', const Color(0xFF7C3AED), isDark),
                    SizedBox(height: 1.h),
                    _buildReqCard(
                      icon: Icons.home_outlined,
                      iconColor: const Color(0xFF7C3AED),
                      title: 'Proof of Address',
                      subtitle:
                          'Recent utility bill, bank statement or tenancy agreement',
                      isDark: isDark,
                      optional: true,
                    ),
                    SizedBox(height: 1.2.h),
                    _buildReqCard(
                      icon: Icons.email_outlined,
                      iconColor: const Color(0xFF7C3AED),
                      title: 'Email Address',
                      subtitle:
                          'For e-statements and digital account notifications',
                      isDark: isDark,
                      optional: true,
                    ),
                    SizedBox(height: 3.h),

                    _buildDurationHint(isDark),
                    SizedBox(height: 3.h),
                    _buildStartButton(isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : _gradient,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: const Center(
                    child: Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 19),
                  ),
                ),
              ),
              SizedBox(width: 3.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Open Account',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Agency Banking · Requirements',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      'Online',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _accent.withValues(alpha: isDark ? 0.12 : 0.07),
            const Color(0xFF1B365D)
                .withValues(alpha: isDark ? 0.08 : 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Icon(Icons.account_balance_rounded,
                  color: _accent, size: 26),
            ),
          ),
          SizedBox(width: 3.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Before You Begin',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  'Review the checklist to ensure a smooth and complete account opening experience.',
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    color: isDark
                        ? Colors.white54
                        : const Color(0xFF6B7280),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupLabel(String label, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 7.5.sp,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildReqCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDark,
    bool optional = false,
  }) {
    return Container(
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 20),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                    ),
                    if (optional)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.8.w, vertical: 0.25.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Optional',
                          style: GoogleFonts.inter(
                            fontSize: 6.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 0.4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    color: isDark
                        ? Colors.white38
                        : const Color(0xFF9CA3AF),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationHint(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            color:
                isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'This process takes approximately 5–10 minutes to complete.',
              style: GoogleFonts.inter(
                fontSize: 8.sp,
                color: isDark
                    ? Colors.white38
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(bool isDark) {
    return GestureDetector(
      onTap: _onStart,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF2E8B8B), Color(0xFF1B6B6B)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E8B8B).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start Application',
              style: GoogleFonts.inter(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 2.w),
            const Icon(Icons.arrow_forward_rounded,
                color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── Select Account Type (Screen 2) ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountTypeScreen extends StatefulWidget {
  const _OpenAccountTypeScreen();

  @override
  State<_OpenAccountTypeScreen> createState() =>
      _OpenAccountTypeScreenState();
}

class _OpenAccountTypeScreenState extends State<_OpenAccountTypeScreen>
    with SingleTickerProviderStateMixin {
  static const Color _accent = Color(0xFF2E8B8B);
  static const List<Color> _gradient = [
    Color(0xFF1B365D),
    Color(0xFF2E8B8B),
  ];

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  int _selectedTypeIndex = -1;

  static const List<_AccountTypeOption> _accountTypes = [
    _AccountTypeOption(
      icon: Icons.savings_rounded,
      iconColor: Color(0xFF2E8B8B),
      title: 'Savings Account',
      subtitle: 'Earn interest on deposits with flexible access to funds',
      badge: 'Popular',
      badgeColor: Color(0xFF059669),
      minDeposit: 'GH₵ 20.00',
      features: [
        'Monthly interest accrual',
        'Unlimited deposits',
        'Flexible withdrawals'
      ],
    ),
    _AccountTypeOption(
      icon: Icons.account_balance_rounded,
      iconColor: Color(0xFF1D4ED8),
      title: 'Current Account',
      subtitle: 'Ideal for daily transactions with cheque-book facility',
      badge: 'Business',
      badgeColor: Color(0xFF1D4ED8),
      minDeposit: 'GH₵ 50.00',
      features: [
        'Cheque-book facility',
        'Overdraft eligible',
        'High transaction volume'
      ],
    ),
    _AccountTypeOption(
      icon: Icons.lock_clock_rounded,
      iconColor: Color(0xFFD97706),
      title: 'Fixed Deposit',
      subtitle: 'Higher returns on locked funds for a fixed term',
      badge: 'High Yield',
      badgeColor: Color(0xFFD97706),
      minDeposit: 'GH₵ 500.00',
      features: [
        'Above-average interest rate',
        'Defined maturity date',
        'Capital guaranteed'
      ],
    ),
    _AccountTypeOption(
      icon: Icons.savings_outlined,
      iconColor: Color(0xFF7C3AED),
      title: 'Susu Account',
      subtitle: 'Daily micro-savings designed for traders and artisans',
      badge: 'Micro-savings',
      badgeColor: Color(0xFF7C3AED),
      minDeposit: 'GH₵ 5.00',
      features: [
        'Daily contribution model',
        'Low entry threshold',
        'Community-friendly'
      ],
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
    super.dispose();
  }

  bool get _canContinue => _selectedTypeIndex >= 0;

  void _onContinue() {
    if (!_canContinue) return;
    final selected = _accountTypes[_selectedTypeIndex];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _OpenAccountPersonalScreen(
          accountType: selected.title,
          minDeposit: selected.minDeposit,
          accentColor: _accent,
          gradientColors: _gradient,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section title
                    Text(
                      'Select Account Type',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Choose the type of account to open for the customer.',
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 2.5.h),

                    // Account type cards
                    ...List.generate(_accountTypes.length, (i) {
                      final t = _accountTypes[i];
                      final selected = _selectedTypeIndex == i;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 1.5.h),
                        child: _buildAccountTypeCard(
                            t, selected, i, isDark),
                      );
                    }),

                    SizedBox(height: 1.h),

                    // Info box
                    Container(
                      padding: EdgeInsets.all(3.5.w),
                      decoration: BoxDecoration(
                        color: _accent.withValues(
                            alpha: isDark ? 0.08 : 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _accent.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              color: _accent, size: 18),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'The customer will need to provide valid identification, personal details, and an initial deposit to complete the account opening.',
                              style: GoogleFonts.inter(
                                fontSize: 7.5.sp,
                                color: isDark
                                    ? Colors.white54
                                    : const Color(0xFF6B7280),
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Continue button
                    _buildContinueButton(isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTypeCard(
    _AccountTypeOption type,
    bool selected,
    int index,
    bool isDark,
  ) {
    final accent = type.iconColor;
    return GestureDetector(
      onTap: () => setState(() => _selectedTypeIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: selected
              ? accent.withValues(alpha: isDark ? 0.10 : 0.05)
              : (isDark ? const Color(0xFF161B22) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? accent.withValues(alpha: 0.45)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFE5E7EB)),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: selected
                        ? accent.withValues(alpha: 0.15)
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : const Color(0xFFF3F4F6)),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(
                    child: Icon(
                      type.icon,
                      color: selected
                          ? accent
                          : (isDark
                              ? Colors.white38
                              : const Color(0xFF9CA3AF)),
                      size: 22,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.title,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        type.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 7.5.sp,
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFF9CA3AF),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? accent : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? accent
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.15)
                              : const Color(0xFFD1D5DB)),
                      width: selected ? 0 : 1.5,
                    ),
                  ),
                  child: selected
                      ? const Center(
                          child: Icon(Icons.check_rounded,
                              color: Colors.white, size: 13),
                        )
                      : null,
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            // Feature chips
            Wrap(
              spacing: 1.5.w,
              runSpacing: 0.6.h,
              children: type.features
                  .map(
                    (f) => Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.2.w, vertical: 0.4.h),
                      decoration: BoxDecoration(
                        color: selected
                            ? accent.withValues(alpha: 0.1)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.04)
                                : const Color(0xFFF3F4F6)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        f,
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w500,
                          color: selected
                              ? accent
                              : (isDark
                                  ? Colors.white38
                                  : const Color(0xFF9CA3AF)),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 2.w, vertical: 0.3.h),
                  decoration: BoxDecoration(
                    color: selected
                        ? type.badgeColor.withValues(alpha: 0.12)
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : const Color(0xFFF3F4F6)),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: selected
                          ? type.badgeColor.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    type.badge,
                    style: GoogleFonts.inter(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? type.badgeColor
                          : (isDark
                              ? Colors.white38
                              : const Color(0xFF9CA3AF)),
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.account_balance_wallet_outlined,
                    size: 13,
                    color: selected
                        ? type.iconColor.withValues(alpha: 0.75)
                        : (isDark
                            ? Colors.white54
                            : const Color(0xFF6B7280))),
                SizedBox(width: 1.w),
                Text(
                  'Min. deposit: ${type.minDeposit}',
                  style: GoogleFonts.inter(
                    fontSize: 7.5.sp,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? type.iconColor.withValues(alpha: 0.85)
                        : (isDark
                            ? Colors.white54
                            : const Color(0xFF6B7280)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(bool isDark) {
    return GestureDetector(
      onTap: _canContinue ? _onContinue : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          gradient: _canContinue
              ? const LinearGradient(
                  colors: [Color(0xFF2E8B8B), Color(0xFF1B6B6B)])
              : null,
          color: _canContinue
              ? null
              : (isDark
                  ? const Color(0xFF1E2328)
                  : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(14),
          boxShadow: _canContinue
              ? [
                  BoxShadow(
                    color: const Color(0xFF2E8B8B)
                        .withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue',
              style: GoogleFonts.inter(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: _canContinue
                    ? Colors.white
                    : (isDark
                        ? Colors.white24
                        : const Color(0xFF9CA3AF)),
              ),
            ),
            SizedBox(width: 2.w),
            Icon(
              Icons.arrow_forward_rounded,
              color: _canContinue
                  ? Colors.white
                  : (isDark
                      ? Colors.white24
                      : const Color(0xFF9CA3AF)),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : _gradient,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 5.w, vertical: 1.8.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color:
                            Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: const Center(
                    child: Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 19),
                  ),
                ),
              ),
              SizedBox(width: 3.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Type',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Open Account · Step 1 of 4',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color:
                            Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color:
                          Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      'Online',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Account Type Model ────────────────────────────────────────

class _AccountTypeOption {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final String minDeposit;
  final List<String> features;

  const _AccountTypeOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.minDeposit,
    required this.features,
  });
}
