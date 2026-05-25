part of 'agency_qr_withdrawal_screen.dart';

class _QrWithdrawalOtpScreen extends StatelessWidget {
  final String accountNo;
  final String accountName;
  final String amount;
  final String narration;
  final String fixedNarration;
  final String agentFloat;
  final Color accentColor;
  final List<Color> gradientColors;

  const _QrWithdrawalOtpScreen({
    required this.accountNo,
    required this.accountName,
    required this.amount,
    required this.narration,
    required this.fixedNarration,
    required this.agentFloat,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return AgencyOtpVerificationScreen(
      customerPhone: '0240000000',
      accentColor: accentColor,
      gradientColors: gradientColors,
      headerSubtitle: 'QR Withdrawal',
      securityMessage:
          'This OTP ensures only the account holder can authorise cash withdrawal from their account.',
      currentStep: 2,
      stepLabels: const ['Scan', 'Verify', 'Confirm'],
      onVerified: (context) async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _QrWithdrawalReceiptScreen(
              accountNo: accountNo,
              accountName: accountName,
              amount: amount,
              narration: narration,
              fixedNarration: fixedNarration,
              agentFloat: agentFloat,
              accentColor: accentColor,
              gradientColors: gradientColors,
            ),
          ),
        );
      },
    );
  }
}
