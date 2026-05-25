part of 'agency_atm_card_screen.dart';

class _AtmCardSuccessScreen extends StatelessWidget {
  final String cardType;
  final String accountName;
  final String pickupBranch;
  final Color accentColor;
  final List<Color> gradientColors;

  const _AtmCardSuccessScreen({
    required this.cardType,
    required this.accountName,
    required this.pickupBranch,
    required this.accentColor,
    required this.gradientColors,
  });

  static const Color _success = Color(0xFF059669);

  String get _referenceNo {
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ATC${ts.substring(ts.length - 8)}';
  }

  String _formatTimestamp(DateTime now) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]} ${now.year} · '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timestamp = _formatTimestamp(DateTime.now());

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(isDark),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 2.h),
              child: Column(
                children: [
                  _buildSuccessBadge(isDark),
                  SizedBox(height: 1.8.h),
                  Text(
                    'Request Submitted',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'ATM card request for $accountName has been submitted successfully.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 8.sp,
                      height: 1.4,
                      color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildReceiptCard(isDark, timestamp),
                ],
              ),
            ),
          ),
          _buildStickyActions(context, isDark),
        ],
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
              : gradientColors,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.6.h),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _success.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: _success.withValues(alpha: 0.28)),
                ),
                child: const Icon(
                  Icons.credit_card_outlined,
                  color: Color(0xFF34D399),
                  size: 19,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Complete',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'ATM Card Request',
                      style: GoogleFonts.inter(
                        fontSize: 7.5.sp,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              _successPill(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _successPill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: _success.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _success.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded, size: 11, color: Color(0xFF34D399)),
          SizedBox(width: 1.w),
          Text(
            'Success',
            style: GoogleFonts.inter(
              fontSize: 6.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF34D399),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessBadge(bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _success.withValues(alpha: isDark ? 0.08 : 0.06),
          ),
        ),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _success.withValues(alpha: 0.2),
                _success.withValues(alpha: 0.08),
              ],
            ),
            border: Border.all(color: _success.withValues(alpha: 0.25)),
            boxShadow: [
              BoxShadow(
                color: _success.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.check_rounded, color: _success, size: 32),
        ),
      ],
    );
  }

  Widget _buildReceiptCard(bool isDark, String timestamp) {
    return Container(
      width: double.infinity,
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
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.8.h),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: _success, width: 3)),
                gradient: LinearGradient(
                  colors: [
                    accentColor.withValues(alpha: isDark ? 0.1 : 0.05),
                    accentColor.withValues(alpha: isDark ? 0.03 : 0.01),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    cardType,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    'Card Request',
                    style: GoogleFonts.inter(
                      fontSize: 7.5.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
              child: Column(
                children: [
                  _buildReceiptRow('Account Holder', accountName, isDark),
                  _divider(isDark),
                  _buildReceiptRow('Pickup Branch', pickupBranch, isDark),
                  _divider(isDark),
                  _buildReceiptRow('Reference', _referenceNo, isDark, mono: true),
                  _divider(isDark),
                  _buildReceiptRow('Date & Time', timestamp, isDark),
                  _divider(isDark),
                  _buildReceiptRow('Processing', '3–5 working days', isDark),
                  _divider(isDark),
                  _buildReceiptRow('Status', 'Submitted', isDark, valueColor: _success),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF3F4F6),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value,
    bool isDark, {
    bool mono = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.7.h),
      child: Row(
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.6.h),
                child: Text(
                  'New Request',
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
