import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

part 'open_account_personal_screen.dart';
part 'open_account_id_contact_screen.dart';
part 'open_account_requirements_screen.dart';
part 'open_account_review_screen.dart';
part 'open_account_success_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Agency Open Account – Account Type Selection ──
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

  int _selectedTypeIndex = -1;

  static const List<_AccountTypeOption> _accountTypes = [
    _AccountTypeOption(
      icon: Icons.savings_rounded,
      title: 'Savings Account',
      subtitle: 'Earn interest on deposits with flexible access to funds',
      badge: 'Popular',
      minDeposit: 'GH₵ 20.00',
    ),
    _AccountTypeOption(
      icon: Icons.account_balance_rounded,
      title: 'Current Account',
      subtitle: 'Ideal for daily transactions with cheque-book facility',
      badge: 'Business',
      minDeposit: 'GH₵ 50.00',
    ),
    _AccountTypeOption(
      icon: Icons.lock_clock_rounded,
      title: 'Fixed Deposit',
      subtitle: 'Higher returns on locked funds for a fixed period',
      badge: 'High Yield',
      minDeposit: 'GH₵ 500.00',
    ),
    _AccountTypeOption(
      icon: Icons.child_care_rounded,
      title: 'Susu Account',
      subtitle: 'Daily micro-savings designed for market traders & artisans',
      badge: 'Micro',
      minDeposit: 'GH₵ 5.00',
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
    return GestureDetector(
      onTap: () => setState(() => _selectedTypeIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: selected
              ? _accent.withValues(alpha: isDark ? 0.12 : 0.06)
              : (isDark ? const Color(0xFF161B22) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? _accent.withValues(alpha: 0.5)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFE5E7EB)),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected
                    ? _accent.withValues(alpha: 0.15)
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF3F4F6)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(
                  type.icon,
                  color: selected
                      ? _accent
                      : (isDark
                          ? Colors.white38
                          : const Color(0xFF9CA3AF)),
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 3.5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          type.title,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF111827),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.3.h),
                        decoration: BoxDecoration(
                          color: selected
                              ? _accent.withValues(alpha: 0.15)
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : const Color(0xFFF3F4F6)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          type.badge,
                          style: GoogleFonts.inter(
                            fontSize: 6.5.sp,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? _accent
                                : (isDark
                                    ? Colors.white38
                                    : const Color(0xFF9CA3AF)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.4.h),
                  Text(
                    type.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 8.sp,
                      color: isDark
                          ? Colors.white38
                          : const Color(0xFF9CA3AF),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 0.6.h),
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet_outlined,
                          size: 12,
                          color: isDark
                              ? Colors.white24
                              : const Color(0xFFD1D5DB)),
                      SizedBox(width: 1.w),
                      Text(
                        'Min. deposit: ${type.minDeposit}',
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white24
                              : const Color(0xFFD1D5DB),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? _accent
                    : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? _accent
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.15)
                          : const Color(0xFFD1D5DB)),
                  width: selected ? 0 : 1.5,
                ),
              ),
              child: selected
                  ? const Center(
                      child: Icon(Icons.check_rounded,
                          color: Colors.white, size: 14))
                  : null,
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
                      'Agency Banking',
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
  final String title;
  final String subtitle;
  final String badge;
  final String minDeposit;

  const _AccountTypeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.minDeposit,
  });
}
