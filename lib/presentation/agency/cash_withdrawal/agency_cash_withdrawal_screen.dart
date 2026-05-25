import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
part 'withdrawal_otp_screen.dart';
part 'withdrawal_receipt_screen.dart';
part 'success_dialog.dart';
part 'insufficient_funds_dialog.dart';

class AgencyCashWithdrawalScreen extends StatefulWidget {
  const AgencyCashWithdrawalScreen({super.key});

  @override
  State<AgencyCashWithdrawalScreen> createState() =>
      _AgencyCashWithdrawalScreenState();
}

class _AgencyCashWithdrawalScreenState extends State<AgencyCashWithdrawalScreen>
    with SingleTickerProviderStateMixin {
  static const Color _accent = Color(0xFF2E8B8B);
  static const List<Color> _gradient = [Color(0xFF1B365D), Color(0xFF2E8B8B)];
  static const Color _success = Color(0xFF059669);
  static const double _fieldRadius = 10;

  EdgeInsets get _fieldPadding =>
      EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.95.h);

  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _withdrawnByController = TextEditingController();
  final _withdrawerTelController = TextEditingController();
  final _narrationController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  bool _isLookingUp = false;
  bool _accountVerified = false;
  bool _accountNotFound = false;
  bool _balanceVisible = false;
  String _accountName = '';
  String _accountStatus = '';
  String _accountBalance = '';
  String _resolvedAccountNo = '';
  String _customerPhone = '';
  Timer? _debounce;

  // Multiple phone accounts – populated when phone has >1 account
  List<Map<String, String>> _phoneAccountsList = [];
  String _phoneForAccounts = '';

  // Lookup type: 'account' or 'phone'
  String _lookupType = 'account';

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
  // Mock accounts by phone number (one phone can link to multiple accounts)
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
    _amountController.dispose();
    _withdrawnByController.dispose();
    _withdrawerTelController.dispose();
    _narrationController.dispose();
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
          // Single account - auto-select
          final pa = phoneAccounts.first;
          account = {
            'name': pa['name']!,
            'status': pa['status']!,
            'balance': pa['balance']!,
          };
          accountNo = pa['accountNo']!;
          customerPhone = input;
        } else {
          // Multiple accounts - show dropdown

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
        if (_withdrawnByController.text.trim().isEmpty) {
          _withdrawnByController.text = _accountName;
        }
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
      if (_withdrawnByController.text.trim().isEmpty) {
        _withdrawnByController.text = _accountName;
      }
    });
  }

  // ── Account Selection Dropdown (multiple phone accounts) ──
  Widget _buildAccountSelectionDropdown(bool isDark) {
    return Padding(
      padding: EdgeInsets.only(top: 1.2.h),
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
                  fontSize: 9.sp,
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
                              color: const Color(
                                0xFF2E8B8B,
                              ).withValues(alpha: 0.6),
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

  String get _fixedNarration {
    final name = _withdrawnByController.text.trim();
    if (name.isEmpty) return '';
    return 'UTB XPRESS E-CASH WITHDRAWAL BY ${name.toUpperCase()}';
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_accountVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lookupType == 'phone'
                ? 'Please enter a valid phone number'
                : 'Please enter a valid account number',
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

    // Navigate to OTP verification screen first
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _WithdrawalOtpScreen(
          customerPhone: _customerPhone,
          accountNo: _lookupType == 'phone'
              ? _resolvedAccountNo
              : _accountController.text.trim(),
          accountName: _accountName,
          accountBalance: _accountBalance,
          amount: _amountController.text.trim(),
          withdrawnBy: _withdrawnByController.text.trim(),
          withdrawerTel: _withdrawerTelController.text.trim(),
          narration: _narrationController.text.trim(),
          fixedNarration: _fixedNarration,
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
      backgroundColor: isDark
          ? const Color(0xFF0D1117)
          : const Color(0xFFF8FAFC),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildStepIndicator(1, isDark),
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
                        title: 'Withdrawal Details',
                        subtitle: 'Amount and withdrawer information',
                        icon: Icons.payments_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Amount', isDark),
                            SizedBox(height: 0.4.h),
                            _buildAmountField(isDark),
                            SizedBox(height: 1.3.h),
                            _buildFieldLabel('Withdrawn By', isDark),
                            SizedBox(height: 0.4.h),
                            _buildTextField(
                              controller: _withdrawnByController,
                              hint: 'Full name of person withdrawing',
                              isDark: isDark,
                              textCapitalization: TextCapitalization.words,
                              onChanged: (_) => setState(() {}),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                            SizedBox(height: 1.3.h),
                            _buildFieldLabel("Withdrawer's Telephone", isDark),
                            SizedBox(height: 0.4.h),
                            _buildTextField(
                              controller: _withdrawerTelController,
                              hint: '232XXXXXXXX',
                              isDark: isDark,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(12),
                              ],
                              validator: (v) => v == null || v.trim().length < 12
                                  ? 'Invalid phone'
                                  : null,
                            ),
                            SizedBox(height: 1.3.h),
                            _buildFieldLabel('Narration (optional)', isDark),
                            SizedBox(height: 0.4.h),
                            _buildTextField(
                              controller: _narrationController,
                              hint: 'Add a note for this withdrawal',
                              isDark: isDark,
                              maxLines: 2,
                            ),
                            if (_fixedNarration.isNotEmpty) ...[
                              SizedBox(height: 1.2.h),
                              _buildSystemNarrationBanner(isDark),
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

  // ── Header ──
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
                    Icons.account_balance_wallet_outlined,
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
                      'Cash Withdrawal',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Agency Banking · Step 1 of 3',
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

  Widget _buildStepIndicator(int currentStep, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
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
        children: [
          _stepDot(1, currentStep, 'Account', isDark),
          Expanded(
            child: Container(
              height: 2,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: currentStep >= 2
                    ? LinearGradient(colors: [_accent, _accent.withValues(alpha: 0.5)])
                    : null,
                color: currentStep >= 2
                    ? null
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : const Color(0xFFE5E7EB)),
              ),
            ),
          ),
          _stepDot(2, currentStep, 'Verify', isDark),
        ],
      ),
    );
  }

  Widget _stepDot(int step, int current, String label, bool isDark) {
    final isActive = step <= current;
    final isCurrent = step == current;
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
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
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isActive && step < current
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                : Text(
                    '$step',
                    style: GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? Colors.white
                          : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
                    ),
                  ),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 7.sp,
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
              'Verify the customer account, enter the withdrawal amount, then verify with OTP.',
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

  Widget _buildSystemNarrationBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.9.h),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: isDark ? 0.1 : 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _accent.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_rounded, color: _accent, size: 16),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Narration',
                  style: GoogleFonts.inter(
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w600,
                    color: _accent,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  _fixedNarration,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 7.5.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : const Color(0xFF374151),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField(bool isDark) {
    return TextFormField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      style: GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : const Color(0xFF111827),
        letterSpacing: -0.2,
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Enter amount';
        final amount = double.tryParse(v);
        if (amount == null || amount <= 0) return 'Enter a valid amount';
        return null;
      },
      decoration: InputDecoration(
        isDense: true,
        hintText: '0.00',
        prefixText: 'GH₵  ',
        prefixStyle: GoogleFonts.inter(
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          color: _accent,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 9.sp,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
        contentPadding: _fieldPadding,
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
            color: isDark
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
      ),
    );
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

  // ── Account field ──
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

  // ── Lookup Type Toggle ──
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

  // ── Lookup Loader ──
  Widget _buildLookupLoader(bool isDark) {
    return Padding(
      padding: EdgeInsets.only(top: 1.2.h),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isDark ? Colors.white38 : const Color(0xFF2E8B8B),
            ),
          ),
          SizedBox(width: 2.5.w),
          Text(
            'Verifying account...',
            style: GoogleFonts.inter(
              fontSize: 8.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  // ── Account Info Card ──
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
                      colors: [
                        _accent.withValues(alpha: 0.85),
                        _accent,
                      ],
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
            SizedBox(height: 0.9.h),
            GestureDetector(
              onTap: () => setState(() => _balanceVisible = !_balanceVisible),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.7.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 14,
                      color: isDark ? Colors.white38 : const Color(0xFF64748B),
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      'Balance',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(width: 1.5.w),
                    Expanded(
                      child: Text(
                        _balanceVisible ? _accountBalance : '••••••••',
                        style: GoogleFonts.inter(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                    ),
                    Icon(
                      _balanceVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 14,
                      color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _maskAccountNo(String no) {
    if (no.length >= 7) {
      return '${no.substring(0, 3)} •••• ${no.substring(no.length - 3)}';
    }
    return no;
  }

  // ── Not Found Card ──
  Widget _buildNotFoundCard(bool isDark) {
    final isPhone = _lookupType == 'phone';
    return Padding(
      padding: EdgeInsets.only(top: 1.2.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.5.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D0F0F) : const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFDC2626).withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(
                  Icons.person_off_rounded,
                  color: Color(0xFFDC2626),
                  size: 18,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Not Found',
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
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
                      fontSize: 7.5.sp,
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

  // ── Text field ──
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText,
    int? maxLines,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      validator: validator,
      style: GoogleFonts.inter(
        fontSize: 9.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : const Color(0xFF1A1D23),
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        prefixText: prefixText,
        prefixStyle: GoogleFonts.inter(
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white54 : const Color(0xFF6B7280),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 9.sp,
          color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
        contentPadding: _fieldPadding,
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
            color: isDark
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
      ),
    );
  }

  // ── Submit Button ──
  Widget _buildSubmitButton(bool isDark) {
    final enabled = _accountVerified;

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue',
              style: GoogleFonts.inter(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
                color: enabled
                    ? Colors.white
                    : (isDark ? Colors.white24 : const Color(0xFF9CA3AF)),
              ),
            ),
            if (enabled) ...[
              SizedBox(width: 1.5.w),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── OTP Verification Screen ──
// ══════════════════════════════════════════════════════════════
