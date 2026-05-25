part of 'agency_stop_cheque_screen.dart';

class _StopChequeSuccessScreen extends StatelessWidget {
  final String fromChequeNo;
  final String toChequeNo;
  final String beneficiaryName;
  final String amount;
  final String totalFee;
  final int chequeCount;
  final Color accentColor;
  final List<Color> gradientColors;

  const _StopChequeSuccessScreen({
    required this.fromChequeNo,
    required this.toChequeNo,
    required this.beneficiaryName,
    required this.amount,
    required this.totalFee,
    required this.chequeCount,
    required this.accentColor,
    required this.gradientColors,
  });

  static const Color _success = Color(0xFF059669);

  String get _referenceNo {
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    return 'STC${ts.substring(ts.length - 8)}';
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
    final chequeRange = '$fromChequeNo – $toChequeNo';

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
                    'Stop-cheque request for $chequeCount cheque${chequeCount > 1 ? 's' : ''} has been submitted for processing.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 8.sp,
                      height: 1.4,
                      color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildReceiptCard(
                    isDark: isDark,
                    amountLabel: 'Cheque Amount',
                    rows: [
                      _StopChequeReceiptRow('Beneficiary', beneficiaryName),
                      _StopChequeReceiptRow('Cheque Range', chequeRange, mono: true),
                      _StopChequeReceiptRow('Processing Fee', totalFee),
                      _StopChequeReceiptRow('Reference', _referenceNo, mono: true),
                      _StopChequeReceiptRow('Date & Time', timestamp),
                      _StopChequeReceiptRow(
                        'Status',
                        'Submitted',
                        valueColor: _success,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildStickyActions(
            context: context,
            isDark: isDark,
            primaryLabel: 'Done',
            secondaryLabel: 'Submit Another Request',
            onPrimary: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            onSecondary: () => Navigator.of(context).pop(),
          ),
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
                  Icons.block_rounded,
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
                      'Transaction Complete',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'Stop Cheque',
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

  Widget _buildReceiptCard({
    required bool isDark,
    required String amountLabel,
    required List<_StopChequeReceiptRow> rows,
  }) {
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
                border: Border(
                  left: BorderSide(color: _success, width: 3),
                ),
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
                    'GH₵ $amount',
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    amountLabel,
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
                  for (var i = 0; i < rows.length; i++) ...[
                    if (i > 0)
                      Divider(
                        height: 1,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : const Color(0xFFF3F4F6),
                      ),
                    _buildReceiptRow(rows[i], isDark),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(_StopChequeReceiptRow row, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.7.h),
      child: Row(
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              row.label,
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.value,
              style: row.mono
                  ? GoogleFonts.jetBrainsMono(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w500,
                      color: row.valueColor ??
                          (isDark ? Colors.white : const Color(0xFF111827)),
                    )
                  : GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: row.valueColor ??
                          (isDark ? Colors.white : const Color(0xFF111827)),
                    ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyActions({
    required BuildContext context,
    required bool isDark,
    required String primaryLabel,
    required String secondaryLabel,
    required VoidCallback onPrimary,
    required VoidCallback onSecondary,
  }) {
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
              onTap: onPrimary,
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
                    primaryLabel,
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
              onTap: onSecondary,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.6.h),
                child: Text(
                  secondaryLabel,
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
