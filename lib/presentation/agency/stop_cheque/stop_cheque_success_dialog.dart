part of 'agency_stop_cheque_screen.dart';

class _StopChequeSuccessDialog extends StatelessWidget {
  final String fromChequeNo;
  final String toChequeNo;
  final String beneficiaryName;
  final String amount;
  final String totalFee;
  final int chequeCount;
  final Color accentColor;

  const _StopChequeSuccessDialog({
    required this.fromChequeNo,
    required this.toChequeNo,
    required this.beneficiaryName,
    required this.amount,
    required this.totalFee,
    required this.chequeCount,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      insetPadding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF059669).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF059669),
                  size: 36,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Request Submitted',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            SizedBox(height: 0.8.h),
            Text(
              'Stop-cheque request for $chequeCount cheque${chequeCount > 1 ? 's' : ''} ($fromChequeNo – $toChequeNo) has been submitted for processing.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white54 : const Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 1.5.h),

            // Summary chips
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _summaryRow('Beneficiary', beneficiaryName, isDark),
                  SizedBox(height: 0.5.h),
                  _summaryRow('Cheque Amount', 'GH₵ $amount', isDark),
                  SizedBox(height: 0.5.h),
                  _summaryRow('Processing Fee', totalFee, isDark),
                ],
              ),
            ),

            SizedBox(height: 2.5.h),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // dialog
                Navigator.of(context).pop(); // confirmation
                Navigator.of(context).pop(); // form
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentColor, accentColor.withValues(alpha: 0.85)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Done',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // dialog
                Navigator.of(context).pop(); // confirmation
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.8.h),
                child: Text(
                  'Submit Another Request',
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
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

  Widget _summaryRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 8.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1A1D23),
          ),
        ),
      ],
    );
  }
}
