part of 'agency_balance_enquiry_screen.dart';

class _BalanceResultScreen extends StatefulWidget {
  final String accountNo;
  final String accountName;
  final String enquiryType;
  final String scopeDescription;
  final String destinationPhone;
  final Color accentColor;
  final List<Color> gradientColors;

  const _BalanceResultScreen({
    required this.accountNo,
    required this.accountName,
    required this.enquiryType,
    required this.scopeDescription,
    required this.destinationPhone,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_BalanceResultScreen> createState() => _BalanceResultScreenState();
}

class _BalanceResultScreenState extends State<_BalanceResultScreen>
    with TickerProviderStateMixin {
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
    return 'BEQ/${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}/${now.millisecond.toString().padLeft(4, '0').substring(0, 4)}';
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(isDark),
          _AgencyBalanceEnquiryScreenState.buildFlowStepIndicator(4, isDark),
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
                      child: const Center(
                        child: Icon(Icons.check_rounded,
                            color: Color(0xFF059669), size: 28),
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Text(
                      'SMS Sent Successfully',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.enquiryType == 'balance'
                          ? 'Balance enquiry dispatched via SMS'
                          : 'Transaction details dispatched via SMS',
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
                            'Scope',
                            widget.scopeDescription,
                          ),
                          _divider(isDark),
                          _receiptRow(
                            isDark,
                            'Delivered To',
                            widget.destinationPhone,
                            mono: true,
                            accent: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    _buildSmsPreview(isDark),
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

  Widget _buildSmsPreview(bool isDark) {
    final previewText = widget.enquiryType == 'balance'
        ? 'Your account balance enquiry was processed.\n\nAccount: ${_maskAccountNo(widget.accountNo)}\nHolder: ${widget.accountName}\n\nRef: $_referenceNo'
        : 'Your transaction details have been processed.\n\nAccount: ${_maskAccountNo(widget.accountNo)}\nScope: ${widget.scopeDescription}\n\nRef: $_referenceNo';

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
              Icon(Icons.sms_outlined,
                  size: 14,
                  color: isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
              SizedBox(width: 1.5.w),
              Text(
                'SMS Preview',
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
            previewText,
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
                    builder: (_) => const AgencyBalanceEnquiryScreen(),
                  ),
                  (route) => route.settings.name != null,
                );
              },
              child: Text(
                'New Enquiry',
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
                      'Enquiry Sent',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Balance Enquiry · Step 4 of 4',
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
