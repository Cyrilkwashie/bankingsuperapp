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
          // Header
          Container(
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
                    Text(
                      'Confirm Block',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 4.h),
              child: Column(
                children: [
                  // Blocked card illustration
                  _buildBlockedCardIllustration(isDark),
                  SizedBox(height: 2.5.h),

                  // Details
                  _buildDetailsCard(isDark),
                  SizedBox(height: 2.h),

                  // Warning
                  _buildFinalWarning(isDark),
                  SizedBox(height: 3.h),

                  // Confirm
                  _buildConfirmButton(context, isDark),
                  SizedBox(height: 1.2.h),
                  _buildCancelButton(context, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockedCardIllustration(bool isDark) {
    return Container(
      width: double.infinity,
      height: 20.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF374151), const Color(0xFF1F2937)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF374151).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Diagonal stripes for "blocked" effect
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomPaint(painter: _BlockedStripePainter()),
            ),
          ),
          // Card content
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
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.5.w,
                        vertical: 0.4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'BLOCKED',
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
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
                        color: const Color(0xFF6B7280),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Text(
                  _maskedCardNumber,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.6),
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 0.8.h),
                Text(
                  accountName.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.5),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // Block icon overlay
          Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 0.85),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.block_rounded, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Block Details',
            style: GoogleFonts.inter(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 1.5.h),
          _detailRow('Account Number', accountNo, isDark),
          _divider(isDark),
          _detailRow('Account Name', accountName, isDark),
          _divider(isDark),
          _detailRow('Card Type', cardType, isDark),
          _divider(isDark),
          _detailRow('Card Number', _maskedCardNumber, isDark),
          _divider(isDark),
          _detailRow(
            'Reason',
            reason,
            isDark,
            valueColor: const Color(0xFFDC2626),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 8.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
                color:
                    valueColor ??
                    (isDark ? Colors.white : const Color(0xFF1A1D23)),
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
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFFDC2626).withValues(alpha: 0.08)
            : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFDC2626).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.warning_rounded,
                color: Color(0xFFDC2626),
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
                  'This action is permanent',
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFDC2626),
                  ),
                ),
                SizedBox(height: 0.2.h),
                Text(
                  'Once blocked, this card cannot be unblocked. The customer will need to request a new card.',
                  style: GoogleFonts.inter(
                    fontSize: 7.5.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white54 : const Color(0xFF991B1B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        showTransactionAuthBottomSheet(
          context: context,
          accentColor: accentColor,
          title: 'Authorize Card Block',
          onAuthenticated: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => _BlockCardSuccessDialog(
                cardType: cardType,
                maskedCardNumber: _maskedCardNumber,
                accountName: accountName,
                reason: reason,
                accentColor: accentColor,
              ),
              ),
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDC2626).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.block_rounded, color: Colors.white, size: 20),
            SizedBox(width: 2.w),
            Text(
              'Confirm & Block Card',
              style: GoogleFonts.inter(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161B22) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Center(
          child: Text(
            'Go Back',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Blocked Stripe Painter ──
