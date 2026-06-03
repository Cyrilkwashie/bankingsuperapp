import 'banking_service_type.dart';

class AppUser {
  final String username;
  final String displayName;
  final Set<BankingServiceType> allowedServices;

  const AppUser({
    required this.username,
    required this.displayName,
    required this.allowedServices,
  });

  bool canAccess(BankingServiceType service) =>
      allowedServices.contains(service);
}
