import 'package:flutter/material.dart';
import '../presentation/shared/splash_screen/splash_screen.dart';
import '../presentation/shared/service_selection_screen/service_selection_screen.dart';
import '../presentation/agency/login/agency_login_screen.dart';
import '../presentation/merchant/login/merchant_login_screen.dart';
import '../presentation/smart_branch/login/smart_branch_login_screen.dart';
import '../presentation/agency/dashboard/agency_banking_dashboard_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String serviceSelection = '/service-selection-screen';
  static const String agencyLogin = '/agency-login';
  static const String merchantLogin = '/merchant-login';
  static const String smartBranchLogin = '/smart-branch-login';
  static const String agencyBankingDashboard = '/agency-banking-dashboard';
  static const String settings = '/settings-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    serviceSelection: (context) => const ServiceSelectionScreen(),
    agencyLogin: (context) => const AgencyLoginScreen(),
    merchantLogin: (context) => const MerchantLoginScreen(),
    smartBranchLogin: (context) => const SmartBranchLoginScreen(),
    agencyBankingDashboard: (context) => const AgencyBankingDashboardScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
