part of 'agency_stop_cheque_screen.dart';

class _StopChequeConfirmationScreen extends StatelessWidget {
  final String accountNo;
  final String accountName;
  final DateTime dateIssued;
  final String fromChequeNo;
  final String toChequeNo;
  final String beneficiaryName;
  final String amount;
  final String reason;
  final Color accentColor;
  final List<Color> gradientColors;

  const _StopChequeConfirmationScreen({
    required this.accountNo,
    required this.accountName,
    required this.dateIssued,
    required this.fromChequeNo,
    required this.toChequeNo,
    required this.beneficiaryName,
    required this.amount,
    required this.reason,
    required this.accentColor,
    required this.gradientColors,
  });

  int get _chequeCount {
    final from = int.tryParse(fromChequeNo) ?? 0;
    final to = int.tryParse(toChequeNo) ?? 0;
    return (to - from + 1).clamp(1, 999);
  }

  String get _totalFee => 'GH₵ ${(_chequeCount * 15).toStringAsFixed(2)}';

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    return '$day ${_months[d.month - 1]} ${d.year}';
  }

  static String _formatDateShort(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
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
          _StopChequeFlowStepIndicator(
            currentStep: 3,
            isDark: isDark,
            accent: accentColor,
            success: const Color(0xFF059669),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 2.h),
              child: Column(
                children: [
                  _buildChequeIllustration(isDark),
                  SizedBox(height: 1.5.h),
                  _buildDetailsCard(isDark),
                  SizedBox(height: 1.2.h),
                  _buildChargesCard(isDark),
                  SizedBox(height: 1.2.h),
                  _buildWarning(isDark),
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
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.6.h),
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

  Widget _buildChequeIllustration(bool isDark) {
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
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.5.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'UTB CHEQUE',
                      style: GoogleFonts.inter(
                        fontSize: 7.5.sp,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'STOP REQUESTED',
                        style: GoogleFonts.inter(
                          fontSize: 5.5.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.2.h),
                Row(
                  children: [
                    Text(
                      'PAY: ',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        beneficiaryName.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.8.h),
                Row(
                  children: [
                    Text(
                      'AMOUNT: ',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                      ),
                    ),
                    Text(
                      'GH₵ $amount',
                      style: GoogleFonts.inter(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.2.h),
                Divider(
                  height: 1,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFE5E7EB),
                ),
                SizedBox(height: 0.8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'No: $fromChequeNo – $toChequeNo',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 7.sp,
                        color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      _formatDateShort(dateIssued),
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 1.2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cancel_rounded,
                  color: Color(0xFFF59E0B),
                  size: 14,
                ),
                SizedBox(width: 1.5.w),
                Text(
                  '$_chequeCount cheque${_chequeCount > 1 ? 's' : ''} to be stopped',
                  style: GoogleFonts.inter(
                    fontSize: 7.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(bool isDark) {
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
            'Request Details',
            style: GoogleFonts.inter(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 1.2.h),
          _detailRow('Account Number', _maskAccountNo(accountNo), isDark, mono: true),
          _divider(isDark),
          _detailRow('Account Name', accountName, isDark),
          _divider(isDark),
          _detailRow('Date Issued', _formatDate(dateIssued), isDark),
          _divider(isDark),
          _detailRow('From Cheque No.', fromChequeNo, isDark, mono: true),
          _divider(isDark),
          _detailRow('To Cheque No.', toChequeNo, isDark, mono: true),
          _divider(isDark),
          _detailRow('Beneficiary', beneficiaryName, isDark),
          _divider(isDark),
          _detailRow(
            'Cheque Amount',
            'GH₵ $amount',
            isDark,
            valueColor: accentColor,
          ),
          _divider(isDark),
          _detailRow('Reason', reason, isDark),
        ],
      ),
    );
  }

  Widget _buildChargesCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFFF59E0B).withValues(alpha: 0.06)
            : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_rounded,
                color: Color(0xFFF59E0B),
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'Charges',
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFD97706),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _chargeRow('Fee per cheque', 'GH₵ 15.00', isDark),
          SizedBox(height: 0.3.h),
          _chargeRow('Number of cheques', '$_chequeCount', isDark),
          SizedBox(height: 0.8.h),
          Divider(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
            height: 1,
          ),
          SizedBox(height: 0.8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Charge',
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFD97706),
                ),
              ),
              Text(
                _totalFee,
                style: GoogleFonts.inter(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFD97706),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chargeRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 8.sp,
            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF1A1D23),
          ),
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

  Widget _buildWarning(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFFF59E0B).withValues(alpha: 0.06)
            : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFF59E0B),
            size: 18,
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Processing Notice',
                  style: GoogleFonts.inter(
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFD97706),
                  ),
                ),
                SizedBox(height: 0.2.h),
                Text(
                  'The stop-cheque request will be processed within 24 hours. The charge of $_totalFee will be debited from the account.',
                  style: GoogleFonts.inter(
                    fontSize: 7.5.sp,
                    height: 1.35,
                    color: isDark ? Colors.white54 : const Color(0xFF92400E),
                  ),
                ),
              ],
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
                        builder: (_) => _StopChequeSuccessScreen(
                          fromChequeNo: fromChequeNo,
                          toChequeNo: toChequeNo,
                          beneficiaryName: beneficiaryName,
                          amount: amount,
                          totalFee: _totalFee,
                          chequeCount: _chequeCount,
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
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Confirm & Submit',
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
                    fontWeight: FontWeight.w600,
                    color: accentColor,
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
