part of 'agency_qr_deposit_screen.dart';

class _QrDepositReceiptScreen extends StatelessWidget {
  final String accountNo;
  final String accountName;
  final String amount;
  final String depositorName;
  final String depositorTel;
  final String narration;
  final String fixedNarration;
  final String agentFloat;
  final Color accentColor;
  final List<Color> gradientColors;

  const _QrDepositReceiptScreen({
    required this.accountNo,
    required this.accountName,
    required this.amount,
    required this.depositorName,
    required this.depositorTel,
    required this.narration,
    required this.fixedNarration,
    required this.agentFloat,
    required this.accentColor,
    required this.gradientColors,
  });

  double get _amountValue => double.tryParse(amount) ?? 0;
  double get _charges => _amountValue * 0.01;
  double get _totalAmount => _amountValue + _charges;

  double get _parsedFloat {
    final cleaned = agentFloat.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
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
              padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 2.h),
              child: Column(
                children: [
                  _buildHeroAmount(isDark),
                  SizedBox(height: 2.5.h),
                  _buildSummaryCard(isDark),
                  SizedBox(height: 2.h),
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
                      'Confirm Deposit',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Agency Banking · Step 2 of 2',
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
          _stepDot(1, 2, 'Scan', isDark, completed: true),
          Expanded(
            child: Container(
              height: 2,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [accentColor, accentColor.withValues(alpha: 0.5)],
                ),
              ),
            ),
          ),
          _stepDot(2, 2, 'Confirm', isDark, completed: false),
        ],
      ),
    );
  }

  Widget _stepDot(
    int step,
    int current,
    String label,
    bool isDark, {
    required bool completed,
  }) {
    final isCurrent = step == current && !completed;
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
              : [
                  accentColor.withValues(alpha: 0.08),
                  accentColor.withValues(alpha: 0.02),
                ],
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
            child: Icon(Icons.qr_code_2_rounded, color: accentColor, size: 20),
          ),
          SizedBox(height: 1.h),
          Text(
            'Deposit Amount',
            style: GoogleFonts.inter(
              fontSize: 7.5.sp,
              color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 0.3.h),
          Text(
            'GH₵ $amount',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 0.6.h),
          Text(
            'To $accountName',
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
                  'Transaction Summary',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          _detailRow('Account', _maskAccountNo(accountNo), isDark),
          _detailRow('Account Name', accountName, isDark),
          _detailRow('Deposited By', depositorName, isDark),
          _detailRow('Telephone', depositorTel, isDark),
          if (narration.isNotEmpty) _detailRow('Narration', narration, isDark),
          _detailRow('System Ref', fixedNarration, isDark, mono: true),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.5.w),
            child: Divider(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : const Color(0xFFF3F4F6),
            ),
          ),
          _detailRow(
            'Deposit Amount',
            'GH₵ ${_amountValue.toStringAsFixed(2)}',
            isDark,
          ),
          _detailRow(
            'Service Charge (1%)',
            'GH₵ ${_charges.toStringAsFixed(2)}',
            isDark,
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
                  'Total Debit',
                  style: GoogleFonts.inter(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : const Color(0xFF374151),
                  ),
                ),
                const Spacer(),
                Text(
                  'GH₵ ${_totalAmount.toStringAsFixed(2)}',
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

  Widget _buildSecurityNote(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.3.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF059669).withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 16,
            color: const Color(0xFF059669).withValues(alpha: 0.8),
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Text(
              'You will be asked to authorize this deposit with your transaction PIN.',
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                height: 1.4,
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
                      'Confirm & Deposit',
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
    if (_parsedFloat < _totalAmount) {
      showDialog(
        context: context,
        builder: (_) => _InsufficientFundsDialog(
          balance: agentFloat,
          required: 'GH₵ ${_totalAmount.toStringAsFixed(2)}',
          balanceLabel: 'Agent Float',
          accentColor: accentColor,
        ),
      );
      return;
    }
    showTransactionAuthBottomSheet(
      context: context,
      accentColor: accentColor,
      onAuthenticated: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _QrDepositSuccessScreen(
              amount: 'GH₵ ${_totalAmount.toStringAsFixed(2)}',
              accountName: accountName,
              accountNo: accountNo,
              accentColor: accentColor,
              gradientColors: gradientColors,
            ),
          ),
        );
      },
    );
  }
}
