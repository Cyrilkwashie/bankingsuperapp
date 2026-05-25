part of 'agency_reverse_transaction_screen.dart';

class _ReverseOtpScreen extends StatelessWidget {
  final _ReverseTxn txn;
  final String reason;
  final String narration;
  final Color accentColor;
  final List<Color> gradientColors;

  const _ReverseOtpScreen({
    required this.txn,
    required this.reason,
    required this.narration,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return AgencyOtpVerificationScreen(
      customerPhone: txn.phone,
      accentColor: accentColor,
      gradientColors: gradientColors,
      headerSubtitle: 'Reverse Transaction',
      securityMessage:
          'Ask the customer for the OTP sent to ${AgencyOtpVerificationScreen.maskPhone(txn.phone)} to authorise this reversal.',
      currentStep: 2,
      stepLabels: const ['Find', 'Verify', 'Confirm'],
      onVerified: (context) async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _ReverseConfirmationScreen(
              txn: txn,
              reason: reason,
              narration: narration,
              accentColor: accentColor,
              gradientColors: gradientColors,
            ),
          ),
        );
      },
    );
  }
}
