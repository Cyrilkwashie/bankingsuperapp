part of 'agency_stop_cheque_screen.dart';

class _StopChequeOtpScreen extends StatelessWidget {
  final String customerPhone;
  final String accountNo;
  final String accountName;
  final DateTime dateIssued;
  final String fromChequeNo;
  final String toChequeNo;
  final String beneficiaryName;
  final String amount;
  final String reason;
  final Color accentColor;
  final List<Color> gradientColors;

  const _StopChequeOtpScreen({
    required this.customerPhone,
    required this.accountNo,
    required this.accountName,
    required this.dateIssued,
    required this.fromChequeNo,
    required this.toChequeNo,
    required this.beneficiaryName,
    required this.amount,
    required this.reason,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return AgencyOtpVerificationScreen(
      customerPhone: customerPhone,
      accentColor: accentColor,
      gradientColors: gradientColors,
      headerSubtitle: 'Stop Cheque',
      securityMessage:
          'OTP verification is required to authorise the stop-cheque request.',
      currentStep: 2,
      stepLabels: const ['Details', 'Verify', 'Confirm'],
      onVerified: (context) async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _StopChequeConfirmationScreen(
              accountNo: accountNo,
              accountName: accountName,
              dateIssued: dateIssued,
              fromChequeNo: fromChequeNo,
              toChequeNo: toChequeNo,
              beneficiaryName: beneficiaryName,
              amount: amount,
              reason: reason,
              accentColor: accentColor,
              gradientColors: gradientColors,
            ),
          ),
        );
      },
    );
  }
}
