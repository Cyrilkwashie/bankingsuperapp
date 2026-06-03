import '../models/verified_customer.dart';

class AgencyCustomerLookup {
  AgencyCustomerLookup._();

  static const _profiles = {
    '0012345678': {
      'phone': '232501234567',
      'primaryAccount': 'Savings',
      'photoAsset': 'assets/images/customers/kwame_photo.jpg',
      'signatureAsset': 'assets/images/customers/kwame_signature.svg',
    },
    '0023456789': {
      'phone': '232502345678',
      'primaryAccount': 'Current',
      'photoAsset': 'assets/images/customers/ama_photo.jpg',
      'signatureAsset': 'assets/images/customers/ama_signature.svg',
    },
    '0034567890': {
      'phone': '232503456789',
      'primaryAccount': 'Savings',
      'photoAsset': 'assets/images/customers/kofi_photo.jpg',
      'signatureAsset': 'assets/images/customers/kofi_signature.svg',
    },
    '0045678901': {
      'phone': '232504567890',
      'primaryAccount': 'Savings',
      'photoAsset': 'assets/images/customers/abena_photo.jpg',
      'signatureAsset': 'assets/images/customers/abena_signature.svg',
    },
    '0054321098': {
      'phone': '232504567890',
      'primaryAccount': 'Current',
      'photoAsset': 'assets/images/customers/abena_photo.jpg',
      'signatureAsset': 'assets/images/customers/abena_signature.svg',
    },
    '0067890123': {
      'phone': '232504567890',
      'primaryAccount': 'Fixed Deposit',
      'photoAsset': 'assets/images/customers/abena_photo.jpg',
      'signatureAsset': 'assets/images/customers/abena_signature.svg',
    },
    '0098765432': {
      'phone': '232502345678',
      'primaryAccount': 'Current',
      'photoAsset': 'assets/images/customers/ama_photo.jpg',
      'signatureAsset': 'assets/images/customers/ama_signature.svg',
    },
  };

  static VerifiedCustomer build({
    required String name,
    required String accountNumber,
    required String status,
    String primaryAccount = '',
    String phone = '',
    String? balance,
  }) {
    final profile = _profiles[accountNumber] ?? const {};
    final resolvedPrimary = primaryAccount.isNotEmpty
        ? primaryAccount
        : (profile['primaryAccount'] ?? 'Savings');
    final resolvedPhone =
        phone.isNotEmpty ? phone : (profile['phone'] ?? '');

    return VerifiedCustomer(
      name: name,
      accountNumber: accountNumber,
      primaryAccount: resolvedPrimary,
      phone: resolvedPhone,
      status: status,
      balance: balance,
      photoAssetPath:
          profile['photoAsset'] ?? 'assets/images/customers/kwame_photo.jpg',
      signatureAssetPath: profile['signatureAsset'] ??
          'assets/images/customers/kwame_signature.svg',
    );
  }

  static String maskAccountNo(String no) {
    if (no.length >= 7) {
      return '${no.substring(0, 3)} •••• ${no.substring(no.length - 3)}';
    }
    return no;
  }

  static String formatPhone(String phone) {
    if (phone.length == 12 && phone.startsWith('232')) {
      return '${phone.substring(0, 3)} ${phone.substring(3, 5)} ${phone.substring(5, 8)} ${phone.substring(8)}';
    }
    return phone;
  }

  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

}
