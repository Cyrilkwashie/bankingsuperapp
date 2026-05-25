part of 'agency_mini_statement_screen.dart';

class _MiniStatementOtpScreen extends StatelessWidget {
  final String customerPhone;
  final String destinationPhone;
  final String accountNo;
  final String accountName;
  final String accountBalance;
  final String accountType;
  final int txnCount;
  final Color accentColor;
  final List<Color> gradientColors;

  const _MiniStatementOtpScreen({
    required this.customerPhone,
    required this.destinationPhone,
    required this.accountNo,
    required this.accountName,
    required this.accountBalance,
    required this.accountType,
    required this.txnCount,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return AgencyOtpVerificationScreen(
      customerPhone: customerPhone,
      accentColor: accentColor,
      gradientColors: gradientColors,
      headerSubtitle: 'Mini Statement',
      securityMessage:
          'Customer must authorise before the mini statement is generated.',
      currentStep: 2,
      stepLabels: const ['Lookup', 'OTP', 'Confirm', 'Done'],
      onVerified: (context) async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _MiniStatementConfirmationScreen(
              accountNo: accountNo,
              accountName: accountName,
              accountBalance: accountBalance,
              accountType: accountType,
              txnCount: txnCount,
              destinationPhone: destinationPhone,
              accentColor: accentColor,
              gradientColors: gradientColors,
            ),
          ),
        );
      },
    );
  }
}
