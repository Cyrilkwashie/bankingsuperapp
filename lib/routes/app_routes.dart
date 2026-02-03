import 'package:flutter/material.dart';

import '../presentation/agency/dashboard/agency_banking_dashboard_screen.dart';
import '../presentation/agency/login/agency_login_screen.dart';
import '../presentation/agency/transaction_history/transaction_history_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/merchant/dashboard/merchant_banking_dashboard_screen.dart';
import '../presentation/merchant/login/merchant_login_screen.dart';
import '../presentation/merchant/transaction_history/merchant_transaction_history_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/shared/service_selection_screen/service_selection_screen.dart';
import '../presentation/shared/splash_screen/splash_screen.dart';
import '../presentation/smart_branch/dashboard/smart_branch_dashboard_screen.dart';
import '../presentation/smart_branch/login/smart_branch_login_screen.dart';

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
  static const String settings = '/settings-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    serviceSelection: (context) => const ServiceSelectionScreen(),
    login: (context) => const LoginScreen(),
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
    settings: (context) => const SettingsScreen(),
  };
}
