import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

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
  String _senderName = '';
  String _senderStatus = '';
  String _senderBalance = '';
  String _resolvedSenderAccountNo = '';
  String _senderPhone = '';
  Timer? _senderDebounce;
  String _senderLookupType = 'account';

  // Beneficiary lookup
  bool _isLookingUpBeneficiary = false;
  bool _beneficiaryVerified = false;
  bool _beneficiaryNotFound = false;
  String _beneficiaryName = '';
  String _beneficiaryStatus = '';
  String _resolvedBeneficiaryAccountNo = '';
  Timer? _beneficiaryDebounce;
  String _beneficiaryLookupType = 'account';

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

  static const _mockPhoneAccounts = {
    '232501234567': {
      'accountNo': '0012345678',
      'name': 'Kwame Asante',
      'status': 'Active',
      'balance': 'GH₵ 12,450.00',
    },
    '232502345678': {
      'accountNo': '0023456789',
      'name': 'Ama Mensah',
      'status': 'Active',
      'balance': 'GH₵ 8,320.50',
    },
    '232503456789': {
      'accountNo': '0034567890',
      'name': 'Kofi Adjei',
      'status': 'Dormant',
      'balance': 'GH₵ 150.00',
    },
    '232504567890': {
      'accountNo': '0045678901',
      'name': 'Abena Osei',
      'status': 'Active',
      'balance': 'GH₵ 45,800.75',
    },
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
    });

    await Future.delayed(const Duration(milliseconds: 900));

    Map<String, String>? account;
    String accountNo = input;
    String customerPhone = '';

    if (_senderLookupType == 'phone') {
      final phoneAccount = _mockPhoneAccounts[input];
      if (phoneAccount != null) {
        account = {
          'name': phoneAccount['name']!,
          'status': phoneAccount['status']!,
          'balance': phoneAccount['balance']!,
        };
        accountNo = phoneAccount['accountNo']!;
        customerPhone = input;
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

  void _onSenderLookupTypeChanged(String type) {
    setState(() {
      _senderLookupType = type;
      _senderController.clear();
      _senderVerified = false;
      _senderNotFound = false;
      _resolvedSenderAccountNo = '';
      _senderPhone = '';
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
    });

    await Future.delayed(const Duration(milliseconds: 900));

    Map<String, String>? account;
    String accountNo = input;

    if (_beneficiaryLookupType == 'phone') {
      final phoneAccount = _mockPhoneAccounts[input];
      if (phoneAccount != null) {
        account = {
          'name': phoneAccount['name']!,
          'status': phoneAccount['status']!,
        };
        accountNo = phoneAccount['accountNo']!;
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    // Get bank name from code
    final bankName = _banks.firstWhere((b) => b['code'] == _selectedBank)['name']!;

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
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
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
                      if (_senderVerified)
                        _buildAccountInfoCard(
                          isDark,
                          _senderName,
                          _senderStatus,
                          showBalance: true,
                        ),
                      if (_senderNotFound)
                        _buildNotFoundCard(isDark, _senderLookupType == 'phone'),

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
                      if (_beneficiaryVerified)
                        _buildAccountInfoCard(
                          isDark,
                          _beneficiaryName,
                          _beneficiaryStatus,
                          showBalance: false,
                        ),
                      if (_beneficiaryNotFound)
                        _buildNotFoundCard(
                            isDark, _beneficiaryLookupType == 'phone'),

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
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
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
                              horizontal: 4.w, vertical: 1.2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E8B8B)
                                .withValues(alpha: isDark ? 0.08 : 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF2E8B8B)
                                  .withValues(alpha: 0.15),
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
                    child: Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 19),
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
                padding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
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
        value: _selectedBank,
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
          contentPadding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
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
            borderSide: const BorderSide(
              color: Color(0xFF2E8B8B),
              width: 1.5,
            ),
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
                            color:
                                const Color(0xFF2E8B8B).withValues(alpha: 0.2),
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
                          : (isDark
                              ? Colors.white38
                              : const Color(0xFF9CA3AF)),
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
                            color:
                                const Color(0xFF2E8B8B).withValues(alpha: 0.2),
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
                          : (isDark
                              ? Colors.white38
                              : const Color(0xFF9CA3AF)),
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
          borderSide: const BorderSide(
            color: Color(0xFF2E8B8B),
            width: 1.5,
          ),
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
                ? const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF059669), size: 22)
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
    String status, {
    bool showBalance = false,
  }) {
    final isActive = status == 'Active';

    return Padding(
      padding: EdgeInsets.only(top: 1.2.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.5.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0D2818) : const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF059669).withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF059669).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(Icons.person_rounded,
                    color: Color(0xFF059669), size: 20),
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
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A1D23),
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.w, vertical: 0.2.h),
                    decoration: BoxDecoration(
                      color: (isActive
                              ? const Color(0xFF059669)
                              : const Color(0xFFD97706))
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? const Color(0xFF059669)
                            : const Color(0xFFD97706),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showBalance)
              Text(
                'XXXXXX',
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                ),
              ),
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
                child: Icon(Icons.person_off_rounded,
                    color: Color(0xFFDC2626), size: 18),
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
          borderSide: const BorderSide(
            color: Color(0xFF2E8B8B),
            width: 1.5,
          ),
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

class _TransferOtpScreen extends StatefulWidget {
  final String customerPhone;
  final String senderAccountNo;
  final String senderName;
  final String senderBalance;
  final String beneficiaryAccountNo;
  final String beneficiaryName;
  final String beneficiaryBank;
  final String amount;
  final String transferredBy;
  final String narration;
  final String fixedNarration;
  final Color accentColor;
  final List<Color> gradientColors;

  const _TransferOtpScreen({
    required this.customerPhone,
    required this.senderAccountNo,
    required this.senderName,
    required this.senderBalance,
    required this.beneficiaryAccountNo,
    required this.beneficiaryName,
    required this.beneficiaryBank,
    required this.amount,
    required this.transferredBy,
    required this.narration,
    required this.fixedNarration,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_TransferOtpScreen> createState() => _TransferOtpScreenState();
}

class _TransferOtpScreenState extends State<_TransferOtpScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isVerifying = false;
  bool _otpError = false;
  int _resendCountdown = 0;
  Timer? _countdownTimer;

  static const String _mockOtp = '123456';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendOtp();
    });
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _sendOtp() {
    if (!mounted) return;

    setState(() {
      _resendCountdown = 60;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'OTP sent to ${_maskPhone(widget.customerPhone)}',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF059669),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _maskPhone(String phone) {
    if (phone.length < 8) return phone;
    return '${phone.substring(0, 5)}****${phone.substring(phone.length - 3)}';
  }

  String get _enteredOtp => _otpControllers.map((c) => c.text).join();

  void _onOtpChanged(int index, String value) {
    setState(() => _otpError = false);

    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    if (_enteredOtp.length == 6) {
      _verifyOtp();
    }
  }

  void _onOtpKeyDown(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey.keyLabel == 'Backspace' &&
        _otpControllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length != 6) return;

    setState(() {
      _isVerifying = true;
      _otpError = false;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (_enteredOtp == _mockOtp) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => _TransferReceiptScreen(
              senderAccountNo: widget.senderAccountNo,
              senderName: widget.senderName,
              senderBalance: widget.senderBalance,
              beneficiaryAccountNo: widget.beneficiaryAccountNo,
              beneficiaryName: widget.beneficiaryName,
              beneficiaryBank: widget.beneficiaryBank,
              amount: widget.amount,
              transferredBy: widget.transferredBy,
              narration: widget.narration,
              fixedNarration: widget.fixedNarration,
              accentColor: widget.accentColor,
              gradientColors: widget.gradientColors,
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isVerifying = false;
        _otpError = true;
      });
      for (final c in _otpControllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(isDark),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 4.h),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.sms_rounded,
                        color: widget.accentColor,
                        size: 36,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.5.h),

                  Text(
                    'Verify OTP',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 1.h),

                  Text(
                    'Enter the 6-digit code sent to',
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    _maskPhone(widget.customerPhone),
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: widget.accentColor,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 12.w,
                        height: 14.w,
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        child: KeyboardListener(
                          focusNode: FocusNode(),
                          onKeyEvent: (event) => _onOtpKeyDown(index, event),
                          child: TextFormField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            onChanged: (v) => _onOtpChanged(index, v),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A1D23),
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: isDark
                                  ? const Color(0xFF161B22)
                                  : Colors.white,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 3.w),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _otpError
                                      ? const Color(0xFFDC2626)
                                      : isDark
                                          ? Colors.white
                                              .withValues(alpha: 0.08)
                                          : const Color(0xFFE5E7EB),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _otpError
                                      ? const Color(0xFFDC2626)
                                      : isDark
                                          ? Colors.white
                                              .withValues(alpha: 0.08)
                                          : const Color(0xFFE5E7EB),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _otpError
                                      ? const Color(0xFFDC2626)
                                      : widget.accentColor,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  if (_otpError) ...[
                    SizedBox(height: 1.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: Color(0xFFDC2626), size: 16),
                        SizedBox(width: 1.w),
                        Text(
                          'Invalid OTP. Please try again.',
                          style: GoogleFonts.inter(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ],

                  SizedBox(height: 3.h),

                  if (_resendCountdown > 0)
                    Text(
                      'Resend OTP in ${_resendCountdown}s',
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w400,
                        color:
                            isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _sendOtp,
                      child: Text(
                        'Resend OTP',
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: widget.accentColor,
                        ),
                      ),
                    ),

                  SizedBox(height: 4.h),

                  GestureDetector(
                    onTap: _isVerifying ? null : _verifyOtp,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 1.7.h),
                      decoration: BoxDecoration(
                        gradient: _enteredOtp.length == 6 && !_isVerifying
                            ? LinearGradient(
                                colors: [
                                  widget.accentColor,
                                  widget.accentColor.withValues(alpha: 0.85)
                                ],
                              )
                            : null,
                        color: _enteredOtp.length == 6 && !_isVerifying
                            ? null
                            : (isDark
                                ? const Color(0xFF1E2328)
                                : const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: _enteredOtp.length == 6 && !_isVerifying
                            ? [
                                BoxShadow(
                                  color: widget.accentColor
                                      .withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: _isVerifying
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Verify & Continue',
                                style: GoogleFonts.inter(
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: _enteredOtp.length == 6
                                      ? Colors.white
                                      : (isDark
                                          ? Colors.white24
                                          : const Color(0xFF9CA3AF)),
                                ),
                              ),
                      ),
                    ),
                  ),

                  SizedBox(height: 1.5.h),

                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161B22) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color:
                                isDark ? Colors.white54 : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Container(
                    padding: EdgeInsets.all(3.5.w),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.accentColor.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security_rounded,
                          color: widget.accentColor,
                          size: 20,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'This OTP verification protects against unauthorized transfers.',
                            style: GoogleFonts.inter(
                              fontSize: 7.5.sp,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? Colors.white54
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
              : widget.gradientColors,
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
                    child: Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 19),
                  ),
                ),
              ),
              SizedBox(width: 3.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OTP Verification',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Transfer Security',
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
                padding:
                    EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
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
                    const Icon(
                      Icons.lock_rounded,
                      size: 12,
                      color: Colors.white70,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Secure',
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
}

// ══════════════════════════════════════════════════════════════
// ── Transfer Receipt / Confirmation Screen ──
// ══════════════════════════════════════════════════════════════

class _TransferReceiptScreen extends StatelessWidget {
  final String senderAccountNo;
  final String senderName;
  final String senderBalance;
  final String beneficiaryAccountNo;
  final String beneficiaryName;
  final String beneficiaryBank;
  final String amount;
  final String transferredBy;
  final String narration;
  final String fixedNarration;
  final Color accentColor;
  final List<Color> gradientColors;

  const _TransferReceiptScreen({
    required this.senderAccountNo,
    required this.senderName,
    required this.senderBalance,
    required this.beneficiaryAccountNo,
    required this.beneficiaryName,
    required this.beneficiaryBank,
    required this.amount,
    required this.transferredBy,
    required this.narration,
    required this.fixedNarration,
    required this.accentColor,
    required this.gradientColors,
  });

  double get _amountValue => double.tryParse(amount) ?? 0;
  double get _charges => _amountValue * 0.01;
  double get _totalAmount => _amountValue + _charges;

  double get _parsedBalance {
    final cleaned = senderBalance.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF162032), const Color(0xFF0D1117)]
                    : gradientColors,
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
                          child: Icon(Icons.arrow_back_rounded,
                              color: Colors.white, size: 19),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.5.w),
                    Text(
                      'Confirm Transfer',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 4.h),
              child: Column(
                children: [
                  _buildAmountCard(isDark),
                  SizedBox(height: 2.h),
                  _buildTransferFlow(isDark),
                  SizedBox(height: 2.h),
                  _buildDetailsCard(isDark),
                  SizedBox(height: 2.h),
                  _buildChargesCard(isDark),
                  SizedBox(height: 3.h),
                  _buildConfirmButton(context, isDark),
                  SizedBox(height: 1.2.h),
                  _buildCancelButton(context, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2.5.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : [
                  accentColor.withValues(alpha: 0.06),
                  accentColor.withValues(alpha: 0.02),
                ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.15 : 0.12),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Transfer Amount',
            style: GoogleFonts.inter(
              fontSize: 8.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'GH₵ $amount',
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A1D23),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferFlow(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.arrow_upward_rounded,
                        color: Color(0xFFDC2626), size: 22),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'From',
                  style: GoogleFonts.inter(
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  senderName,
                  style: GoogleFonts.inter(
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A1D23),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: accentColor,
              size: 24,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.arrow_downward_rounded,
                        color: Color(0xFF059669), size: 22),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'To',
                  style: GoogleFonts.inter(
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  beneficiaryName,
                  style: GoogleFonts.inter(
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A1D23),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Details',
            style: GoogleFonts.inter(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 1.5.h),
          _detailRow('Sender Account', senderAccountNo, isDark),
          _divider(isDark),
          _detailRow('Beneficiary Account', beneficiaryAccountNo, isDark),
          _divider(isDark),
          _detailRow('Beneficiary Bank', beneficiaryBank, isDark),
          _divider(isDark),
          _detailRow('Transferred By', transferredBy, isDark),
          if (narration.isNotEmpty) ...[
            _divider(isDark),
            _detailRow('Narration', narration, isDark),
          ],
          _divider(isDark),
          _detailRow('Trans. Description', fixedNarration, isDark,
              valueSize: 7.5.sp),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, bool isDark,
      {double? valueSize}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32.w,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 8.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: valueSize ?? 9.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF1A1D23),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark
          ? Colors.white.withValues(alpha: 0.05)
          : const Color(0xFFF3F4F6),
    );
  }

  Widget _buildChargesCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Charges & Total',
            style: GoogleFonts.inter(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 1.5.h),
          _detailRow('Amount', 'GH₵ ${_amountValue.toStringAsFixed(2)}', isDark),
          _divider(isDark),
          _detailRow(
              'Charges (1%)', 'GH₵ ${_charges.toStringAsFixed(2)}', isDark),
          _divider(isDark),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.8.h),
            child: Row(
              children: [
                Text(
                  'Total Debit',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                Text(
                  'GH₵ ${_totalAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        if (_parsedBalance < _totalAmount) {
          showDialog(
            context: context,
            builder: (_) => _InsufficientFundsDialog(
              balance: senderBalance,
              required: 'GH₵ ${_totalAmount.toStringAsFixed(2)}',
              accentColor: accentColor,
            ),
          );
          return;
        }
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => _SuccessDialog(
            amount: 'GH₵ ${_amountValue.toStringAsFixed(2)}',
            beneficiaryName: beneficiaryName,
            accentColor: accentColor,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accentColor, accentColor.withValues(alpha: 0.85)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            SizedBox(width: 2.w),
            Text(
              'Confirm & Transfer',
              style: GoogleFonts.inter(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161B22) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Center(
          child: Text(
            'Go Back',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Success Dialog ──
class _SuccessDialog extends StatelessWidget {
  final String amount;
  final String beneficiaryName;
  final Color accentColor;

  const _SuccessDialog({
    required this.amount,
    required this.beneficiaryName,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      insetPadding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF059669).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.check_rounded,
                    color: Color(0xFF059669), size: 36),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Transfer Successful',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            SizedBox(height: 0.8.h),
            Text(
              '$amount transferred to $beneficiaryName',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white54 : const Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 2.5.h),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentColor, accentColor.withValues(alpha: 0.85)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Done',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.8.h),
                child: Text(
                  'New Transfer',
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Insufficient Funds Dialog ──
class _InsufficientFundsDialog extends StatelessWidget {
  final String balance;
  final String required;
  final Color accentColor;

  const _InsufficientFundsDialog({
    required this.balance,
    required this.required,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      insetPadding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.account_balance_wallet_outlined,
                    color: Color(0xFFDC2626), size: 32),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Insufficient Balance',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            SizedBox(height: 0.8.h),
            Text(
              "The sender's account does not have sufficient funds for this transfer.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 8.5.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            SizedBox(height: 2.5.h),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color:
                      isDark ? const Color(0xFF1E2328) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Go Back',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : const Color(0xFF374151),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
