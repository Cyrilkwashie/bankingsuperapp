part of 'agency_balance_enquiry_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Balance Enquiry Result Screen ──
// ══════════════════════════════════════════════════════════════

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
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _pulse;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  late final String _referenceNo;
  late final DateTime _timestamp;

  @override
  void initState() {
    super.initState();

    _timestamp = DateTime.now();
    _referenceNo = _generateReference();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulse = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pulseController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _fadeController.forward();
          _slideController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
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
      return '${no.substring(0, 3)}****${no.substring(no.length - 3)}';
    }
    return no;
  }

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(isDark),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 5.h),
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Column(
                    children: [
                      // ── Success icon ──
                      ScaleTransition(
                        scale: _pulse,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF059669).withValues(alpha: 0.25),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF059669).withValues(alpha: 0.12),
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check_rounded,
                              color: Color(0xFF059669),
                              size: 44,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),

                      Text(
                        'SMS Sent Successfully!',
                        style: GoogleFonts.inter(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 0.8.h),
                      Text(
                        widget.enquiryType == 'balance'
                            ? 'Account balance has been dispatched via SMS'
                            : 'Transaction details have been dispatched via SMS',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 8.5.sp,
                          color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                          height: 1.45,
                        ),
                      ),
                      SizedBox(height: 3.h),

                      // ── Delivery indicator ──
                      _buildDeliveryBadge(isDark),
                      SizedBox(height: 2.5.h),

                      // ── Details card ──
                      _buildDetailsCard(isDark),
                      SizedBox(height: 2.5.h),

                      // ── SMS preview ──
                      _buildSmsPreview(isDark),
                      SizedBox(height: 3.5.h),

                      // ── Actions ──
                      _buildNewEnquiryButton(),
                      SizedBox(height: 1.5.h),
                      _buildDoneButton(isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryBadge(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: const Color(0xFF059669).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: const Color(0xFF059669).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.phone_android_rounded,
              color: Color(0xFF059669), size: 16),
          SizedBox(width: 2.w),
          Text(
            'Delivered to  ',
            style: GoogleFonts.inter(
              fontSize: 8.5.sp,
              color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            ),
          ),
          Text(
            widget.destinationPhone,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF059669),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: widget.accentColor.withValues(alpha: 0.12),
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
          _resultRow(
            isDark: isDark,
            icon: Icons.confirmation_number_rounded,
            label: 'Reference No.',
            value: _referenceNo,
            valueStyle: GoogleFonts.jetBrainsMono(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: widget.accentColor,
              letterSpacing: 0.8,
            ),
          ),
          _divider(isDark),
          _resultRow(
            isDark: isDark,
            icon: Icons.person_rounded,
            label: 'Account Holder',
            value: widget.accountName,
          ),
          _divider(isDark),
          _resultRow(
            isDark: isDark,
            icon: Icons.tag_rounded,
            label: 'Account Number',
            value: _maskAccountNo(widget.accountNo),
            valueStyle: GoogleFonts.jetBrainsMono(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF111827),
              letterSpacing: 1.2,
            ),
          ),
          _divider(isDark),
          _resultRow(
            isDark: isDark,
            icon: widget.enquiryType == 'balance'
                ? Icons.account_balance_wallet_rounded
                : Icons.receipt_long_rounded,
            label: 'Enquiry Type',
            value: widget.enquiryType == 'balance'
                ? 'Balance Enquiry'
                : 'Transaction Details',
            valueStyle: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: widget.accentColor,
            ),
          ),
          _divider(isDark),
          _resultRow(
            isDark: isDark,
            icon: Icons.info_outline_rounded,
            label: 'Scope',
            value: widget.scopeDescription,
          ),
          _divider(isDark),
          _resultRow(
            isDark: isDark,
            icon: Icons.schedule_rounded,
            label: 'Timestamp',
            value: _formatTimestamp(_timestamp),
          ),
        ],
      ),
    );
  }

  Widget _buildSmsPreview(bool isDark) {
    final previewText = widget.enquiryType == 'balance'
        ? 'Your account balance enquiry was processed.\n\nAccount: ${_maskAccountNo(widget.accountNo)}\nHolder: ${widget.accountName}\nAvailable Balance: **** (hidden for preview)\n\nRef: $_referenceNo\nBank Agency Portal'
        : 'Your recent transaction details have been processed.\n\nAccount: ${_maskAccountNo(widget.accountNo)}\nHolder: ${widget.accountName}\nScope: ${widget.scopeDescription}\n\nRef: $_referenceNo\nBank Agency Portal';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.sms_rounded,
                size: 15,
                color: isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
            SizedBox(width: 1.5.w),
            Text(
              'SMS Preview',
              style: GoogleFonts.inter(
                fontSize: 8.5.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white54 : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1A2236)
                : const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.accentColor.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SMS header
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: widget.accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.account_balance_rounded,
                          size: 14, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BANK-AGENCY',
                        style: GoogleFonts.inter(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white70 : const Color(0xFF374151),
                        ),
                      ),
                      Text(
                        'Now',
                        style: GoogleFonts.inter(
                          fontSize: 6.5.sp,
                          color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 1.2.h),
              Text(
                previewText,
                style: GoogleFonts.inter(
                  fontSize: 7.5.sp,
                  color: isDark ? Colors.white70 : const Color(0xFF374151),
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewEnquiryButton() {
    return GestureDetector(
      onTap: () {
        // Pop back to main screen - push a new one
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const AgencyBalanceEnquiryScreen(),
          ),
          (route) => route.settings.name != null,
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.accentColor,
              widget.accentColor.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_rounded, size: 18, color: Colors.white),
            SizedBox(width: 2.w),
            Text(
              'New Enquiry',
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

  Widget _buildDoneButton(bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.of(context).popUntil((route) => route.isFirst
          ? true
          : route.settings.name == '/agency-banking-dashboard'),
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
            'Back to Dashboard',
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

  Widget _resultRow({
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: const Center(
                  child: Icon(Icons.check_circle_rounded,
                      color: Color(0xFF34D399), size: 22),
                ),
              ),
              SizedBox(width: 3.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enquiry Sent',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Balance Enquiry · Complete',
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
