part of 'agency_block_card_screen.dart';

class _BlockCardConfirmationScreen extends StatelessWidget {
  final String accountNo;
  final String accountName;
  final String cardType;
  final String cardNumber;
  final String reason;
  final Color accentColor;
  final List<Color> gradientColors;

  const _BlockCardConfirmationScreen({
    required this.accountNo,
    required this.accountName,
    required this.cardType,
    required this.cardNumber,
    required this.reason,
    required this.accentColor,
    required this.gradientColors,
  });

  static const Color _blocked = Color(0xFFDC2626);

  String get _maskedCardNumber {
    if (cardNumber.length < 8) return cardNumber;
    return '${cardNumber.substring(0, 4)} •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0D1117)
          : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(context, isDark),
          _buildStepIndicator(isDark),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
              child: Column(
                children: [
                  _buildIntroTip(isDark),
                  SizedBox(height: 1.5.h),
                  _buildSectionCard(
                    isDark: isDark,
                    title: 'Blocked Card Preview',
                    subtitle: 'Review the card to be permanently blocked',
                    icon: Icons.credit_card_off_rounded,
                    child: _buildBlockedCardIllustration(isDark),
                  ),
                  SizedBox(height: 1.5.h),
                  _buildSectionCard(
                    isDark: isDark,
                    title: 'Block Details',
                    subtitle: 'Confirm all information before proceeding',
                    icon: Icons.receipt_long_outlined,
                    child: _buildDetailsContent(isDark),
                  ),
                  SizedBox(height: 1.5.h),
                  _buildFinalWarning(isDark),
                ],
              ),
            ),
          ),
          _buildStickyActions(context, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : gradientColors,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
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
              ),
              SizedBox(width: 3.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirm Block',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Agency Banking · Step 3 of 3',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color: Colors.white.withValues(alpha: 0.6),
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

  Widget _buildStepIndicator(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.4.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          _stepDot(1, 'Details', isDark, completed: true),
          _stepConnector(isDark),
          _stepDot(2, 'Verify', isDark, completed: true),
          _stepConnector(isDark),
          _stepDot(3, 'Confirm', isDark, completed: false, isCurrent: true),
        ],
      ),
    );
  }

  Widget _stepConnector(bool isDark) {
    return Expanded(
      child: Container(
        height: 2,
        margin: EdgeInsets.only(bottom: 2.2.h, left: 1.w, right: 1.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: LinearGradient(
            colors: [accentColor, accentColor.withValues(alpha: 0.5)],
          ),
        ),
      ),
    );
  }

  Widget _stepDot(
    int step,
    String label,
    bool isDark, {
    required bool completed,
    bool isCurrent = false,
  }) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed || isCurrent ? accentColor : null,
            border: completed || isCurrent
                ? null
                : Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : const Color(0xFFD1D5DB),
                  ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: completed && !isCurrent
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                : Text(
                    '$step',
                    style: GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                      color: isCurrent
                          ? Colors.white
                          : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
                    ),
                  ),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 7.sp,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
            color: isCurrent || completed
                ? accentColor
                : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
          ),
        ),
      ],
    );
  }

  Widget _buildIntroTip(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _blocked.withValues(alpha: isDark ? 0.12 : 0.06),
            _blocked.withValues(alpha: isDark ? 0.04 : 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _blocked.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: _blocked, size: 15),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Text(
              'Review the card details below. Once blocked, this card cannot be unblocked.',
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                height: 1.35,
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required bool isDark,
    required String title,
    String? subtitle,
    IconData? icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: accentColor, size: 15),
                ),
                SizedBox(width: 2.5.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 0.1.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.3.h),
          child,
        ],
      ),
    );
  }

  Widget _buildBlockedCardIllustration(bool isDark) {
    return Container(
      width: double.infinity,
      height: 18.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF374151), Color(0xFF1F2937)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF374151).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CustomPaint(painter: _BlockedStripePainter()),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'UTB',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.5.w,
                        vertical: 0.35.h,
                      ),
                      decoration: BoxDecoration(
                        color: _blocked,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'BLOCKED',
                        style: GoogleFonts.inter(
                          fontSize: 6.5.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 32,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B7280),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 1.2.h),
                Text(
                  _maskedCardNumber,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.6),
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  accountName.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.5),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _blocked.withValues(alpha: 0.85),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.block_rounded, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsContent(bool isDark) {
    return Column(
      children: [
        _detailRow('Account Number', accountNo, isDark),
        _divider(isDark),
        _detailRow('Account Name', accountName, isDark),
        _divider(isDark),
        _detailRow('Card Type', cardType, isDark),
        _divider(isDark),
        _detailRow('Card Number', _maskedCardNumber, isDark, mono: true),
        _divider(isDark),
        _detailRow(
          'Reason',
          reason,
          isDark,
          valueColor: _blocked,
        ),
      ],
    );
  }

  Widget _detailRow(
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    bool mono = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.55.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: mono
                  ? GoogleFonts.jetBrainsMono(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w500,
                      color: valueColor ??
                          (isDark ? Colors.white : const Color(0xFF111827)),
                    )
                  : GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: valueColor ??
                          (isDark ? Colors.white : const Color(0xFF111827)),
                    ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark
          ? Colors.white.withValues(alpha: 0.05)
          : const Color(0xFFF3F4F6),
    );
  }

  Widget _buildFinalWarning(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark
            ? _blocked.withValues(alpha: 0.08)
            : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _blocked.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: _blocked, size: 16),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Text(
              'This action is permanent. The customer will need to request a new card.',
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                height: 1.35,
                color: isDark ? Colors.white54 : const Color(0xFF991B1B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyActions(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 1.4.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE5E7EB),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showTransactionAuthBottomSheet(
                  context: context,
                  accentColor: accentColor,
                  title: 'Authorize Card Block',
                  onAuthenticated: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => _BlockCardSuccessScreen(
                          cardType: cardType,
                          maskedCardNumber: _maskedCardNumber,
                          accountName: accountName,
                          reason: reason,
                          accentColor: accentColor,
                          gradientColors: gradientColors,
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.25.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _blocked.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.block_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 2.w),
                    Text(
                      'Confirm & Block Card',
                      style: GoogleFonts.inter(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 0.8.h),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.6.h),
                child: Text(
                  'Go Back',
                  style: GoogleFonts.inter(
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Blocked Stripe Painter ──
