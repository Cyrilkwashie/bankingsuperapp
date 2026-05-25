part of 'agency_cheque_book_screen.dart';

class _ChequeBookConfirmationScreen extends StatelessWidget {
  final String accountNo;
  final String accountName;
  final String numberOfLeaves;
  final String pickupBranch;
  final Color accentColor;
  final List<Color> gradientColors;

  const _ChequeBookConfirmationScreen({
    required this.accountNo,
    required this.accountName,
    required this.numberOfLeaves,
    required this.pickupBranch,
    required this.accentColor,
    required this.gradientColors,
  });

  double get _charges {
    if (numberOfLeaves.contains('50')) return 30.00;
    return 20.00;
  }

  String _maskAccountNo(String no) {
    if (no.length >= 7) {
      return '${no.substring(0, 3)} •••• ${no.substring(no.length - 3)}';
    }
    return no;
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
                  _buildDetailsSectionCard(isDark),
                  SizedBox(height: 1.5.h),
                  _buildChargesSectionCard(isDark),
                  SizedBox(height: 1.5.h),
                  _buildSecurityNote(isDark),
                ],
              ),
            ),
          ),
          _buildStickyActionBar(context, isDark),
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

  Widget _buildIntroTip(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: isDark ? 0.12 : 0.06),
            accentColor.withValues(alpha: isDark ? 0.04 : 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: accentColor, size: 15),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Text(
              'Review the request details and charges below, then authorise with your transaction PIN.',
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
                child: Icon(Icons.menu_book_outlined, color: accentColor, size: 15),
              ),
              SizedBox(width: 2.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Details',
                      style: GoogleFonts.inter(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    Text(
                      numberOfLeaves,
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.3.h),
          _detailRow('Account Number', _maskAccountNo(accountNo), isDark, mono: true),
          _divider(isDark),
          _detailRow('Account Name', accountName, isDark),
          _divider(isDark),
          _detailRow('Number of Leaves', numberOfLeaves, isDark),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Charges',
            style: GoogleFonts.inter(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 1.h),
          _detailRow(
            'Cheque Book Fee',
            'GH₵ ${_charges.toStringAsFixed(2)}',
            isDark,
          ),
          _divider(isDark),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.8.h),
            child: Row(
              children: [
                Text(
                  'Total',
                  style: GoogleFonts.inter(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
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

  Widget _detailRow(
    String label,
    String value,
    bool isDark, {
    bool mono = false,
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
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    )
                  : GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF111827),
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

  Widget _buildStickyActionBar(BuildContext context, bool isDark) {
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
                        builder: (_) => _ChequeBookSuccessScreen(
                          numberOfLeaves: numberOfLeaves,
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
                      Icons.lock_outline_rounded,
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
