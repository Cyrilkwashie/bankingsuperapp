part of 'agency_full_statement_screen.dart';

class _StatementOtpScreen extends StatelessWidget {
  final String customerPhone;
  final String accountNo;
  final String accountName;
  final String accountBalance;
  final String statementType;
  final DateTime startDate;
  final DateTime endDate;
  final String? pickupBranch;
  final Color accentColor;
  final List<Color> gradientColors;

  const _StatementOtpScreen({
    required this.customerPhone,
    required this.accountNo,
    required this.accountName,
    required this.accountBalance,
    required this.statementType,
    required this.startDate,
    required this.endDate,
    required this.pickupBranch,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return AgencyOtpVerificationScreen(
      customerPhone: customerPhone,
      accentColor: accentColor,
      gradientColors: gradientColors,
      headerSubtitle: 'Full Statement',
      securityMessage:
          'This OTP verification protects the account from unauthorized statement requests.',
      currentStep: 2,
      stepLabels: const ['Lookup', 'OTP', 'Confirm', 'Done'],
      onVerified: (context) async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _StatementConfirmationScreen(
              accountNo: accountNo,
              accountName: accountName,
              accountBalance: accountBalance,
              statementType: statementType,
              startDate: startDate,
              endDate: endDate,
              pickupBranch: pickupBranch,
              accentColor: accentColor,
              gradientColors: gradientColors,
            ),
          ),
        );
      },
    );
  }
}
