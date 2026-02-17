part of 'agency_other_bank_transfer_screen.dart';

class _InsufficientFundsDialog extends StatelessWidget {
  final String balance;
  final String required;
  final Color accentColor;

  const _InsufficientFundsDialog({
    required this.balance,
    required this.required,
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
                color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Color(0xFFDC2626),
                  size: 32,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Insufficient Balance',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            SizedBox(height: 0.8.h),
            Text(
              "The sender's account does not have sufficient funds for this transfer.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 8.5.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            SizedBox(height: 2.5.h),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E2328)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Go Back',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : const Color(0xFF374151),
                    ),
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
