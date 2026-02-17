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

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: SafeArea(child: Center(child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 4.h),
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
                  Icons.check_rounded,
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
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_rounded, color: accentColor, size: 14),
                  SizedBox(width: 1.w),
                  Flexible(
                    child: Text(
                      'Beneficiary: $beneficiaryName',
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
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
              decoration: BoxDecoration(
                color: const Color(0xFF059669).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.payments_rounded,
                    color: Color(0xFF059669),
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Flexible(
                    child: Text(
                      'Amount: GH\u20b5 $amount',
                      style: GoogleFonts.inter(
                        fontSize: 7.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF059669),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
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
                    Icons.receipt_long_rounded,
                    color: Color(0xFFF59E0B),
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Fee: $totalFee',
                    style: GoogleFonts.inter(
                      fontSize: 7.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.5.h),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
                Navigator.of(context).pop();
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
      ))),
    );
  }
}
