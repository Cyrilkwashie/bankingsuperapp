part of 'agency_cash_deposit_screen.dart';

class _InsufficientFundsDialog extends StatelessWidget {
  final String balance;
  final String required;
  final String balanceLabel;
  final Color accentColor;

  const _InsufficientFundsDialog({
    required this.balance,
    required this.required,
    this.balanceLabel = 'Available Balance',
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const errorColor = Color(0xFFDC2626);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161B22) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: errorColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: errorColor.withValues(alpha: 0.2)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: errorColor,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Insufficient Float',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              SizedBox(height: 0.8.h),
              Text(
                'Your agent float does not have enough funds to process this deposit.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                  height: 1.45,
                ),
              ),
              SizedBox(height: 2.5.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Column(
                  children: [
                    _amountRow(balanceLabel, balance, isDark),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Divider(
                        height: 1,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    _amountRow('Required', required, isDark, highlight: true),
                  ],
                ),
              ),
              SizedBox(height: 2.5.h),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
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
                      'Go Back',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _amountRow(
    String label,
    String value,
    bool isDark, {
    bool highlight = false,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: highlight ? 11.sp : 9.5.sp,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
            color: highlight
                ? const Color(0xFFDC2626)
                : (isDark ? Colors.white : const Color(0xFF111827)),
          ),
        ),
      ],
    );
  }
}
