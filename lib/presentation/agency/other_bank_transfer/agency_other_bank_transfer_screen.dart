import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
part 'transfer_otp_screen.dart';
part 'transfer_receipt_screen.dart';
part 'success_dialog.dart';
part 'insufficient_funds_dialog.dart';

class AgencyOtherBankTransferScreen extends StatefulWidget {
  const AgencyOtherBankTransferScreen({super.key});

  @override
  State<AgencyOtherBankTransferScreen> createState() =>
      _AgencyOtherBankTransferScreenState();
}

class _AgencyOtherBankTransferScreenState
    extends State<AgencyOtherBankTransferScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _senderController = TextEditingController();
  final _beneficiaryController = TextEditingController();
  final _amountController = TextEditingController();
  final _transferredByController = TextEditingController();
  final _narrationController = TextEditingController();

  // Bank selection
  String? _selectedBank;
  static const List<Map<String, String>> _banks = [
    {'code': 'GCB', 'name': 'GCB Bank'},
    {'code': 'ECOBANK', 'name': 'Ecobank Ghana'},
    {'code': 'STANBIC', 'name': 'Stanbic Bank'},
    {'code': 'ABSA', 'name': 'Absa Ghana'},
    {'code': 'CAL', 'name': 'CAL Bank'},
    {'code': 'FIDELITY', 'name': 'Fidelity Bank'},
    {'code': 'ACCESS', 'name': 'Access Bank'},
    {'code': 'ZENITH', 'name': 'Zenith Bank'},
    {'code': 'UBA', 'name': 'UBA Ghana'},
    {'code': 'REPUBLIC', 'name': 'Republic Bank'},
    {'code': 'SOCIETE', 'name': 'Societe Generale'},
    {'code': 'PRUDENTIAL', 'name': 'Prudential Bank'},
  ];

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  // Sender lookup
  bool _isLookingUpSender = false;
  bool _senderVerified = false;
  bool _senderNotFound = false;
  bool _senderBalanceVisible = false;
  String _senderName = '';
  String _senderStatus = '';
  String _senderBalance = '';
  String _resolvedSenderAccountNo = '';
  String _senderPhone = '';
  Timer? _senderDebounce;
  String _senderLookupType = 'account';

  // Multiple phone accounts – populated when phone has >1 account
  List<Map<String, String>> _senderPhoneAccountsList = [];
  String _senderPhoneForAccounts = '';

  // Beneficiary lookup
  bool _isLookingUpBeneficiary = false;
  bool _beneficiaryVerified = false;
  bool _beneficiaryNotFound = false;
  String _beneficiaryName = '';
  String _beneficiaryStatus = '';
  String _resolvedBeneficiaryAccountNo = '';
  Timer? _beneficiaryDebounce;
  String _beneficiaryLookupType = 'account';

  List<Map<String, String>> _beneficiaryPhoneAccountsList = [];
  String _beneficiaryPhoneForAccounts = '';

  // Mock accounts
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
    _senderController.dispose();
    _beneficiaryController.dispose();
    _amountController.dispose();
    _transferredByController.dispose();
    _narrationController.dispose();
    _senderDebounce?.cancel();
    _beneficiaryDebounce?.cancel();
    super.dispose();
  }

  // ── Sender Lookup ──
  void _onSenderChanged(String value) {
    _senderDebounce?.cancel();
    final minLength = _senderLookupType == 'account' ? 10 : 12;
    if (value.length < minLength) {
      setState(() {
        _senderVerified = false;
        _senderNotFound = false;
        _senderPhoneAccountsList = [];
      });
      return;
    }
    _senderDebounce = Timer(const Duration(milliseconds: 600), () {
      _lookupSender(value);
    });
  }

  Future<void> _lookupSender(String input) async {
    setState(() {
      _isLookingUpSender = true;
      _senderVerified = false;
      _senderNotFound = false;
      _senderPhoneAccountsList = [];
    });

    await Future.delayed(const Duration(milliseconds: 900));

    Map<String, String>? account;
    String accountNo = input;
    String customerPhone = '';

    if (_senderLookupType == 'phone') {
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
            _isLookingUpSender = false;

            _senderPhoneAccountsList = phoneAccounts
                .map((e) => Map<String, String>.from(e))
                .toList();

            _senderPhoneForAccounts = input;
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
      _isLookingUpSender = false;
      if (account != null) {
        _senderVerified = true;
        _senderName = account['name']!;
        _senderStatus = account['status']!;
        _senderBalance = account['balance']!;
        _resolvedSenderAccountNo = accountNo;
        _senderPhone = customerPhone;
        if (_transferredByController.text.trim().isEmpty) {
          _transferredByController.text = _senderName;
        }
      } else {
        _senderNotFound = true;
      }
    });
  }

  void _selectPhoneAccount(
    Map<String, String> acct,
    String phoneNumber, {
    required bool isSender,
  }) {
    setState(() {
      if (isSender) {
        _senderVerified = true;
        _senderName = acct['name']!;
        _senderStatus = acct['status']!;
        _senderBalance = acct['balance']!;
        _resolvedSenderAccountNo = acct['accountNo']!;
        _senderPhone = phoneNumber;
        if (_transferredByController.text.trim().isEmpty) {
          _transferredByController.text = _senderName;
        }
      } else {
        _beneficiaryVerified = true;
        _beneficiaryName = acct['name']!;
        _beneficiaryStatus = acct['status']!;
        _resolvedBeneficiaryAccountNo = acct['accountNo']!;
      }
    });
  }

  // ── Account Selection Dropdown (multiple phone accounts) ──
  Widget _buildAccountSelectionDropdown(bool isDark, {required bool isSender}) {
    final accounts = isSender
        ? _senderPhoneAccountsList
        : _beneficiaryPhoneAccountsList;
    final phoneFor = isSender
        ? _senderPhoneForAccounts
        : _beneficiaryPhoneForAccounts;
    final isVerified = isSender ? _senderVerified : _beneficiaryVerified;
    final resolvedNo = isSender
        ? _resolvedSenderAccountNo
        : _resolvedBeneficiaryAccountNo;
    return Padding(
      padding: EdgeInsets.only(top: 1.2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Account',
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 0.8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161B22) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isVerified
                    ? const Color(0xFF2E8B8B).withValues(alpha: 0.5)
                    : isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: isVerified ? resolvedNo : null,
                isExpanded: true,
                hint: Text(
                  'Select account for this transaction',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isVerified
                      ? const Color(0xFF2E8B8B)
                      : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
                ),
                dropdownColor: isDark ? const Color(0xFF161B22) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : const Color(0xFF1A1D23),
                ),
                items: accounts.map((acct) {
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
                  final acct = accounts.firstWhere(
                    (a) => a['accountNo'] == value,
                  );
                  _selectPhoneAccount(acct, phoneFor, isSender: isSender);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSenderLookupTypeChanged(String type) {
    setState(() {
      _senderLookupType = type;
      _senderController.clear();
      _senderVerified = false;
      _senderNotFound = false;
      _resolvedSenderAccountNo = '';
      _senderPhone = '';
      _senderPhoneAccountsList = [];
    });
  }

  // ── Beneficiary Lookup ──
  void _onBeneficiaryChanged(String value) {
    _beneficiaryDebounce?.cancel();
    final minLength = _beneficiaryLookupType == 'account' ? 10 : 12;
    if (value.length < minLength) {
      setState(() {
        _beneficiaryVerified = false;
        _beneficiaryNotFound = false;
        _beneficiaryPhoneAccountsList = [];
      });
      return;
    }
    _beneficiaryDebounce = Timer(const Duration(milliseconds: 600), () {
      _lookupBeneficiary(value);
    });
  }

  Future<void> _lookupBeneficiary(String input) async {
    setState(() {
      _isLookingUpBeneficiary = true;
      _beneficiaryVerified = false;
      _beneficiaryNotFound = false;
      _beneficiaryPhoneAccountsList = [];
    });

    await Future.delayed(const Duration(milliseconds: 900));

    Map<String, String>? account;
    String accountNo = input;

    if (_beneficiaryLookupType == 'phone') {
      final phoneAccounts = _mockPhoneAccounts[input];
      if (phoneAccounts != null && phoneAccounts.isNotEmpty) {
        if (phoneAccounts.length == 1) {
          // Single account - auto-select
          final pa = phoneAccounts.first;
          account = {'name': pa['name']!, 'status': pa['status']!};
          accountNo = pa['accountNo']!;
        } else {
          // Multiple accounts - show dropdown

          setState(() {
            _isLookingUpBeneficiary = false;

            _beneficiaryPhoneAccountsList = phoneAccounts
                .map((e) => Map<String, String>.from(e))
                .toList();

            _beneficiaryPhoneForAccounts = input;
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
        };
      }
    }

    setState(() {
      _isLookingUpBeneficiary = false;
      if (account != null) {
        _beneficiaryVerified = true;
        _beneficiaryName = account['name']!;
        _beneficiaryStatus = account['status']!;
        _resolvedBeneficiaryAccountNo = accountNo;
      } else {
        _beneficiaryNotFound = true;
      }
    });
  }

  void _onBeneficiaryLookupTypeChanged(String type) {
    setState(() {
      _beneficiaryLookupType = type;
      _beneficiaryController.clear();
      _beneficiaryVerified = false;
      _beneficiaryNotFound = false;
      _resolvedBeneficiaryAccountNo = '';
      _beneficiaryPhoneAccountsList = [];
    });
  }

  String get _fixedNarration {
    final name = _transferredByController.text.trim();
    if (name.isEmpty) return '';
    return 'XPRESS FUNDS TRANSFER BY ${name.toUpperCase()}';
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_senderVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid sender account/phone',
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
    if (!_beneficiaryVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid beneficiary account/phone',
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
    if (_selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a destination bank',
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

    // Get bank name from code
    final bankName = _banks.firstWhere(
      (b) => b['code'] == _selectedBank,
    )['name']!;

    // Navigate to OTP verification
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _TransferOtpScreen(
          customerPhone: _senderPhone,
          senderAccountNo: _senderLookupType == 'phone'
              ? _resolvedSenderAccountNo
              : _senderController.text.trim(),
          senderName: _senderName,
          senderBalance: _senderBalance,
          beneficiaryAccountNo: _beneficiaryLookupType == 'phone'
              ? _resolvedBeneficiaryAccountNo
              : _beneficiaryController.text.trim(),
          beneficiaryName: _beneficiaryName,
          beneficiaryBank: bankName,
          amount: _amountController.text.trim(),
          transferredBy: _transferredByController.text.trim(),
          narration: _narrationController.text.trim(),
          fixedNarration: _fixedNarration,
          accentColor: const Color(0xFF2E8B8B),
          gradientColors: const [Color(0xFF1B365D), Color(0xFF2E8B8B)],
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
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 4.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sender Section
                      _buildSectionHeader('Sender Details', isDark),
                      SizedBox(height: 1.5.h),
                      _buildLookupTypeToggle(
                        isDark,
                        _senderLookupType,
                        _onSenderLookupTypeChanged,
                      ),
                      SizedBox(height: 1.5.h),
                      _buildFieldLabel(
                        _senderLookupType == 'account'
                            ? "Sender's Account Number"
                            : "Sender's Phone Number",
                        isDark,
                      ),
                      SizedBox(height: 0.8.h),
                      _buildAccountField(
                        controller: _senderController,
                        onChanged: _onSenderChanged,
                        isPhone: _senderLookupType == 'phone',
                        isVerified: _senderVerified,
                        isNotFound: _senderNotFound,
                        isLoading: _isLookingUpSender,
                        isDark: isDark,
                      ),
                      if (_isLookingUpSender) _buildLookupLoader(isDark),
                      if (_senderPhoneAccountsList.length > 1)
                        _buildAccountSelectionDropdown(isDark, isSender: true),
                      if (_senderVerified)
                        _buildAccountInfoCard(
                          isDark,
                          _senderName,
                          _senderStatus,
                          _resolvedSenderAccountNo,
                          showBalance: true,
                          balance: _senderBalance,
                          balanceVisible: _senderBalanceVisible,
                          onToggleBalance: () => setState(
                            () =>
                                _senderBalanceVisible = !_senderBalanceVisible,
                          ),
                        ),
                      if (_senderNotFound)
                        _buildNotFoundCard(
                          isDark,
                          _senderLookupType == 'phone',
                        ),

                      SizedBox(height: 2.5.h),

                      // Bank Selection (before beneficiary)
                      _buildSectionHeader('Destination Bank', isDark),
                      SizedBox(height: 1.5.h),
                      _buildBankSelector(isDark),

                      SizedBox(height: 2.5.h),

                      // Beneficiary Section
                      _buildSectionHeader('Beneficiary Details', isDark),
                      SizedBox(height: 1.5.h),
                      _buildLookupTypeToggle(
                        isDark,
                        _beneficiaryLookupType,
                        _onBeneficiaryLookupTypeChanged,
                      ),
                      SizedBox(height: 1.5.h),
                      _buildFieldLabel(
                        _beneficiaryLookupType == 'account'
                            ? "Beneficiary's Account Number"
                            : "Beneficiary's Phone Number",
                        isDark,
                      ),
                      SizedBox(height: 0.8.h),
                      _buildAccountField(
                        controller: _beneficiaryController,
                        onChanged: _onBeneficiaryChanged,
                        isPhone: _beneficiaryLookupType == 'phone',
                        isVerified: _beneficiaryVerified,
                        isNotFound: _beneficiaryNotFound,
                        isLoading: _isLookingUpBeneficiary,
                        isDark: isDark,
                      ),
                      if (_isLookingUpBeneficiary) _buildLookupLoader(isDark),
                      if (_beneficiaryPhoneAccountsList.length > 1)
                        _buildAccountSelectionDropdown(isDark, isSender: false),
                      if (_beneficiaryVerified)
                        _buildAccountInfoCard(
                          isDark,
                          _beneficiaryName,
                          _beneficiaryStatus,
                          _beneficiaryController.text,
                          showBalance: false,
                        ),
                      if (_beneficiaryNotFound)
                        _buildNotFoundCard(
                          isDark,
                          _beneficiaryLookupType == 'phone',
                        ),

                      SizedBox(height: 2.5.h),

                      SizedBox(height: 2.5.h),

                      // Transfer Details
                      _buildSectionHeader('Transfer Details', isDark),
                      SizedBox(height: 1.5.h),

                      _buildFieldLabel('Amount (GH₵)', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _amountController,
                        hint: '0.00',
                        isDark: isDark,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        prefixText: 'GH₵  ',
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter amount';
                          final amount = double.tryParse(v);
                          if (amount == null || amount <= 0) {
                            return 'Enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),

                      _buildFieldLabel('Funds Transferred By', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _transferredByController,
                        hint: 'Name of sender',
                        isDark: isDark,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => setState(() {}),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Enter sender name'
                            : null,
                      ),
                      SizedBox(height: 2.h),

                      _buildFieldLabel('Narration', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _narrationController,
                        hint: 'Optional narration',
                        isDark: isDark,
                        maxLines: 2,
                      ),
                      SizedBox(height: 1.2.h),

                      // System narration
                      if (_fixedNarration.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.2.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2E8B8B,
                            ).withValues(alpha: isDark ? 0.08 : 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(
                                0xFF2E8B8B,
                              ).withValues(alpha: 0.15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transaction Description',
                                style: GoogleFonts.inter(
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2E8B8B),
                                ),
                              ),
                              SizedBox(height: 0.3.h),
                              Text(
                                _fixedNarration,
                                style: GoogleFonts.inter(
                                  fontSize: 8.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white70
                                      : const Color(0xFF1A1D23),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),
                      ],

                      if (_fixedNarration.isEmpty) SizedBox(height: 2.h),

                      _buildSubmitButton(isDark),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
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
              : [const Color(0xFF1B365D), const Color(0xFF2E8B8B)],
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Other Bank Transfer',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Agency Banking',
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

  Widget _buildSectionHeader(String title, bool isDark) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF2E8B8B),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 9.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white70 : const Color(0xFF374151),
      ),
    );
  }

  Widget _buildBankSelector(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _selectedBank != null
              ? const Color(0xFF059669).withValues(alpha: 0.5)
              : isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedBank,
        hint: Row(
          children: [
            Icon(
              Icons.account_balance_rounded,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              'Select destination bank',
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
              ),
            ),
          ],
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: isDark ? const Color(0xFF161B22) : Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.6.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2E8B8B), width: 1.5),
          ),
        ),
        dropdownColor: isDark ? const Color(0xFF161B22) : Colors.white,
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: isDark ? Colors.white54 : const Color(0xFF6B7280),
        ),
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF1A1D23),
        ),
        validator: (v) => v == null ? 'Select a bank' : null,
        onChanged: (value) {
          setState(() {
            _selectedBank = value;
          });
        },
        items: _banks.map((bank) {
          return DropdownMenuItem<String>(
            value: bank['code'],
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E8B8B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      bank['code']!.substring(0, 2),
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E8B8B),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    bank['name']!,
                    style: GoogleFonts.inter(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF1A1D23),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLookupTypeToggle(
    bool isDark,
    String currentType,
    ValueChanged<String> onChanged,
  ) {
    return Container(
      padding: EdgeInsets.all(0.5.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged('account'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 1.2.h),
                decoration: BoxDecoration(
                  color: currentType == 'account'
                      ? const Color(0xFF2E8B8B)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: currentType == 'account'
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF2E8B8B,
                            ).withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_rounded,
                      size: 16,
                      color: currentType == 'account'
                          ? Colors.white
                          : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      'Account No.',
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w600,
                        color: currentType == 'account'
                            ? Colors.white
                            : (isDark
                                  ? Colors.white38
                                  : const Color(0xFF9CA3AF)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged('phone'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 1.2.h),
                decoration: BoxDecoration(
                  color: currentType == 'phone'
                      ? const Color(0xFF2E8B8B)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: currentType == 'phone'
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF2E8B8B,
                            ).withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      size: 16,
                      color: currentType == 'phone'
                          ? Colors.white
                          : (isDark ? Colors.white38 : const Color(0xFF9CA3AF)),
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      'Phone No.',
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w600,
                        color: currentType == 'phone'
                            ? Colors.white
                            : (isDark
                                  ? Colors.white38
                                  : const Color(0xFF9CA3AF)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountField({
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    required bool isPhone,
    required bool isVerified,
    required bool isNotFound,
    required bool isLoading,
    required bool isDark,
  }) {
    final maxLength = isPhone ? 12 : 10;
    final hintText = isPhone ? '232XXXXXXXXX' : '00 XXXX XXXX';
    final validationMsg = isPhone
        ? 'Enter valid phone number (232XXXXXXXXX)'
        : 'Enter 10-digit account number';

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
      style: GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : const Color(0xFF1A1D23),
        letterSpacing: 1.2,
      ),
      validator: (v) {
        if (v == null || v.length < maxLength) return validationMsg;
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 10.sp,
          color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
          letterSpacing: 1.2,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF161B22) : Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
        prefixIcon: Icon(
          isPhone ? Icons.phone_rounded : Icons.account_balance_rounded,
          color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE5E7EB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isVerified
                ? const Color(0xFF059669).withValues(alpha: 0.5)
                : isNotFound
                ? const Color(0xFFDC2626).withValues(alpha: 0.5)
                : isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2E8B8B), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
        ),
        suffixIcon: isLoading
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isDark ? Colors.white38 : const Color(0xFF2E8B8B),
                  ),
                ),
              )
            : isVerified
            ? const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF059669),
                size: 22,
              )
            : null,
      ),
    );
  }

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

  Widget _buildAccountInfoCard(
    bool isDark,
    String name,
    String status,
    String accountNo, {
    bool showBalance = false,
    String balance = '',
    bool balanceVisible = false,
    VoidCallback? onToggleBalance,
  }) {
    final isActive = status == 'Active';
    const accentColor = Color(0xFF2E8B8B);

    return Padding(
      padding: EdgeInsets.only(top: 1.2.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive
                ? [
                    accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
                    const Color(
                      0xFF10B981,
                    ).withValues(alpha: isDark ? 0.08 : 0.04),
                  ]
                : [
                    const Color(
                      0xFFF59E0B,
                    ).withValues(alpha: isDark ? 0.15 : 0.08),
                    const Color(
                      0xFFFBBF24,
                    ).withValues(alpha: isDark ? 0.08 : 0.04),
                  ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? accentColor.withValues(alpha: 0.3)
                : const Color(0xFFF59E0B).withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: (isActive ? accentColor : const Color(0xFFF59E0B))
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: isActive ? accentColor : const Color(0xFFF59E0B),
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1A1D23),
                        ),
                      ),
                      SizedBox(height: 0.3.h),
                      Text(
                        'A/C: $accountNo',
                        style: GoogleFonts.inter(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.5.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? accentColor : const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.inter(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            if (showBalance) ...[
              SizedBox(height: 1.5.h),
              GestureDetector(
                onTap: onToggleBalance,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: (isActive ? accentColor : const Color(0xFFF59E0B))
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Balance: ',
                        style: GoogleFonts.inter(
                          fontSize: 8.5.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        balanceVisible ? balance : '••••••••',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: isActive
                              ? accentColor
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                      const Spacer(),
                      CustomIconWidget(
                        iconName: balanceVisible
                            ? 'visibility'
                            : 'visibility_off',
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF64748B),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundCard(bool isDark, bool isPhone) {
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
                        ? 'No account linked to this phone number.'
                        : 'No account matches this number.',
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
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : const Color(0xFF1A1D23),
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixText: prefixText,
        prefixStyle: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white54 : const Color(0xFF6B7280),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 10.sp,
          color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF161B22) : Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE5E7EB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2E8B8B), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isDark) {
    final enabled = _senderVerified && _beneficiaryVerified;

    return GestureDetector(
      onTap: enabled ? _onSubmit : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [Color(0xFF2E8B8B), Color(0xFF1B6B6B)],
                )
              : null,
          color: enabled
              ? null
              : (isDark ? const Color(0xFF1E2328) : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(14),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xFF2E8B8B).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            'Continue',
            style: GoogleFonts.inter(
              fontSize: 10.5.sp,
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

// ══════════════════════════════════════════════════════════════
// ── OTP Verification Screen ──
// ══════════════════════════════════════════════════════════════
