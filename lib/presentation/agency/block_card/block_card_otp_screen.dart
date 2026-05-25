part of 'agency_block_card_screen.dart';

class _BlockCardOtpScreen extends StatelessWidget {
  final String customerPhone;
  final String accountNo;
  final String accountName;
  final String cardType;
  final String cardNumber;
  final String reason;
  final Color accentColor;
  final List<Color> gradientColors;

  const _BlockCardOtpScreen({
    required this.customerPhone,
    required this.accountNo,
    required this.accountName,
    required this.cardType,
    required this.cardNumber,
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
      headerSubtitle: 'Block Card',
      securityMessage:
          'OTP verification is required to authorise card blocking. This action cannot be undone.',
      currentStep: 2,
      stepLabels: const ['Details', 'Verify', 'Confirm'],
      onVerified: (context) async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _BlockCardConfirmationScreen(
              accountNo: accountNo,
              accountName: accountName,
              cardType: cardType,
              cardNumber: cardNumber,
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
