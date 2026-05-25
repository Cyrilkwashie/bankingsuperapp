part of 'agency_atm_card_screen.dart';

class _AtmCardConfirmationScreen extends StatelessWidget {
  final String accountNo;
  final String accountName;
  final String cardType;
  final String displayName;
  final String pickupBranch;
  final Color accentColor;
  final List<Color> gradientColors;

  const _AtmCardConfirmationScreen({
    required this.accountNo,
    required this.accountName,
    required this.cardType,
    required this.displayName,
    required this.pickupBranch,
    required this.accentColor,
    required this.gradientColors,
  });

  double get _charges {
    if (cardType.contains('Gold')) return 50.00;
    if (cardType.contains('GHLink')) return 15.00;
    return 30.00;
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
                  _buildCardPreview(isDark),
                  SizedBox(height: 1.5.h),
                  _buildDetailsSectionCard(isDark),
                  SizedBox(height: 1.5.h),
                  _buildChargesSectionCard(isDark),
                  SizedBox(height: 1.5.h),
                  _buildSecurityNote(isDark),
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
                      'Confirm Request',
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
          _stepDot(1, 'Request', isDark, completed: true),
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
            child: completed
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

  Widget _buildCardPreview(bool isDark) {
    Color cardColor;
    String brandLabel;
    if (cardType.contains('Visa')) {
      cardColor = const Color(0xFF1A1F71);
      brandLabel = 'VISA';
    } else if (cardType.contains('MasterCard')) {
      cardColor = const Color(0xFFEB001B);
      brandLabel = 'MASTERCARD';
    } else {
      cardColor = const Color(0xFF2E8B8B);
      brandLabel = 'GHLINK';
    }

    return Container(
      width: double.infinity,
      height: 22.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cardColor, cardColor.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'UTB',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      brandLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 26,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      Icons.contactless_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 22,
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Text(
                  '•••• •••• •••• ••••',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  displayName,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSectionCard(bool isDark) {
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
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.receipt_long_outlined, color: accentColor, size: 15),
              ),
              SizedBox(width: 2.5.w),
              Text(
                'Request Details',
                style: GoogleFonts.inter(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.3.h),
          _detailRow('Account Number', accountNo, isDark),
          _divider(isDark),
          _detailRow('Account Name', accountName, isDark),
          _divider(isDark),
          _detailRow('Card Type', cardType, isDark),
          _divider(isDark),
          _detailRow('Display Name', displayName, isDark),
          _divider(isDark),
          _detailRow('Pickup Branch', pickupBranch, isDark),
        ],
      ),
    );
  }

  Widget _buildChargesSectionCard(bool isDark) {
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
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.payments_outlined, color: accentColor, size: 15),
              ),
              SizedBox(width: 2.5.w),
              Text(
                'Charges',
                style: GoogleFonts.inter(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.3.h),
          _detailRow('Card Fee', 'GH₵ ${_charges.toStringAsFixed(2)}', isDark),
          _divider(isDark),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 0.8.h),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
                  accentColor.withValues(alpha: isDark ? 0.08 : 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: accentColor.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Text(
                  'Total',
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : const Color(0xFF374151),
                  ),
                ),
                const Spacer(),
                Text(
                  'GH₵ ${_charges.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32.w,
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
              style: GoogleFonts.inter(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF1A1D23),
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

  Widget _buildSecurityNote(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF059669).withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 15,
            color: const Color(0xFF059669).withValues(alpha: 0.8),
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Text(
              'You will be asked to authorize this request with your transaction PIN.',
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                height: 1.35,
                color: isDark ? Colors.white54 : const Color(0xFF64748B),
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
                  onAuthenticated: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => _AtmCardSuccessScreen(
                          cardType: cardType,
                          accountName: accountName,
                          pickupBranch: pickupBranch,
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
                  gradient: LinearGradient(
                    colors: [accentColor, accentColor.withValues(alpha: 0.85)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      'Confirm & Request',
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
                  'Cancel',
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
