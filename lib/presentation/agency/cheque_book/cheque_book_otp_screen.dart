part of 'agency_cheque_book_screen.dart';

class _ChequeBookOtpScreen extends StatelessWidget {
  final String customerPhone;
  final String accountNo;
  final String accountName;
  final String numberOfLeaves;
  final String pickupBranch;
  final Color accentColor;
  final List<Color> gradientColors;

  const _ChequeBookOtpScreen({
    required this.customerPhone,
    required this.accountNo,
    required this.accountName,
    required this.numberOfLeaves,
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
      headerSubtitle: 'Cheque Book',
      securityMessage:
          'This OTP verification protects the account from unauthorized cheque book requests.',
      currentStep: 2,
      stepLabels: const ['Details', 'Verify', 'Confirm'],
      onVerified: (context) async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _ChequeBookConfirmationScreen(
              accountNo: accountNo,
              accountName: accountName,
              numberOfLeaves: numberOfLeaves,
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
