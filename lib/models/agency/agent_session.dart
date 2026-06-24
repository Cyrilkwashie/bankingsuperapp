class AgentSession {
  final String username;
  final String agentName;
  final String accountNo;
  final String availableBalance;
  final String branchCode;
  final String branchName;
  final String bankId;
  final String bankType;
  final String loginFlag;
  final String responseCode;
  final String message;

  const AgentSession({
    required this.username,
    required this.agentName,
    required this.accountNo,
    required this.availableBalance,
    required this.branchCode,
    required this.branchName,
    required this.bankId,
    required this.bankType,
    required this.loginFlag,
    required this.responseCode,
    required this.message,
  });

  factory AgentSession.fromJson(
    Map<String, dynamic> json, {
    required String username,
  }) {
    return AgentSession(
      username: username,
      agentName: json['agent_name']?.toString() ?? '',
      accountNo: json['account_no']?.toString() ?? '',
      availableBalance: json['available_balance']?.toString() ?? '0',
      branchCode: json['branch_code']?.toString() ?? '',
      branchName: json['branch_name']?.toString() ?? '',
      bankId: json['bank_id_v']?.toString() ?? '',
      bankType: json['bank_type_v']?.toString() ?? '',
      loginFlag: json['login_flag']?.toString() ?? '',
      responseCode: json['responsecode']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'agent_name': agentName,
    'account_no': accountNo,
    'available_balance': availableBalance,
    'branch_code': branchCode,
    'branch_name': branchName,
    'bank_id_v': bankId,
    'bank_type_v': bankType,
    'login_flag': loginFlag,
    'responsecode': responseCode,
    'message': message,
  };

  factory AgentSession.fromStoredJson(Map<String, dynamic> json) {
    return AgentSession(
      username: json['username']?.toString() ?? '',
      agentName: json['agent_name']?.toString() ?? '',
      accountNo: json['account_no']?.toString() ?? '',
      availableBalance: json['available_balance']?.toString() ?? '0',
      branchCode: json['branch_code']?.toString() ?? '',
      branchName: json['branch_name']?.toString() ?? '',
      bankId: json['bank_id_v']?.toString() ?? '',
      bankType: json['bank_type_v']?.toString() ?? '',
      loginFlag: json['login_flag']?.toString() ?? '',
      responseCode: json['responsecode']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  String get initials {
    final parts = agentName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return username.isNotEmpty ? username[0].toUpperCase() : 'A';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String get displayBranch {
    if (branchName.isNotEmpty && branchCode.isNotEmpty) {
      return '$branchName ($branchCode)';
    }
    if (branchName.isNotEmpty) return branchName;
    if (branchCode.isNotEmpty) return branchCode;
    return '—';
  }

  String get displayAccountNo => accountNo.isNotEmpty ? accountNo : '—';

  String get maskedAccountNo {
    if (accountNo.length <= 4) return accountNo;
    final lastFour = accountNo.substring(accountNo.length - 4);
    return '*** *** $lastFour';
  }

  String get formattedBalance {
    final value = double.tryParse(availableBalance.replaceAll(',', ''));
    if (value == null) {
      return availableBalance.isEmpty ? 'GH₵ 0.00' : 'GH₵ $availableBalance';
    }

    final fixed = value.toStringAsFixed(2);
    final split = fixed.split('.');
    final intDigits = split[0];
    final buffer = StringBuffer('GH₵ ');
    for (var i = 0; i < intDigits.length; i++) {
      if (i > 0 && (intDigits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(intDigits[i]);
    }
    buffer.write('.${split[1]}');
    return buffer.toString();
  }
}
