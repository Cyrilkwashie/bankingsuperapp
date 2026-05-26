import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
part 'statement_otp_screen.dart';
part 'statement_confirmation_screen.dart';
part 'statement_result_screen.dart';

class AgencyFullStatementScreen extends StatefulWidget {
  const AgencyFullStatementScreen({super.key});

  @override
  State<AgencyFullStatementScreen> createState() =>
      _AgencyFullStatementScreenState();
}

class _AgencyFullStatementScreenState extends State<AgencyFullStatementScreen>
    with SingleTickerProviderStateMixin {
  static const Color _accent = Color(0xFF2E8B8B);
  static const List<Color> _gradient = [Color(0xFF1B365D), Color(0xFF2E8B8B)];
  static const Color _success = Color(0xFF059669);
  static const double _fieldRadius = 10;

  EdgeInsets get _fieldPadding =>
      EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.95.h);

  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  bool _isLookingUp = false;
  bool _accountVerified = false;
  bool _accountNotFound = false;
  String _accountName = '';
  String _accountStatus = '';
  String _accountBalance = '';
  String _resolvedAccountNo = '';
  String _customerPhone = '';
  Timer? _debounce;

  List<Map<String, String>> _phoneAccountsList = [];
  String _phoneForAccounts = '';

  String _lookupType = 'account';

  String _statementType = 'ordinary';
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedBranch;

  static const _mockBranches = [
    'Main Branch - Accra',
    'Kumasi Branch',
    'Tamale Branch',
    'Takoradi Branch',
    'Cape Coast Branch',
    'Ho Branch',
    'Sunyani Branch',
    'Koforidua Branch',
    'Osu Branch - Accra',
    'Airport City Branch',
  ];

  static const _mockAccounts = {
    '0012345678': {
      'name': 'Kwame Asante',
      'status': 'Active',
      'balance': 'GH₵ 12,450.00',
      'phone': '232501234567',
    },
    '0023456789': {
      'name': 'Ama Mensah',
      'status': 'Active',
      'balance': 'GH₵ 8,320.50',
      'phone': '232502345678',
    },
    '0034567890': {
      'name': 'Kofi Adjei',
      'status': 'Dormant',
      'balance': 'GH₵ 150.00',
      'phone': '232503456789',
    },
    '0045678901': {
      'name': 'Abena Osei',
      'status': 'Active',
      'balance': 'GH₵ 45,800.75',
      'phone': '232504567890',
    },
  };

  static const _mockPhoneAccounts = {
    '232501234567': [
      {
        'accountNo': '0012345678',
        'name': 'Kwame Asante',
        'type': 'Savings',
        'status': 'Active',
        'balance': 'GH₵ 12,450.00',
      },
    ],
    '232502345678': [
      {
        'accountNo': '0023456789',
        'name': 'Ama Mensah',
        'type': 'Savings',
        'status': 'Active',
        'balance': 'GH₵ 8,320.50',
      },
      {
        'accountNo': '0098765432',
        'name': 'Ama Mensah',
        'type': 'Current',
        'status': 'Active',
        'balance': 'GH₵ 25,100.00',
      },
    ],
    '232503456789': [
      {
        'accountNo': '0034567890',
        'name': 'Kofi Adjei',
        'type': 'Savings',
        'status': 'Dormant',
        'balance': 'GH₵ 150.00',
      },
    ],
    '232504567890': [
      {
        'accountNo': '0045678901',
        'name': 'Abena Osei',
        'type': 'Savings',
        'status': 'Active',
        'balance': 'GH₵ 45,800.75',
      },
      {
        'accountNo': '0054321098',
        'name': 'Abena Osei',
        'type': 'Current',
        'status': 'Active',
        'balance': 'GH₵ 3,200.00',
      },
      {
        'accountNo': '0067890123',
        'name': 'Abena Osei',
        'type': 'Fixed Deposit',
        'status': 'Active',
        'balance': 'GH₵ 100,000.00',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _accountController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onAccountChanged(String value) {
    _debounce?.cancel();
    final minLength = _lookupType == 'account' ? 10 : 12;
    if (value.length < minLength) {
      setState(() {
        _accountVerified = false;
        _accountNotFound = false;
        _phoneAccountsList = [];
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _lookupAccount(value);
    });
  }

  Future<void> _lookupAccount(String input) async {
    setState(() {
      _isLookingUp = true;
      _accountVerified = false;
      _accountNotFound = false;
      _phoneAccountsList = [];
    });

    await Future.delayed(const Duration(milliseconds: 900));

    Map<String, String>? account;
    String accountNo = input;
    String customerPhone = '';

    if (_lookupType == 'phone') {
      final phoneAccounts = _mockPhoneAccounts[input];
      if (phoneAccounts != null && phoneAccounts.isNotEmpty) {
        if (phoneAccounts.length == 1) {
          final pa = phoneAccounts.first;
          account = {
            'name': pa['name']!,
            'status': pa['status']!,
            'balance': pa['balance']!,
          };
          accountNo = pa['accountNo']!;
          customerPhone = input;
        } else {
          setState(() {
            _isLookingUp = false;
            _phoneAccountsList = phoneAccounts
                .map((e) => Map<String, String>.from(e))
                .toList();
            _phoneForAccounts = input;
          });
          return;
        }
      }
    } else {
      final mockAccount = _mockAccounts[input];
      if (mockAccount != null) {
        account = {
          'name': mockAccount['name']!,
          'status': mockAccount['status']!,
          'balance': mockAccount['balance']!,
        };
        customerPhone = mockAccount['phone']!;
      }
    }

    setState(() {
      _isLookingUp = false;
      if (account != null) {
        _accountVerified = true;
        _accountName = account['name']!;
        _accountStatus = account['status']!;
        _accountBalance = account['balance']!;
        _resolvedAccountNo = accountNo;
        _customerPhone = customerPhone;
      } else {
        _accountNotFound = true;
      }
    });
  }

  void _selectPhoneAccount(Map<String, String> acct, String phoneNumber) {
    setState(() {
      _accountVerified = true;
      _accountName = acct['name']!;
      _accountStatus = acct['status']!;
      _accountBalance = acct['balance']!;
      _resolvedAccountNo = acct['accountNo']!;
      _customerPhone = phoneNumber;
    });
  }

  void _onLookupTypeChanged(String type) {
    setState(() {
      _lookupType = type;
      _accountController.clear();
      _accountVerified = false;
      _accountNotFound = false;
      _resolvedAccountNo = '';
      _customerPhone = '';
      _phoneAccountsList = [];
    });
  }


  bool get _canSubmit =>
      _accountVerified &&
      _startDate != null &&
      _endDate != null &&
      (!_requiresPickupBranch || _selectedBranch != null);

  bool get _requiresPickupBranch => _statementType == 'ordinary';

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_canSubmit) {
      String msg = 'Please complete all fields';
      if (!_accountVerified) {
        msg = _lookupType == 'phone'
            ? 'Please enter a valid phone number'
            : 'Please enter a valid account number';
      } else if (_startDate == null) {
        msg = 'Please select a start date';
      } else if (_endDate == null) {
        msg = 'Please select an end date';
      } else if (_requiresPickupBranch && _selectedBranch == null) {
        msg = 'Please select a pickup branch';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFDC2626),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _StatementOtpScreen(
          customerPhone: _customerPhone,
          accountNo: _lookupType == 'phone'
              ? _resolvedAccountNo
              : _accountController.text.trim(),
          accountName: _accountName,
          accountBalance: _accountBalance,
          statementType: _statementType,
          startDate: _startDate!,
          endDate: _endDate!,
          pickupBranch: _requiresPickupBranch ? _selectedBranch : null,
          accentColor: _accent,
          gradientColors: _gradient,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildFlowStepIndicator(1, isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntroTip(isDark),
                      SizedBox(height: 1.5.h),
                      _buildSectionCard(
                        isDark: isDark,
                        title: 'Find Account',
                        subtitle: 'Look up by account or phone number',
                        icon: Icons.search_rounded,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLookupTypeToggle(isDark),
                            SizedBox(height: 1.3.h),
                            _buildFieldLabel(
                              _lookupType == 'account'
                                  ? 'Account Number'
                                  : 'Phone Number',
                              isDark,
                            ),
                            SizedBox(height: 0.4.h),
                            _buildAccountField(isDark),
                            if (_isLookingUp) _buildLookupLoader(isDark),
                            if (_phoneAccountsList.length > 1)
                              _buildAccountSelectionDropdown(isDark),
                            if (_accountVerified) _buildAccountInfoCard(isDark),
                            if (_accountNotFound) _buildNotFoundCard(isDark),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      _buildSectionCard(
                        isDark: isDark,
                        title: 'Statement Type',
                        subtitle: 'Ordinary pickup or electronic delivery',
                        icon: Icons.description_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatementTypeToggle(isDark),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      _buildSectionCard(
                        isDark: isDark,
                        title: 'Date Range',
                        subtitle: 'Period covered by the statement',
                        icon: Icons.date_range_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDateRangeSelector(isDark),
                            if (_requiresPickupBranch) ...[
                              SizedBox(height: 1.3.h),
                              _buildFieldLabel('Pickup Branch', isDark),
                              SizedBox(height: 0.4.h),
                              _buildBranchDropdown(isDark),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                    ],
                  ),
                ),
              ),
            ),
            _buildStickyActionBar(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : _gradient,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 19,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.5.w),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Statement',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Agency Banking · Step 1 of 4',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      'Online',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlowStepIndicator(int currentStep, bool isDark) =>
      buildFlowStepIndicator(currentStep, isDark);

  static Widget buildFlowStepIndicator(int currentStep, bool isDark) {
    const labels = ['Lookup', 'OTP', 'Confirm', 'Done'];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: List.generate(4, (i) {
          final step = i + 1;
          final isLast = step == 4;
          return Expanded(
            flex: isLast ? 0 : 1,
            child: Row(
              children: [
                _flowStepDotStatic(step, currentStep, labels[i], isDark),
                if (!isLast)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: step < currentStep
                            ? _success
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : const Color(0xFFE5E7EB)),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  static Widget _flowStepDotStatic(
    int step,
    int current,
    String label,
    bool isDark,
  ) {
    final isActive = step <= current;
    final isCurrent = step == current;
    return Column(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? (isCurrent ? _accent : _success)
                : (isDark ? const Color(0xFF1E2328) : const Color(0xFFF3F4F6)),
            border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : const Color(0xFFD1D5DB)),
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: _accent.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isActive && step < current
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
                : Text(
                    '$step',
                    style: GoogleFonts.inter(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? Colors.white
                          : (isDark
                                ? Colors.white38
                                : const Color(0xFF9CA3AF)),
                    ),
                  ),
          ),
        ),
        SizedBox(height: 0.4.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 6.sp,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
            color: isCurrent
                ? _accent
                : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
          ),
        ),
      ],
    );
  }

  Widget _buildIntroTip(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _accent.withValues(alpha: isDark ? 0.12 : 0.06),
            _accent.withValues(alpha: isDark ? 0.04 : 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _accent.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: _accent, size: 15),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Text(
              'Look up the customer account, verify via OTP, then request the full statement.',
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                height: 1.35,
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required bool isDark,
    required String title,
    String? subtitle,
    IconData? icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: _accent, size: 15),
                ),
                SizedBox(width: 2.5.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 0.1.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.3.h),
          child,
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _maskAccountNo(String no) {
    if (no.length >= 7) {
      return '${no.substring(0, 3)} •••• ${no.substring(no.length - 3)}';
    }
    return no;
  }

  Widget _buildStickyActionBar(bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 1.4.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFE5E7EB),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: _buildSubmitButton(isDark),
      ),
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 7.5.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: isDark ? Colors.white54 : const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildLookupTypeToggle(bool isDark) {
    return Container(
      padding: EdgeInsets.all(0.4.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _lookupTab('account', Icons.account_balance_rounded, 'Account No.', isDark),
          _lookupTab('phone', Icons.phone_rounded, 'Phone No.', isDark),
        ],
      ),
    );
  }

  Widget _lookupTab(String type, IconData icon, String label, bool isDark) {
    final selected = _lookupType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onLookupTypeChanged(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(vertical: 0.85.h),
          decoration: BoxDecoration(
            color: selected ? _accent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _accent.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 13,
                color: selected
                    ? Colors.white
                    : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
              ),
              SizedBox(width: 1.2.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 7.5.sp,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? Colors.white
                      : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountField(bool isDark) {
    final isPhone = _lookupType == 'phone';
    final maxLength = isPhone ? 12 : 10;
    final hintText = isPhone ? '232XXXXXXXXX' : '00 XXXX XXXX';
    final validationMsg = isPhone
        ? 'Enter valid phone number (232XXXXXXXXX)'
        : 'Enter 10-digit account number';

    return TextFormField(
      controller: _accountController,
      onChanged: _onAccountChanged,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
      style: GoogleFonts.inter(
        fontSize: 9.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : const Color(0xFF1A1D23),
        letterSpacing: 0.8,
      ),
      validator: (v) {
        if (v == null || v.length < maxLength) return validationMsg;
        return null;
      },
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 9.sp,
          color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
          letterSpacing: 0.8,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
        contentPadding: _fieldPadding,
        prefixIcon: Icon(
          isPhone ? Icons.phone_outlined : Icons.account_balance_outlined,
          color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
          size: 17,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_fieldRadius),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE5E7EB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_fieldRadius),
          borderSide: BorderSide(
            color: _accountVerified
                ? _success.withValues(alpha: 0.45)
                : _accountNotFound
                    ? const Color(0xFFDC2626).withValues(alpha: 0.45)
                    : isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_fieldRadius),
          borderSide: BorderSide(color: _accent, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_fieldRadius),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_fieldRadius),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1),
        ),
        suffixIcon: _isLookingUp
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: isDark ? Colors.white38 : _accent,
                  ),
                ),
              )
            : _accountVerified
                ? const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF059669),
                      size: 18,
                    ),
                  )
                : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 36),
      ),
    );
  }

  Widget _buildLookupLoader(bool isDark) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isDark ? Colors.white38 : _accent,
            ),
          ),
          SizedBox(width: 2.5.w),
          Text(
            'Verifying account...',
            style: GoogleFonts.inter(
              fontSize: 7.5.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSelectionDropdown(bool isDark) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Account',
            style: GoogleFonts.inter(
              fontSize: 7.5.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: isDark ? Colors.white54 : const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 0.4.h),
          Container(
            height: 42,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(_fieldRadius),
              border: Border.all(
                color: _accountVerified
                    ? _accent.withValues(alpha: 0.4)
                    : isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : const Color(0xFFE5E7EB),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _accountVerified ? _resolvedAccountNo : null,
                isExpanded: true,
                isDense: true,
                hint: Text(
                  'Select account',
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: _accountVerified
                      ? _accent
                      : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
                ),
                dropdownColor: isDark ? const Color(0xFF161B22) : Colors.white,
                borderRadius: BorderRadius.circular(_fieldRadius),
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : const Color(0xFF1A1D23),
                ),
                items: _phoneAccountsList.map((acct) {
                  final accNo = acct['accountNo']!;
                  final maskedNo = accNo.length >= 7
                      ? '${accNo.substring(0, 3)}****${accNo.substring(7)}'
                      : accNo;
                  return DropdownMenuItem<String>(
                    value: accNo,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_rounded,
                              size: 16,
                              color: _accent.withValues(alpha: 0.6),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                '${acct['name']} \u2022 ${acct['type'] ?? 'Savings'}',
                                style: GoogleFonts.inter(
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.2.h),
                        Text(
                          maskedNo,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 7.5.sp,
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  final acct = _phoneAccountsList.firstWhere(
                    (a) => a['accountNo'] == value,
                  );
                  _selectPhoneAccount(acct, _phoneForAccounts);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoCard(bool isDark) {
    final isActive = _accountStatus == 'Active';
    final statusColor = isActive ? _success : const Color(0xFFF59E0B);

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: isDark ? 0.08 : 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: statusColor.withValues(alpha: 0.18)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_accent.withValues(alpha: 0.85), _accent],
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      _initials(_accountName),
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.5.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _accountName,
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 0.15.h),
                      Text(
                        _maskAccountNo(_resolvedAccountNo),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 7.sp,
                          color: isDark ? Colors.white54 : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _accountStatus,
                        style: GoogleFonts.inter(
                          fontSize: 6.5.sp,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundCard(bool isDark) {
    final isPhone = _lookupType == 'phone';
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D0F0F) : const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFDC2626).withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.person_off_rounded,
                  color: Color(0xFFDC2626),
                  size: 16,
                ),
              ),
            ),
            SizedBox(width: 2.5.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Not Found',
                    style: GoogleFonts.inter(
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                  SizedBox(height: 0.15.h),
                  Text(
                    isPhone
                        ? 'No account linked to this phone number. Please verify and try again.'
                        : 'No account matches this number. Please verify and try again.',
                    style: GoogleFonts.inter(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatementTypeToggle(bool isDark) {
    return Container(
      padding: EdgeInsets.all(0.4.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _statementTypeTab(
            'ordinary',
            Icons.description_outlined,
            'Ordinary',
            isDark,
          ),
          _statementTypeTab(
            'electronic',
            Icons.email_outlined,
            'Electronic',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _statementTypeTab(
    String value,
    IconData icon,
    String label,
    bool isDark,
  ) {
    final selected = _statementType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _statementType = value;
          if (_statementType == 'electronic') {
            _selectedBranch = null;
          }
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(vertical: 0.85.h),
          decoration: BoxDecoration(
            color: selected ? _accent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _accent.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 13,
                color: selected
                    ? Colors.white
                    : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
              ),
              SizedBox(width: 1.2.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 7.5.sp,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected
                      ? Colors.white
                      : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector(bool isDark) {
    final now = DateTime.now();
    return Row(
      children: [
        Expanded(
          child: AgencyDateField(
            label: 'Start Date',
            value: _startDate,
            isDark: isDark,
            compact: true,
            accentColor: _accent,
            fieldRadius: _fieldRadius,
            firstDate: DateTime(2020),
            lastDate: now,
            initialDate: now.subtract(const Duration(days: 30)),
            pickerTitle: 'Start Date',
            pickerSubtitle: 'Beginning of statement period',
            displayFormat: AgencyDateFormat.withWeekday,
            onChanged: (picked) {
              if (picked == null) return;
              setState(() {
                _startDate = picked;
                if (_endDate != null && _endDate!.isBefore(picked)) {
                  _endDate = null;
                }
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.5.w),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: isDark ? 0.12 : 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: _accent,
              size: 14,
            ),
          ),
        ),
        Expanded(
          child: AgencyDateField(
            label: 'End Date',
            value: _endDate,
            isDark: isDark,
            compact: true,
            accentColor: _accent,
            fieldRadius: _fieldRadius,
            firstDate: _startDate ?? DateTime(2020),
            lastDate: now,
            initialDate: now,
            pickerTitle: 'End Date',
            pickerSubtitle: 'End of statement period',
            displayFormat: AgencyDateFormat.withWeekday,
            onChanged: (picked) {
              if (picked == null) return;
              setState(() => _endDate = picked);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBranchDropdown(bool isDark) {
    return Container(
      height: 42,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(_fieldRadius),
        border: Border.all(
          color: _selectedBranch != null
              ? _accent.withValues(alpha: 0.45)
              : isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFE5E7EB),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBranch,
          isExpanded: true,
          isDense: true,
          hint: Text(
            'Select pickup branch',
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: _selectedBranch != null
                ? _accent
                : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
          ),
          dropdownColor: isDark ? const Color(0xFF161B22) : Colors.white,
          borderRadius: BorderRadius.circular(_fieldRadius),
          style: GoogleFonts.inter(
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : const Color(0xFF1A1D23),
          ),
          items: _mockBranches.map((branch) {
            return DropdownMenuItem<String>(
              value: branch,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      branch,
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedBranch = value);
          },
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isDark) {
    final enabled = _canSubmit;

    return GestureDetector(
      onTap: enabled ? _onSubmit : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.25.h),
        decoration: BoxDecoration(
          gradient: enabled
              ? LinearGradient(
                  colors: [_accent, _accent.withValues(alpha: 0.85)],
                )
              : null,
          color: enabled
              ? null
              : (isDark ? const Color(0xFF1E2328) : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            'Continue',
            style: GoogleFonts.inter(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
              color: enabled
                  ? Colors.white
                  : (isDark ? Colors.white24 : const Color(0xFF9CA3AF)),
            ),
          ),
        ),
      ),
    );
  }
}
