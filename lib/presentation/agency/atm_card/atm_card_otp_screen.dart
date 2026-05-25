part of 'agency_atm_card_screen.dart';

class _AtmCardOtpScreen extends StatelessWidget {
  final String customerPhone;
  final String accountNo;
  final String accountName;
  final String cardType;
  final String displayName;
  final String pickupBranch;
  final Color accentColor;
  final List<Color> gradientColors;

  const _AtmCardOtpScreen({
    required this.customerPhone,
    required this.accountNo,
    required this.accountName,
    required this.cardType,
    required this.displayName,
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
      headerSubtitle: 'ATM Card',
      securityMessage:
          'This OTP verification protects the account from unauthorized card requests.',
      currentStep: 2,
      stepLabels: const ['Request', 'Verify', 'Confirm'],
      onVerified: (context) async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _AtmCardConfirmationScreen(
              accountNo: accountNo,
              accountName: accountName,
              cardType: cardType,
              displayName: displayName,
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
