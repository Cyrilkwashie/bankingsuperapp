import 'package:flutter/material.dart';

import '../presentation/agency/dashboard/agency_banking_dashboard_screen.dart';
import '../presentation/agency/locations/agency_locations_screen.dart';
import '../presentation/agency/login/agency_login_screen.dart';
import '../presentation/agency/settings/agency_settings_screen.dart';
import '../presentation/agency/transaction_history/transaction_history_screen.dart';
import '../presentation/merchant/dashboard/merchant_banking_dashboard_screen.dart';
import '../presentation/merchant/login/merchant_login_screen.dart';
import '../presentation/merchant/settings/merchant_settings_screen.dart';
import '../presentation/merchant/transaction_history/merchant_transaction_history_screen.dart';
import '../presentation/shared/service_selection_screen/service_selection_screen.dart';
import '../presentation/shared/splash_screen/splash_screen.dart';
import '../presentation/smart_branch/dashboard/smart_branch_dashboard_screen.dart';
import '../presentation/smart_branch/login/smart_branch_login_screen.dart';
import '../presentation/smart_branch/settings/smart_branch_settings_screen.dart';
import '../presentation/agency/transactions/agency_transactions_screen.dart';
import '../presentation/agency/cash_deposit/agency_cash_deposit_screen.dart';
import '../presentation/agency/cash_withdrawal/agency_cash_withdrawal_screen.dart';
import '../presentation/agency/same_bank_transfer/agency_same_bank_transfer_screen.dart';
import '../presentation/agency/other_bank_transfer/agency_other_bank_transfer_screen.dart';
import '../presentation/agency/qr_deposit/agency_qr_deposit_screen.dart';
import '../presentation/agency/qr_withdrawal/agency_qr_withdrawal_screen.dart';
import '../presentation/agency/full_statement/agency_full_statement_screen.dart';
import '../presentation/agency/atm_card/agency_atm_card_screen.dart';
import '../presentation/agency/cheque_book/agency_cheque_book_screen.dart';
import '../presentation/agency/block_card/agency_block_card_screen.dart';
import '../presentation/agency/stop_cheque/agency_stop_cheque_screen.dart';
import '../presentation/agency/balance_enquiry/agency_balance_enquiry_screen.dart';
import '../presentation/agency/mini_statement/agency_mini_statement_screen.dart';
import '../presentation/merchant/transactions/merchant_transactions_screen.dart';
import '../presentation/merchant/cash_withdrawal/merchant_cash_withdrawal_screen.dart';
import '../presentation/merchant/qr_withdrawal/merchant_qr_withdrawal_screen.dart';
import '../presentation/smart_branch/transactions/smart_branch_transactions_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String serviceSelection = '/service-selection-screen';
  static const String login = '/login-screen';
  static const String agencyLogin = '/agency-login-screen';
  static const String merchantLogin = '/merchant-login-screen';
  static const String smartBranchLogin = '/smart-branch-login-screen';
  static const String smartBranchDashboard = '/smart-branch-dashboard';
  static const String agencyBankingDashboard = '/agency-banking-dashboard';
  static const String merchantBankingDashboard = '/merchant-banking-dashboard';
  static const String merchantTransactionHistory =
      '/merchant-transaction-history-screen';
  static const String transactionHistory = '/transaction-history';
  static const String smartBranchSettings = '/smart-branch-settings';
  static const String agencySettings = '/agency-settings';
  static const String merchantSettings = '/merchant-settings';
  static const String smartBranchTransactions = '/smart-branch-transactions';
  static const String agencyTransactions = '/agency-transactions';
  static const String merchantTransactions = '/merchant-transactions';
  static const String agencyLocations = '/agency-locations';
  static const String agencyCashDeposit = '/agency-cash-deposit';
  static const String agencyCashWithdrawal = '/agency-cash-withdrawal';
  static const String agencySameBankTransfer = '/agency-same-bank-transfer';
  static const String agencyOtherBankTransfer = '/agency-other-bank-transfer';
  static const String agencyQrDeposit = '/agency-qr-deposit';
  static const String agencyQrWithdrawal = '/agency-qr-withdrawal';
  static const String agencyFullStatement = '/agency-full-statement';
  static const String agencyAtmCard = '/agency-atm-card';
  static const String agencyChequeBook = '/agency-cheque-book';
  static const String agencyBlockCard = '/agency-block-card';
  static const String agencyStopCheque = '/agency-stop-cheque';
  static const String agencyBalanceEnquiry = '/agency-balance-enquiry';
  static const String agencyMiniStatement = '/agency-mini-statement';
  static const String merchantCashWithdrawal = '/merchant-cash-withdrawal';
  static const String merchantQrWithdrawal = '/merchant-qr-withdrawal';

  static void replaceWithoutTransition(
    BuildContext context,
    String routeName,
  ) {
    final routeBuilder = routes[routeName];

    if (routeBuilder == null) {
      Navigator.of(context).pushReplacementNamed(routeName);
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        settings: RouteSettings(name: routeName),
        pageBuilder: (context, animation, secondaryAnimation) =>
            routeBuilder(context),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  static Map<String, WidgetBuilder> get routes => {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    serviceSelection: (context) => const ServiceSelectionScreen(),
    agencyLogin: (context) => const AgencyLoginScreen(),
    merchantLogin: (context) => const MerchantLoginScreen(),
    smartBranchLogin: (context) => const SmartBranchLoginScreen(),
    smartBranchDashboard: (context) => const SmartBranchDashboardScreen(),
    agencyBankingDashboard: (context) => const AgencyBankingDashboardScreen(),
    merchantBankingDashboard: (context) =>
        const MerchantBankingDashboardScreen(),
    merchantTransactionHistory: (context) =>
        const MerchantTransactionHistoryScreen(),
    transactionHistory: (context) => const TransactionHistoryScreen(),
    smartBranchSettings: (context) => const SmartBranchSettingsScreen(),
    agencySettings: (context) => const AgencySettingsScreen(),
    merchantSettings: (context) => const MerchantSettingsScreen(),
    smartBranchTransactions: (context) => const SmartBranchTransactionsScreen(),
    agencyTransactions: (context) => const AgencyTransactionsScreen(),
    merchantTransactions: (context) => const MerchantTransactionsScreen(),
    agencyLocations: (context) => const AgencyLocationsScreen(),
    agencyCashDeposit: (context) => const AgencyCashDepositScreen(),
    agencyCashWithdrawal: (context) => const AgencyCashWithdrawalScreen(),
    agencySameBankTransfer: (context) => const AgencySameBankTransferScreen(),
    agencyOtherBankTransfer: (context) => const AgencyOtherBankTransferScreen(),
    agencyQrDeposit: (context) => const AgencyQrDepositScreen(),
    agencyQrWithdrawal: (context) => const AgencyQrWithdrawalScreen(),
    agencyFullStatement: (context) => const AgencyFullStatementScreen(),
    agencyAtmCard: (context) => const AgencyAtmCardScreen(),
    agencyChequeBook: (context) => const AgencyChequeBookScreen(),
    agencyBlockCard: (context) => const AgencyBlockCardScreen(),
    agencyStopCheque: (context) => const AgencyStopChequeScreen(),
    agencyBalanceEnquiry: (context) => const AgencyBalanceEnquiryScreen(),
    agencyMiniStatement: (context) => const AgencyMiniStatementScreen(),
    merchantCashWithdrawal: (context) => const MerchantCashWithdrawalScreen(),
    merchantQrWithdrawal: (context) => const MerchantQrWithdrawalScreen(),
  };
}
