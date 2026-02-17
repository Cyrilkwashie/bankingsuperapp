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
    final months = [
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
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String get _statementTypeLabel => statementType == 'electronic'
      ? 'Electronic Statement'
      : 'Ordinary Statement';

  double get _charges => statementType == 'electronic' ? 5.00 : 10.00;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0D1117)
          : const Color(0xFFF8FAFC),
      body: Column(
        children: [
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
                      'Confirm Request',
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
                  _buildStatementTypeCard(isDark),
                  SizedBox(height: 2.h),
                  _buildDetailsCard(isDark),
                  SizedBox(height: 2.h),
                  _buildChargesCard(isDark),
                  SizedBox(height: 3.h),
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

  Widget _buildStatementTypeCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2.5.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : [
                  accentColor.withValues(alpha: 0.06),
                  accentColor.withValues(alpha: 0.02),
                ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.15 : 0.12),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                statementType == 'electronic'
                    ? Icons.email_rounded
                    : Icons.description_rounded,
                color: accentColor,
                size: 28,
              ),
            ),
          ),
          SizedBox(height: 1.5.h),
          Text(
            _statementTypeLabel,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A1D23),
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 0.5.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.3.h),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'For: $accountName',
              style: GoogleFonts.inter(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
                color: accentColor,
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
            'Request Details',
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
          _detailRow('Statement Type', _statementTypeLabel, isDark),
          _divider(isDark),
          _detailRow('Start Date', _formatDate(startDate), isDark),
          _divider(isDark),
          _detailRow('End Date', _formatDate(endDate), isDark),
          if (statementType == 'ordinary' && pickupBranch != null) ...[
            _divider(isDark),
            SizedBox(height: 1.h),
            _buildPickupMessage(isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildPickupMessage(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pickup Required',
          style: GoogleFonts.inter(
            fontSize: 8.8.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        SizedBox(height: 0.8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded, color: accentColor, size: 14),
              SizedBox(width: 1.w),
              Flexible(
                child: Text(
                  'Pickup: $pickupBranch',
                  style: GoogleFonts.inter(
                    fontSize: 7.5.sp,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 0.8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: Color(0xFFF59E0B),
                size: 14,
              ),
              SizedBox(width: 1.w),
              Text(
                'Processing: 3–5 working days',
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
    );
  }

  Widget _detailRow(
    String label,
    String value,
    bool isDark, {
    double? valueSize,
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
                fontSize: valueSize ?? 9.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF1A1D23),
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

  Widget _buildChargesCard(bool isDark) {
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
            'Charges',
            style: GoogleFonts.inter(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 1.5.h),
          _detailRow(
            'Statement Fee',
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
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                Text(
                  'GH₵ ${_charges.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
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
          onAuthenticated: () {
            // Navigate to statement result screen
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
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accentColor, accentColor.withValues(alpha: 0.85)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Confirm & Request',
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

// ══════════════════════════════════════════════════════════════
// ── Statement Result Screen (fetches and displays statement) ──
// ══════════════════════════════════════════════════════════════
