import 'package:flutter/material.dart';

enum ActivityModule { agency, merchant, smartBranch }

class ActivityHelpers {
  ActivityHelpers._();

  static const _monetaryTypes = {
    'deposit',
    'withdrawal',
    'transfer',
    'same_bank_transfer',
    'other_bank_transfer',
    'qr_deposit',
    'qr_withdrawal',
    'reverse_transaction',
    'card_payment',
    'qr_transaction',
    'cash_withdrawal',
    'airtime',
    'electricity',
    'water',
    'cheque_withdrawal',
    'counter_cheque',
    'fixed_deposit',
    'payment',
    'utility',
  };

  static const _debitTypes = {
    'withdrawal',
    'other_bank_transfer',
    'qr_withdrawal',
    'cash_withdrawal',
    'reverse_transaction',
    'cheque_withdrawal',
    'counter_cheque',
  };

  static const _labels = {
    'deposit': 'Cash Deposit',
    'withdrawal': 'Cash Withdrawal',
    'transfer': 'Same Bank Transfer',
    'same_bank_transfer': 'Same Bank Transfer',
    'other_bank_transfer': 'Other Bank Transfer',
    'qr_deposit': 'QR Deposit',
    'qr_withdrawal': 'QR Withdraw',
    'open_account': 'Open Account',
    'balance_enquiry': 'Balance Enquiry',
    'mini_statement': 'Mini Statement',
    'full_statement': 'Full Statement',
    'atm_card': 'ATM Card Request',
    'cheque_book': 'Cheque Book Request',
    'block_card': 'Block Card',
    'stop_cheque': 'Stop Cheque',
    'reverse_transaction': 'Reverse Transaction',
    'card_payment': 'POS Payment',
    'qr_transaction': 'QR Payment',
    'cash_withdrawal': 'Cash Withdrawal',
    'airtime': 'Airtime',
    'electricity': 'Electricity Bill',
    'water': 'Water Bill',
    'export_report': 'Export Report',
    'customer_update': 'Customer Update',
    'account_block': 'Account Block',
    'lien': 'Lien Placement',
    'reactivation': 'Account Reactivation',
    'close_account': 'Close Account',
    'cheque_withdrawal': 'Cheque Withdrawal',
    'counter_cheque': 'Counter Cheque',
    'fixed_deposit': 'Fixed Deposit',
    'payment': 'Payment Received',
    'utility': 'Utility Payment',
    'account': 'Open Account',
  };

  static bool isMonetary(Map<String, dynamic> activity) {
    if (activity['amount'] == null) return false;
    final type = activity['type'] as String?;
    return type != null && _monetaryTypes.contains(type);
  }

  static bool isDebit(String? type) =>
      type != null && _debitTypes.contains(type);

  static String labelFor(Map<String, dynamic> activity) {
    final label = activity['label'] as String?;
    if (label != null && label.isNotEmpty) return label;

    final desc = activity['desc'] as String?;
    if (desc != null && desc.isNotEmpty) return desc;

    final type = activity['type'] as String?;
    if (type == null) return 'Activity';
    return _labels[type] ?? _titleCase(type.replaceAll('_', ' '));
  }

  static String personName(
    Map<String, dynamic> activity, {
    String fallback = 'Unknown',
  }) {
    return (activity['name'] ??
            activity['merchant'] ??
            activity['customer']) as String? ??
        fallback;
  }

  static String subtitleFor(
    Map<String, dynamic> activity, {
    required ActivityModule module,
    required bool compact,
  }) {
    final label = labelFor(activity);
    final date = activity['date'] as String? ?? '';
    final time = activity['time'] as String?;
    final teller = activity['teller'] as String?;

    if (module == ActivityModule.smartBranch && compact && teller != null) {
      return '$label • $teller • ${time ?? date}';
    }

    if (compact && time != null && time.isNotEmpty) {
      return '$label • $date, $time';
    }

    if (module == ActivityModule.merchant && !compact) {
      final paymentMethod = activity['paymentMethod'] as String?;
      if (paymentMethod != null && isMonetary(activity)) {
        return '$label • $paymentMethod • $date';
      }
    }

    return '$label • $date';
  }

  static String trailingText(Map<String, dynamic> activity) {
    if (isMonetary(activity)) {
      final amount = (activity['amount'] as num?)?.toDouble() ?? 0;
      final type = activity['type'] as String?;
      final prefix = isDebit(type) ? '-' : '+';
      return '$prefix GH₵${formatAmount(amount)}';
    }

    final detail = activity['detail'] as String?;
    if (detail != null && detail.isNotEmpty) return detail;

    final reference = activity['reference'] as String?;
    if (reference != null && reference.isNotEmpty) {
      return reference.length > 14 ? reference.substring(0, 14) : reference;
    }

    return '—';
  }

  static bool trailingIsAmount(Map<String, dynamic> activity) =>
      isMonetary(activity);

  static String statusLabel(Map<String, dynamic> activity) {
    final settlementStatus = activity['settlementStatus'] as String?;
    if (settlementStatus != null && settlementStatus.isNotEmpty) {
      return settlementStatus;
    }
    return ((activity['status'] as String?) ?? 'unknown').toUpperCase();
  }

  static Color statusColor(Map<String, dynamic> activity) {
    final settlementStatus = activity['settlementStatus'] as String?;
    if (settlementStatus != null) {
      switch (settlementStatus) {
        case 'Settled':
          return const Color(0xFF10B981);
        case 'Pending':
          return const Color(0xFFF59E0B);
        default:
          return const Color(0xFF6366F1);
      }
    }

    switch (activity['status']) {
      case 'success':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFFEF4444);
    }
  }

  static IconData iconFor(String? type) {
    switch (type) {
      case 'deposit':
        return Icons.arrow_downward;
      case 'withdrawal':
      case 'cash_withdrawal':
        return Icons.arrow_upward;
      case 'transfer':
      case 'same_bank_transfer':
        return Icons.swap_horiz;
      case 'other_bank_transfer':
        return Icons.send;
      case 'qr_deposit':
        return Icons.qr_code_scanner;
      case 'qr_withdrawal':
      case 'qr_transaction':
        return Icons.qr_code;
      case 'open_account':
      case 'account':
        return Icons.person_add;
      case 'balance_enquiry':
        return Icons.account_balance_wallet;
      case 'mini_statement':
        return Icons.receipt;
      case 'full_statement':
        return Icons.description;
      case 'atm_card':
        return Icons.credit_card;
      case 'cheque_book':
        return Icons.book;
      case 'block_card':
      case 'account_block':
        return Icons.block;
      case 'stop_cheque':
        return Icons.cancel;
      case 'reverse_transaction':
        return Icons.undo;
      case 'card_payment':
      case 'payment':
        return Icons.credit_card;
      case 'airtime':
        return Icons.phone_android;
      case 'electricity':
        return Icons.flash_on;
      case 'water':
        return Icons.water_drop;
      case 'export_report':
        return Icons.download;
      case 'customer_update':
        return Icons.edit;
      case 'lien':
        return Icons.lock;
      case 'reactivation':
        return Icons.refresh;
      case 'close_account':
        return Icons.cancel_outlined;
      case 'cheque_withdrawal':
      case 'counter_cheque':
        return Icons.receipt_long;
      case 'fixed_deposit':
        return Icons.savings;
      case 'utility':
        return Icons.receipt_long;
      default:
        return Icons.receipt;
    }
  }

  static Color headerGradientStart(Map<String, dynamic> activity) {
    if (!isMonetary(activity)) return const Color(0xFF6366F1);
    final type = activity['type'] as String?;
    if (type == 'deposit' ||
        type == 'qr_deposit' ||
        type == 'card_payment' ||
        type == 'qr_transaction' ||
        type == 'payment') {
      return const Color(0xFF059669);
    }
    if (isDebit(type)) return const Color(0xFFDC2626);
    return const Color(0xFF6366F1);
  }

  static Color headerGradientEnd(Map<String, dynamic> activity) {
    if (!isMonetary(activity)) return const Color(0xFF818CF8);
    final type = activity['type'] as String?;
    if (type == 'deposit' ||
        type == 'qr_deposit' ||
        type == 'card_payment' ||
        type == 'qr_transaction' ||
        type == 'payment') {
      return const Color(0xFF10B981);
    }
    if (isDebit(type)) return const Color(0xFFEF4444);
    return const Color(0xFF818CF8);
  }

  static String headerPrimaryText(Map<String, dynamic> activity) {
    if (isMonetary(activity)) {
      final amount = (activity['amount'] as num?)?.toDouble() ?? 0;
      final type = activity['type'] as String?;
      final prefix = isDebit(type) ? '-' : '+';
      return '$prefix GH₵ ${formatAmount(amount)}';
    }
    return activity['detail'] as String? ?? labelFor(activity);
  }

  static String headerSecondaryText(Map<String, dynamic> activity) =>
      labelFor(activity).toUpperCase();

  static IconData headerIcon(Map<String, dynamic> activity) {
    if (!isMonetary(activity)) return iconFor(activity['type'] as String?);
    final type = activity['type'] as String?;
    if (type == 'deposit' ||
        type == 'qr_deposit' ||
        type == 'card_payment' ||
        type == 'qr_transaction' ||
        type == 'payment') {
      return Icons.south_west;
    }
    if (isDebit(type)) return Icons.north_east;
    return iconFor(type);
  }

  static String formatAmount(double amount) {
    if (amount >= 1000) {
      final formatted = amount.toStringAsFixed(0);
      final result = StringBuffer();
      var count = 0;
      for (var i = formatted.length - 1; i >= 0; i--) {
        count++;
        result.write(formatted[i]);
        if (count % 3 == 0 && i > 0) result.write(',');
      }
      return result.toString().split('').reversed.join();
    }
    return amount.toStringAsFixed(2);
  }

  static String _titleCase(String value) {
    return value
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}
