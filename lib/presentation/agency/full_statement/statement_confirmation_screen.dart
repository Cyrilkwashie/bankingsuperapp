part of 'agency_full_statement_screen.dart';

class _StatementConfirmationScreen extends StatelessWidget {
  final String accountNo;
  final String accountName;
  final String accountBalance;
  final String statementType;
  final DateTime startDate;
  final DateTime endDate;
  final String? pickupBranch;
  final Color accentColor;
  final List<Color> gradientColors;

  const _StatementConfirmationScreen({
    required this.accountNo,
    required this.accountName,
    required this.accountBalance,
    required this.statementType,
    required this.startDate,
    required this.endDate,
    required this.pickupBranch,
    required this.accentColor,
    required this.gradientColors,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String get _statementTypeLabel => statementType == 'electronic'
      ? 'Electronic Statement'
      : 'Ordinary Statement';

  double get _charges => statementType == 'electronic' ? 5.00 : 10.00;

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
          _buildHeader(context, isDark),
          _AgencyFullStatementScreenState.buildFlowStepIndicator(3, isDark),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 2.h),
              child: Column(
                children: [
                  Text(
                    'Confirm Request',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Review statement details before authorizing the request.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 8.sp,
                      color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                      height: 1.4,
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
                        color: accentColor.withValues(alpha: 0.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.15 : 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _confirmRow(
                          isDark: isDark,
                          icon: Icons.person_rounded,
                          label: 'Account Holder',
                          value: accountName,
                        ),
                        _divider(isDark),
                        _confirmRow(
                          isDark: isDark,
                          icon: Icons.tag_rounded,
                          label: 'Account Number',
                          value: _maskAccountNo(accountNo),
                          mono: true,
                        ),
                        _divider(isDark),
                        _confirmRow(
                          isDark: isDark,
                          icon: statementType == 'electronic'
                              ? Icons.email_outlined
                              : Icons.description_outlined,
                          label: 'Statement Type',
                          value: _statementTypeLabel,
                          accent: true,
                        ),
                        _divider(isDark),
                        _confirmRow(
                          isDark: isDark,
                          icon: Icons.date_range_outlined,
                          label: 'Start Date',
                          value: _formatDate(startDate),
                        ),
                        _divider(isDark),
                        _confirmRow(
                          isDark: isDark,
                          icon: Icons.event_outlined,
                          label: 'End Date',
                          value: _formatDate(endDate),
                        ),
                        if (statementType == 'ordinary' &&
                            pickupBranch != null) ...[
                          _divider(isDark),
                          _confirmRow(
                            isDark: isDark,
                            icon: Icons.location_on_outlined,
                            label: 'Pickup Branch',
                            value: pickupBranch!,
                            accent: true,
                          ),
                        ],
                        _divider(isDark),
                        _confirmRow(
                          isDark: isDark,
                          icon: Icons.payments_outlined,
                          label: 'Statement Fee',
                          value: 'GH₵ ${_charges.toStringAsFixed(2)}',
                          accent: true,
                        ),
                      ],
                    ),
                  ),
                  if (statementType == 'ordinary' && pickupBranch != null) ...[
                    SizedBox(height: 1.5.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            color: Color(0xFFF59E0B),
                            size: 16,
                          ),
                          SizedBox(width: 2.5.w),
                          Expanded(
                            child: Text(
                              'Ordinary statements are processed in 3–5 working days for pickup.',
                              style: GoogleFonts.inter(
                                fontSize: 7.sp,
                                color: isDark
                                    ? Colors.white54
                                    : const Color(0xFF6B7280),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          _buildStickyActions(context, isDark),
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
                        builder: (_) => _StatementResultScreen(
                          accountNo: accountNo,
                          accountName: accountName,
                          statementType: statementType,
                          startDate: startDate,
                          endDate: endDate,
                          pickupBranch: pickupBranch,
                          charges: _charges,
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
                    colors: [
                      accentColor,
                      accentColor.withValues(alpha: 0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      'Authorize & Request',
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
              child: Text(
                'Go Back',
                style: GoogleFonts.inter(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white54 : const Color(0xFF6B7280),
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
    bool mono = false,
    bool accent = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.9.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon, color: accentColor, size: 14),
            ),
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 7.sp,
                    color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                  ),
                ),
                SizedBox(height: 0.2.h),
                Text(
                  value,
                  style: mono
                      ? GoogleFonts.jetBrainsMono(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w600,
                          color: accent
                              ? accentColor
                              : (isDark
                                    ? Colors.white
                                    : const Color(0xFF111827)),
                        )
                      : GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: accent
                              ? accentColor
                              : (isDark
                                    ? Colors.white
                                    : const Color(0xFF111827)),
                        ),
                ),
              ],
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
                ),
                child: const Center(
                  child: Icon(
                    Icons.fact_check_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
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
                      'Full Statement · Step 3 of 4',
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
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 12,
                      color: Color(0xFF34D399),
                    ),
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
