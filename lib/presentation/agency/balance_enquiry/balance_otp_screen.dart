part of 'agency_balance_enquiry_screen.dart';

class _BalanceOtpScreen extends StatelessWidget {
  final String customerPhone;
  final String accountNo;
  final String accountName;
  final String accountBalance;
  final String accountType;
  final String enquiryType;
  final int? txnCount;
  final DateTime? txnStartDate;
  final DateTime? txnEndDate;
  final String destinationPhone;
  final Color accentColor;
  final List<Color> gradientColors;

  const _BalanceOtpScreen({
    required this.customerPhone,
    required this.accountNo,
    required this.accountName,
    required this.accountBalance,
    required this.accountType,
    required this.enquiryType,
    required this.txnCount,
    required this.txnStartDate,
    required this.txnEndDate,
    required this.destinationPhone,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return AgencyOtpVerificationScreen(
      customerPhone: customerPhone,
      accentColor: accentColor,
      gradientColors: gradientColors,
      headerSubtitle: 'Balance Enquiry',
      securityMessage:
          'Customer must authorise before balance data is sent.',
      currentStep: 2,
      stepLabels: const ['Lookup', 'OTP', 'Confirm', 'Done'],
      onVerified: (context) async {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _BalanceConfirmationScreen(
              accountNo: accountNo,
              accountName: accountName,
              accountBalance: accountBalance,
              accountType: accountType,
              enquiryType: enquiryType,
              txnCount: txnCount,
              txnStartDate: txnStartDate,
              txnEndDate: txnEndDate,
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
