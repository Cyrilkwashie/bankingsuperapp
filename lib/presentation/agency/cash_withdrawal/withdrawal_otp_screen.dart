part of 'agency_cash_withdrawal_screen.dart';

class _WithdrawalOtpScreen extends StatelessWidget {
  final String customerPhone;
  final String accountNo;
  final String accountName;
  final String accountBalance;
  final String amount;
  final String withdrawnBy;
  final String withdrawerTel;
  final String narration;
  final String fixedNarration;
  final Color accentColor;
  final List<Color> gradientColors;

  const _WithdrawalOtpScreen({
    required this.customerPhone,
    required this.accountNo,
    required this.accountName,
    required this.accountBalance,
    required this.amount,
    required this.withdrawnBy,
    required this.withdrawerTel,
    required this.narration,
    required this.fixedNarration,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return AgencyOtpVerificationScreen(
      customerPhone: customerPhone,
      accentColor: accentColor,
      gradientColors: gradientColors,
      headerSubtitle: 'Cash Withdrawal',
      securityMessage:
          'This OTP verification protects your account from unauthorized withdrawals.',
      currentStep: 2,
      stepLabels: const ['Account', 'Verify'],
      onVerified: (context) async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _WithdrawalReceiptScreen(
              accountNo: accountNo,
              accountName: accountName,
              accountBalance: accountBalance,
              amount: amount,
              withdrawnBy: withdrawnBy,
              withdrawerTel: withdrawerTel,
              narration: narration,
              fixedNarration: fixedNarration,
              accentColor: accentColor,
              gradientColors: gradientColors,
            ),
          ),
        );
      },
    );
  }
}
