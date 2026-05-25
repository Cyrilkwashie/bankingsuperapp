part of 'agency_other_bank_transfer_screen.dart';

class _TransferOtpScreen extends StatelessWidget {
  final String customerPhone;
  final String senderAccountNo;
  final String senderName;
  final String senderBalance;
  final String beneficiaryAccountNo;
  final String beneficiaryName;
  final String beneficiaryBank;
  final String amount;
  final String transferredBy;
  final String narration;
  final String fixedNarration;
  final Color accentColor;
  final List<Color> gradientColors;

  const _TransferOtpScreen({
    required this.customerPhone,
    required this.senderAccountNo,
    required this.senderName,
    required this.senderBalance,
    required this.beneficiaryAccountNo,
    required this.beneficiaryName,
    required this.beneficiaryBank,
    required this.amount,
    required this.transferredBy,
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
      headerSubtitle: 'Other Bank Transfer',
      securityMessage:
          'This OTP verification protects against unauthorized transfers.',
      currentStep: 2,
      stepLabels: const ['Details', 'Verify'],
      onVerified: (context) async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _TransferReceiptScreen(
              senderAccountNo: senderAccountNo,
              senderName: senderName,
              senderBalance: senderBalance,
              beneficiaryAccountNo: beneficiaryAccountNo,
              beneficiaryName: beneficiaryName,
              beneficiaryBank: beneficiaryBank,
              amount: amount,
              transferredBy: transferredBy,
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
