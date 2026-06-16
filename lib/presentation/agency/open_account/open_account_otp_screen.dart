part of 'agency_open_account_screen.dart';

class _OpenAccountOtpScreen extends StatelessWidget {
  final String accountType;
  final String minDeposit;
  final _GhanaCardProfile ghanaCardProfile;
  final String phone;
  final String email;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountOtpScreen({
    required this.accountType,
    required this.minDeposit,
    required this.ghanaCardProfile,
    required this.phone,
    required this.email,
    required this.accentColor,
    required this.gradientColors,
  });

  void _handleWizardStepTap(BuildContext context, int targetStep) {
    _OpenAccountUi.handleWizardStepTap(
      context,
      currentStep: 1,
      targetStep: targetStep,
      onForwardStep: (step) => _openWizardStep(context, step),
    );
  }

  void _openWizardStep(BuildContext context, int step) {
    if (step == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => _OpenAccountFaceCaptureScreen(
            accountType: accountType,
            minDeposit: minDeposit,
            ghanaCardProfile: ghanaCardProfile,
            phone: phone,
            email: email,
            accentColor: accentColor,
            gradientColors: gradientColors,
          ),
        ),
      );
      return;
    }

    if (step >= 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => _OpenAccountPersonalScreen(
            accountType: accountType,
            minDeposit: minDeposit,
            ghanaCardProfile: ghanaCardProfile,
            phone: phone,
            email: email,
            verificationPhoto: null,
            accentColor: accentColor,
            gradientColors: gradientColors,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AgencyOtpVerificationScreen(
      customerPhone: phone,
      accentColor: accentColor,
      gradientColors: gradientColors,
      headerTitle: 'Verify OTP',
      headerSubtitle: 'Open Account · Step 1 of ${_OpenAccountUi.wizardStepCount}',
      securityMessage:
          'An OTP has been sent to the phone number you entered. '
          'Ask the customer to share the code to continue.',
      currentStep: 1,
      stepLabels: _OpenAccountUi.wizardLabels,
      onStepTap: (step) => _handleWizardStepTap(context, step),
      onVerified: (context) async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _OpenAccountFaceCaptureScreen(
              accountType: accountType,
              minDeposit: minDeposit,
              ghanaCardProfile: ghanaCardProfile,
              phone: phone,
              email: email,
              accentColor: accentColor,
              gradientColors: gradientColors,
            ),
          ),
        );
      },
    );
  }
}
