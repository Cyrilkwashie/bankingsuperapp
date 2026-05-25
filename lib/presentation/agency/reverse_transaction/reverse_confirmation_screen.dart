part of 'agency_reverse_transaction_screen.dart';

class _ReverseConfirmationScreen extends StatelessWidget {
  final _ReverseTxn txn;
  final String reason;
  final String narration;
  final Color accentColor;
  final List<Color> gradientColors;

  const _ReverseConfirmationScreen({
    required this.txn,
    required this.reason,
    required this.narration,
    required this.accentColor,
    required this.gradientColors,
  });

  static const Color _warning = Color(0xFFF59E0B);

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
          _AgencyReverseTransactionScreenState.buildFlowStepIndicator(3, isDark),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 2.h),
              child: Column(
                children: [
                  _buildHeroAmount(isDark),
                  SizedBox(height: 2.5.h),
                  _buildSummaryCard(isDark),
                  SizedBox(height: 2.h),
                  _buildWarningNote(isDark),
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
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.undo_rounded, color: Colors.white, size: 21),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirm Reversal',
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
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

  Widget _buildHeroAmount(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : [accentColor.withValues(alpha: 0.08), accentColor.withValues(alpha: 0.02)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.undo_rounded, color: accentColor, size: 20),
          ),
          SizedBox(height: 1.h),
          Text(
            'Amount to Reverse',
            style: GoogleFonts.inter(
              fontSize: 7.5.sp,
              color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 0.3.h),
          Text(
            'GH₵ ${txn.amount}',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 0.6.h),
          Text(
            txn.customer,
            style: GoogleFonts.inter(
              fontSize: 7.5.sp,
              fontWeight: FontWeight.w500,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(bool isDark) {
    return Container(
      width: double.infinity,
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
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.5.w, 2.h, 4.5.w, 1.5.h),
            child: Row(
              children: [
                Icon(Icons.receipt_long_outlined, color: accentColor, size: 18),
                SizedBox(width: 2.5.w),
                Text(
                  'Reversal Summary',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          _detailRow('Transaction Type', txn.type, isDark),
          _detailRow('Customer', txn.customer, isDark),
          _detailRow(
            'Account',
            _AgencyReverseTransactionScreenState.maskAccountNo(txn.accountNo),
            isDark,
          ),
          _detailRow('Original Reference', txn.reference, isDark, mono: true),
          _detailRow('Transaction Date', txn.date, isDark),
          _detailRow('Reversal Reason', reason, isDark),
          if (narration.isNotEmpty) _detailRow('Narration', narration, isDark),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.5.w),
            child: Divider(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : const Color(0xFFF3F4F6),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(4.5.w),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
                  accentColor.withValues(alpha: isDark ? 0.08 : 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Text(
                  'Reversal Amount',
                  style: GoogleFonts.inter(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : const Color(0xFF374151),
                  ),
                ),
                const Spacer(),
                Text(
                  'GH₵ ${txn.amount}',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0.5.h),
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
              style: mono
                  ? GoogleFonts.jetBrainsMono(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : const Color(0xFF374151),
                      height: 1.35,
                    )
                  : GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningNote(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.3.h),
      decoration: BoxDecoration(
        color: isDark
            ? _warning.withValues(alpha: 0.08)
            : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _warning.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: _warning.withValues(alpha: 0.9),
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Text(
              'This action is irreversible. Reversing will undo the original transaction and adjust agent float accordingly.',
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                height: 1.4,
                color: isDark ? Colors.white54 : const Color(0xFF92400E),
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
              onTap: () => _onConfirm(context),
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
                      'Confirm & Reverse',
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
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.8.h),
                child: Text(
                  'Go Back & Edit',
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
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

  void _onConfirm(BuildContext context) {
    showTransactionAuthBottomSheet(
      context: context,
      accentColor: accentColor,
      title: 'Authorize Reversal',
      subtitle: 'Enter your 4-digit transaction PIN or use biometrics',
      onAuthenticated: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _ReverseTransactionSuccessScreen(
              txn: txn,
              reason: reason,
              narration: narration,
              accentColor: accentColor,
              gradientColors: gradientColors,
            ),
          ),
        );
      },
    );
  }
}
