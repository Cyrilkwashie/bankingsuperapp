import '../models/app_user.dart';
import '../models/banking_service_type.dart';
import '../routes/app_routes.dart';

class MockAppAuth {
  MockAppAuth._();

  static AppUser? _currentUser;

  static AppUser? get currentUser => _currentUser;

  static bool get isSignedIn => _currentUser != null;

  static const _allServices = {
    BankingServiceType.smartBranch,
    BankingServiceType.agency,
    BankingServiceType.merchant,
  };

  static const _accounts = {
    'cyril': _MockAccount(
      password: '1',
      displayName: 'Cyril',
      allowedServices: _allServices,
    ),
    'grace': _MockAccount(
      password: '2',
      displayName: 'Grace',
      allowedServices: {BankingServiceType.agency},
    ),
    'obed': _MockAccount(
      password: '3',
      displayName: 'Obed',
      allowedServices: {
        BankingServiceType.agency,
        BankingServiceType.merchant,
      },
    ),
  };

  static AppUser? authenticate({
    required String username,
    required String password,
  }) {
    final account = _accounts[username.trim().toLowerCase()];
    if (account == null || account.password != password.trim()) {
      return null;
    }

    _currentUser = AppUser(
      username: username.trim().toLowerCase(),
      displayName: account.displayName,
      allowedServices: account.allowedServices,
    );
    return _currentUser;
  }

  static void signOut() {
    _currentUser = null;
  }

  static bool canAccess(BankingServiceType service) =>
      _currentUser?.canAccess(service) ?? false;

  static String routeFor(BankingServiceType service) {
    switch (service) {
      case BankingServiceType.smartBranch:
        return AppRoutes.smartBranchDashboard;
      case BankingServiceType.agency:
        return AppRoutes.agencyBankingDashboard;
      case BankingServiceType.merchant:
        return AppRoutes.merchantBankingDashboard;
    }
  }

  /// Returns service selection when user has multiple services, otherwise
  /// the single allowed dashboard route.
  static String? postLoginRoute() {
    final user = _currentUser;
    if (user == null || user.allowedServices.isEmpty) return null;

    if (user.allowedServices.length > 1) {
      return AppRoutes.serviceSelection;
    }

    return routeFor(user.allowedServices.first);
  }
}

class _MockAccount {
  final String password;
  final String displayName;
  final Set<BankingServiceType> allowedServices;

  const _MockAccount({
    required this.password,
    required this.displayName,
    required this.allowedServices,
  });
}
