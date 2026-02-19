part of 'agency_balance_enquiry_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Balance Enquiry Confirmation Screen ──
// ══════════════════════════════════════════════════════════════

class _BalanceConfirmationScreen extends StatefulWidget {
  final String accountNo;
  final String accountName;
  final String accountBalance;
  final String accountType;
  final String enquiryType;
  final int? txnCount;
  final DateTime? txnStartDate;
  final DateTime? txnEndDate;
  final String destinationPhone;
  final Color accentColor;
  final List<Color> gradientColors;

  const _BalanceConfirmationScreen({
    required this.accountNo,
    required this.accountName,
    required this.accountBalance,
    required this.accountType,
    required this.enquiryType,
    required this.txnCount,
    required this.txnStartDate,
    required this.txnEndDate,
    required this.destinationPhone,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_BalanceConfirmationScreen> createState() =>
      _BalanceConfirmationScreenState();
}

class _BalanceConfirmationScreenState
    extends State<_BalanceConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  bool _isSending = false;

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

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String get _enquiryLabel =>
      widget.enquiryType == 'balance' ? 'Balance Enquiry' : 'Transaction Details';

  String get _scopeDescription {
    if (widget.enquiryType == 'balance') {
      return 'Current available account balance';
    }
    if (widget.txnCount != null) {
      return 'Last ${widget.txnCount} transactions';
    }
    final from = widget.txnStartDate != null ? _formatDate(widget.txnStartDate!) : '—';
    final to = widget.txnEndDate != null ? _formatDate(widget.txnEndDate!) : '—';
    return 'Transactions: $from – $to';
  }

  String _maskAccountNo(String no) {
    if (no.length >= 7) {
      return '${no.substring(0, 3)}****${no.substring(no.length - 3)}';
    }
    return no;
  }

  void _onConfirmTap() {
    showTransactionAuthBottomSheet(
      context: context,
      accentColor: widget.accentColor,
      title: 'Authorize Enquiry',
      subtitle: 'Enter your 4-digit transaction PIN or use biometrics',
      onAuthenticated: () {
        _sendAfterAuth();
      },
    );
  }

  Future<void> _sendAfterAuth() async {
    setState(() => _isSending = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => _BalanceResultScreen(
            accountNo: widget.accountNo,
            accountName: widget.accountName,
            enquiryType: widget.enquiryType,
            scopeDescription: _scopeDescription,
            destinationPhone: widget.destinationPhone,
            accentColor: widget.accentColor,
            gradientColors: widget.gradientColors,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 4.h),
                child: Column(
                  children: [
                    // Top icon
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.accentColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          widget.enquiryType == 'balance'
                              ? Icons.account_balance_wallet_rounded
                              : Icons.receipt_long_rounded,
                          color: widget.accentColor,
                          size: 32,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Confirm & Send',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 0.6.h),
                    Text(
                      'Review the details below before sending the SMS to the customer.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                        height: 1.45,
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // ── Summary card ──
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.5.w),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161B22) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: widget.accentColor.withValues(alpha: 0.15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _confirmRow(
                            isDark: isDark,
                            icon: Icons.person_rounded,
                            label: 'Account Holder',
                            value: widget.accountName,
                            valueStyle: GoogleFonts.inter(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                              color:
                                  isDark ? Colors.white : const Color(0xFF111827),
                            ),
                          ),
                          _divider(isDark),
                          _confirmRow(
                            isDark: isDark,
                            icon: Icons.tag_rounded,
                            label: 'Account Number',
                            value: _maskAccountNo(widget.accountNo),
                            valueStyle: GoogleFonts.jetBrainsMono(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color:
                                  isDark ? Colors.white : const Color(0xFF111827),
                              letterSpacing: 1.2,
                            ),
                          ),
                          _divider(isDark),
                          _confirmRow(
                            isDark: isDark,
                            icon: Icons.account_balance_rounded,
                            label: 'Account Type',
                            value: widget.accountType,
                          ),
                          _divider(isDark),
                          _confirmRow(
                            isDark: isDark,
                            icon: widget.enquiryType == 'balance'
                                ? Icons.account_balance_wallet_rounded
                                : Icons.receipt_long_rounded,
                            label: 'Enquiry Type',
                            value: _enquiryLabel,
                            valueStyle: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: widget.accentColor,
                            ),
                          ),
                          _divider(isDark),
                          _confirmRow(
                            isDark: isDark,
                            icon: Icons.info_outline_rounded,
                            label: 'Scope',
                            value: _scopeDescription,
                          ),
                          _divider(isDark),
                          _confirmRow(
                            isDark: isDark,
                            icon: Icons.phone_android_rounded,
                            label: 'Deliver To',
                            value: widget.destinationPhone,
                            valueStyle: GoogleFonts.jetBrainsMono(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF059669),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // SMS charge note
                    Container(
                      padding: EdgeInsets.all(3.5.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.sms_rounded,
                            color: Color(0xFFF59E0B),
                            size: 18,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Standard SMS charges may apply. The customer will receive this information on their mobile number.',
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

                    SizedBox(height: 3.5.h),

                    // Confirm button
                    GestureDetector(
                      onTap: _isSending ? null : _onConfirmTap,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 1.8.h),
                        decoration: BoxDecoration(
                          gradient: !_isSending
                              ? LinearGradient(colors: [
                                  widget.accentColor,
                                  widget.accentColor.withValues(alpha: 0.85),
                                ])
                              : null,
                          color: _isSending
                              ? (isDark
                                      ? const Color(0xFF1E2328)
                                      : const Color(0xFFE5E7EB))
                              : null,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: !_isSending
                              ? [
                                  BoxShadow(
                                    color:
                                        widget.accentColor.withValues(alpha: 0.35),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: _isSending
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      'Sending…',
                                      style: GoogleFonts.inter(
                                        fontSize: 10.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white38
                                            : const Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.send_rounded,
                                        size: 18, color: Colors.white),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Send $_enquiryLabel',
                                      style: GoogleFonts.inter(
                                        fontSize: 10.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: 1.5.h),

                    // Go back
                    GestureDetector(
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
                              color: isDark
                                  ? Colors.white54
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
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

  Widget _confirmRow({
    required bool isDark,
    required IconData icon,
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: widget.accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: Icon(icon, color: widget.accentColor, size: 16),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 7.5.sp,
                    color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  value,
                  style: valueStyle ??
                      GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF374151),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 0,
      thickness: 1,
      color: isDark
          ? Colors.white.withValues(alpha: 0.05)
          : const Color(0xFFF3F4F6),
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
              : widget.gradientColors,
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
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.08)),
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
                      'Confirm Dispatch',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Balance Enquiry · Step 3 of 3',
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
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 12, color: Color(0xFF34D399)),
                    SizedBox(width: 1.w),
                    Text(
                      'Verified',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF34D399),
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
