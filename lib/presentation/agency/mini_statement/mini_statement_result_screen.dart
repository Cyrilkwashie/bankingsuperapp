part of 'agency_mini_statement_screen.dart';

class _MiniStatementResultScreen extends StatefulWidget {
  final String accountNo;
  final String accountName;
  final String accountBalance;
  final String accountType;
  final int txnCount;
  final String destinationPhone;
  final Color accentColor;
  final List<Color> gradientColors;

  const _MiniStatementResultScreen({
    required this.accountNo,
    required this.accountName,
    required this.accountBalance,
    required this.accountType,
    required this.txnCount,
    required this.destinationPhone,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_MiniStatementResultScreen> createState() =>
      _MiniStatementResultScreenState();
}

class _MiniStatementResultScreenState extends State<_MiniStatementResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fade;

  late final String _referenceNo;
  late final DateTime _timestamp;

  @override
  void initState() {
    super.initState();
    _timestamp = DateTime.now();
    _referenceNo = _generateReference();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String _generateReference() {
    final now = DateTime.now();
    return 'MS${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
  }

  String _formatTimestamp(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}  $h:$m:$s $period';
  }

  String _maskAccountNo(String no) {
    if (no.length >= 7) {
      return '${no.substring(0, 3)} •••• ${no.substring(no.length - 3)}';
    }
    return no;
  }

  String _maskPhone(String phone) {
    if (phone.length < 8) return phone;
    return '${phone.substring(0, 5)}****${phone.substring(phone.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasPhone = widget.destinationPhone.isNotEmpty;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(isDark),
          _AgencyMiniStatementScreenState.buildFlowStepIndicator(4, isDark),
          Expanded(
            child: FadeTransition(
              opacity: _fade,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 2.h),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF059669).withValues(alpha: 0.25),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          hasPhone ? Icons.sms_rounded : Icons.check_rounded,
                          color: const Color(0xFF059669),
                          size: 28,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Text(
                      hasPhone ? 'Statement Sent Successfully' : 'Statement Generated',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      hasPhone
                          ? 'Mini statement dispatched via SMS'
                          : 'Mini statement for the last ${widget.txnCount} transactions generated',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161B22) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: widget.accentColor.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Column(
                        children: [
                          _receiptRow(
                            isDark,
                            'Reference',
                            _referenceNo,
                            mono: true,
                            accent: true,
                          ),
                          _divider(isDark),
                          _receiptRow(
                            isDark,
                            'Timestamp',
                            _formatTimestamp(_timestamp),
                          ),
                          _divider(isDark),
                          _receiptRow(
                            isDark,
                            'Account Holder',
                            widget.accountName,
                          ),
                          _divider(isDark),
                          _receiptRow(
                            isDark,
                            'Account',
                            _maskAccountNo(widget.accountNo),
                            mono: true,
                          ),
                          _divider(isDark),
                          _receiptRow(
                            isDark,
                            'Account Type',
                            widget.accountType,
                          ),
                          _divider(isDark),
                          _receiptRow(
                            isDark,
                            'Available Balance',
                            widget.accountBalance,
                            accent: true,
                          ),
                          _divider(isDark),
                          _receiptRow(
                            isDark,
                            'Transactions',
                            'Last ${widget.txnCount}',
                          ),
                          if (hasPhone) ...[
                            _divider(isDark),
                            _receiptRow(
                              isDark,
                              'Delivered To',
                              _maskPhone(widget.destinationPhone),
                              mono: true,
                              accent: true,
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    _buildStatementSummary(isDark),
                    SizedBox(height: 1.5.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1B365D).withValues(alpha: 0.15)
                            : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF1B365D).withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_outline_rounded,
                              size: 14, color: Color(0xFF3B82F6)),
                          SizedBox(width: 2.5.w),
                          Expanded(
                            child: Text(
                              'For customer privacy, transaction details are only visible to the account holder.',
                              style: GoogleFonts.inter(
                                fontSize: 7.sp,
                                height: 1.4,
                                color: isDark
                                    ? Colors.white54
                                    : const Color(0xFF374151),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildStickyDone(isDark),
        ],
      ),
    );
  }

  Widget _buildStatementSummary(bool isDark) {
    final summaryText = hasPhone
        ? 'Mini Statement — Last ${widget.txnCount} transactions\n'
            'Account: ${_maskAccountNo(widget.accountNo)}\n'
            'Holder: ${widget.accountName}\n'
            'Balance: ${widget.accountBalance}\n\n'
            'Sent to: ${_maskPhone(widget.destinationPhone)}\n'
            'Ref: $_referenceNo'
        : 'Mini Statement — Last ${widget.txnCount} transactions\n'
            'Account: ${_maskAccountNo(widget.accountNo)}\n'
            'Holder: ${widget.accountName}\n'
            'Balance: ${widget.accountBalance}\n\n'
            'Ref: $_referenceNo';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2236) : const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.accentColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: 14,
                  color: isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
              SizedBox(width: 1.5.w),
              Text(
                'Statement Summary',
                style: GoogleFonts.inter(
                  fontSize: 7.5.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.8.h),
          Text(
            summaryText,
            style: GoogleFonts.inter(
              fontSize: 7.sp,
              color: isDark ? Colors.white70 : const Color(0xFF374151),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  bool get hasPhone => widget.destinationPhone.isNotEmpty;

  Widget _receiptRow(
    bool isDark,
    String label,
    String value, {
    bool mono = false,
    bool accent = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.7.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28.w,
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
              textAlign: TextAlign.right,
              style: mono
                  ? GoogleFonts.jetBrainsMono(
                      fontSize: 7.5.sp,
                      fontWeight: FontWeight.w600,
                      color: accent
                          ? widget.accentColor
                          : (isDark ? Colors.white : const Color(0xFF111827)),
                    )
                  : GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      color: accent
                          ? const Color(0xFF059669)
                          : (isDark ? Colors.white : const Color(0xFF111827)),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) => Divider(
        height: 0,
        thickness: 1,
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF3F4F6),
      );

  Widget _buildStickyDone(bool isDark) {
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
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).popUntil(
                (route) => route.isFirst
                    ? true
                    : route.settings.name == '/agency-banking-dashboard',
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.25.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.accentColor,
                      widget.accentColor.withValues(alpha: 0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Done',
                    style: GoogleFonts.inter(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 0.8.h),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const AgencyMiniStatementScreen(),
                  ),
                  (route) => route.settings.name != null,
                );
              },
              child: Text(
                'New Statement',
                style: GoogleFonts.inter(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w500,
                  color: widget.accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final hasPhone = widget.destinationPhone.isNotEmpty;

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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.check_circle_rounded,
                      color: Color(0xFF34D399), size: 22),
                ),
              ),
              SizedBox(width: 3.5.w),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Center(
                  child: Icon(Icons.receipt_long_outlined,
                      color: Colors.white, size: 20),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasPhone ? 'Statement Sent' : 'Statement Ready',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Mini Statement · Step 4 of 4',
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
                  color: const Color(0xFF059669).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF059669).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_rounded,
                        size: 12, color: Color(0xFF34D399)),
                    SizedBox(width: 1.w),
                    Text(
                      'Success',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w600,
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
