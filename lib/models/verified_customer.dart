class VerifiedCustomer {
  final String name;
  final String accountNumber;
  final String primaryAccount;
  final String phone;
  final String status;
  final String? balance;
  final String photoAssetPath;
  final String signatureAssetPath;

  const VerifiedCustomer({
    required this.name,
    required this.accountNumber,
    required this.primaryAccount,
    required this.phone,
    required this.status,
    this.balance,
    required this.photoAssetPath,
    required this.signatureAssetPath,
  });
}
