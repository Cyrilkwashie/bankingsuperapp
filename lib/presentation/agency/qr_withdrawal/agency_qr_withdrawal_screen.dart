import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../shared/qr_scanner/qr_code_scanner_screen.dart';
part 'qr_withdrawal_otp_screen.dart';
part 'qr_withdrawal_receipt_screen.dart';
part 'success_dialog.dart';
part 'insufficient_funds_dialog.dart';

class AgencyQrWithdrawalScreen extends StatefulWidget {
  const AgencyQrWithdrawalScreen({super.key});

  @override
  State<AgencyQrWithdrawalScreen> createState() =>
      _AgencyQrWithdrawalScreenState();
}

class _AgencyQrWithdrawalScreenState extends State<AgencyQrWithdrawalScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _narrationController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  bool _isScanning = false;
  bool _accountVerified = false;
  bool _floatVisible = false;
  bool _balanceVisible = false;
  String _scannedAccountNo = '';
  String _accountName = '';
  String _accountStatus = '';
  String _accountBalance = '';

  // Mock accounts for demo (by account number)
  static const _mockAccounts = {
    '0012345678': {
      'name': 'Kwame Asante',
      'status': 'Active',
      'balance': 'GH₵ 12,450.00',
      'balanceNum': 12450.00,
    },
    '0023456789': {
      'name': 'Ama Mensah',
      'status': 'Active',
      'balance': 'GH₵ 8,320.50',
      'balanceNum': 8320.50,
    },
    '0034567890': {
      'name': 'Kofi Adjei',
      'status': 'Dormant',
      'balance': 'GH₵ 150.00',
      'balanceNum': 150.00,
    },
    '0045678901': {
      'name': 'Abena Osei',
      'status': 'Active',
      'balance': 'GH₵ 45,800.75',
      'balanceNum': 45800.75,
    },
  };

  // Mock QR codes that map to account numbers
  static const _mockQrCodes = {
    'QR-UTB-001': '0012345678',
    'QR-UTB-002': '0023456789',
    'QR-UTB-003': '0034567890',
    'QR-UTB-004': '0045678901',
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
    _amountController.dispose();
    _narrationController.dispose();
    super.dispose();
  }

  Future<void> _scanQrCode() async {
    setState(() {
      _isScanning = true;
      _accountVerified = false;
    });

    final scannedQr = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => const QrCodeScannerScreen(title: 'Scan Withdrawal QR'),
      ),
    );

    if (!mounted) return;

    final accountNo = scannedQr == null ? null : _resolveAccountNo(scannedQr);

    if (accountNo == null) {
      setState(() {
        _isScanning = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid or unsupported QR code',
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

    final account = _mockAccounts[accountNo];

    setState(() {
      _isScanning = false;
      if (account != null) {
        _accountVerified = true;
        _scannedAccountNo = accountNo;
        _accountName = account['name'] as String;
        _accountStatus = account['status'] as String;
        _accountBalance = account['balance'] as String;
      }
    });

    if (account != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'QR Code scanned successfully',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF059669),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String? _resolveAccountNo(String scannedQr) {
    final normalized = scannedQr.trim();

    if (_mockQrCodes.containsKey(normalized)) {
      return _mockQrCodes[normalized];
    }

    if (_mockAccounts.containsKey(normalized)) {
      return normalized;
    }

    final digits = RegExp(r'\d{10,}').firstMatch(normalized)?.group(0);
    if (digits == null) return null;

    final accountNo = digits.length > 10
        ? digits.substring(digits.length - 10)
        : digits;

    return _mockAccounts.containsKey(accountNo) ? accountNo : null;
  }

  void _clearScan() {
    setState(() {
      _accountVerified = false;
      _scannedAccountNo = '';
      _accountName = '';
      _accountStatus = '';
      _accountBalance = '';
    });
  }

  String get _fixedNarration {
    if (_accountName.isEmpty) return '';
    return 'UTB XPRESS E-CASH RECEIPT FROM ${_accountName.toUpperCase()}';
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_accountVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please scan a valid QR code first',
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

    // Check if account is active
    if (_accountStatus != 'Active') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cannot withdraw from a $_accountStatus account',
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

    // Check sufficient balance
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final account = _mockAccounts[_scannedAccountNo];
    final balance = (account?['balanceNum'] as num?)?.toDouble() ?? 0;
    if (amount > balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Insufficient balance for this withdrawal',
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

    // Navigate to OTP screen first (since money is leaving)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _QrWithdrawalOtpScreen(
          accountNo: _scannedAccountNo,
          accountName: _accountName,
          amount: _amountController.text.trim(),
          narration: _narrationController.text.trim(),
          fixedNarration: _fixedNarration,
          agentFloat: 'GH₵ 250,000.00',
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
                      // QR Scanner section
                      _buildQrScannerSection(isDark),

                      // Account info card (after successful scan)
                      if (_accountVerified) ...[
                        SizedBox(height: 2.h),
                        _buildAccountInfoCard(isDark),
                      ],

                      SizedBox(height: 2.2.h),

                      // Amount
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
                      SizedBox(height: 2.2.h),

                      // Narration
                      _buildFieldLabel('Narration', isDark),
                      SizedBox(height: 0.8.h),
                      _buildTextField(
                        controller: _narrationController,
                        hint: 'Optional narration',
                        isDark: isDark,
                        maxLines: 2,
                      ),
                      SizedBox(height: 1.2.h),

                      // Fixed narration display
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
                                'System Narration',
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

                      // Submit button
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

  // ── Header ──
  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B365D), Color(0xFF2E8B8B)],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E8B8B).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 1.5.h, 4.w, 2.5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildBackButton(),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'QR Withdrawal',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),
              // Agent float
              GestureDetector(
                onTap: () => setState(() => _floatVisible = !_floatVisible),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.5.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustomIconWidget(
                        iconName: 'account_balance_wallet',
                        color: Colors.white70,
                        size: 18,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        _floatVisible
                            ? 'Float: GH₵ 250,000.00'
                            : 'Float: ••••••••',
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: _floatVisible
                            ? 'visibility'
                            : 'visibility_off',
                        color: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 10.w,
          height: 10.w,
          alignment: Alignment.center,
          child: const CustomIconWidget(
            iconName: 'arrow_back_ios_new',
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  // ── QR Scanner Section ──
  Widget _buildQrScannerSection(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _accountVerified
              ? const Color(0xFF059669).withValues(alpha: 0.5)
              : isDark
              ? const Color(0xFF30363D)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // QR Icon / Scanner area
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: const Color(
                0xFF2E8B8B,
              ).withValues(alpha: isDark ? 0.1 : 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF2E8B8B).withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: _isScanning
                ? Center(
                    child: SizedBox(
                      width: 10.w,
                      height: 10.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF2E8B8B),
                        ),
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: _accountVerified
                            ? 'qr_code_2'
                            : 'qr_code_scanner',
                        color: _accountVerified
                            ? const Color(0xFF059669)
                            : const Color(0xFF2E8B8B),
                        size: 48,
                      ),
                      if (_accountVerified) ...[
                        SizedBox(height: 1.h),
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: const Color(0xFF059669),
                          size: 24,
                        ),
                      ],
                    ],
                  ),
          ),
          SizedBox(height: 2.h),

          // Scan button or scanned info
          if (!_accountVerified) ...[
            Text(
              'Scan customer\'s QR code to verify account',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isScanning ? null : _scanQrCode,
                icon: const CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  _isScanning ? 'Scanning...' : 'Scan QR Code',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E8B8B),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomIconWidget(
                  iconName: 'verified',
                  color: Color(0xFF059669),
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'QR Code Verified',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF059669),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            TextButton.icon(
              onPressed: _clearScan,
              icon: const CustomIconWidget(
                iconName: 'refresh',
                color: Color(0xFF2E8B8B),
                size: 18,
              ),
              label: Text(
                'Scan Again',
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2E8B8B),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Account Info Card ──
  Widget _buildAccountInfoCard(bool isDark) {
    final isActive = _accountStatus == 'Active';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isActive
              ? [
                  const Color(
                    0xFF059669,
                  ).withValues(alpha: isDark ? 0.15 : 0.08),
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
              ? const Color(0xFF059669).withValues(alpha: 0.3)
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
                  color:
                      (isActive
                              ? const Color(0xFF059669)
                              : const Color(0xFFF59E0B))
                          .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: isActive
                      ? const Color(0xFF059669)
                      : const Color(0xFFF59E0B),
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _accountName,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1A1D23),
                      ),
                    ),
                    SizedBox(height: 0.3.h),
                    Text(
                      'A/C: $_scannedAccountNo',
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
                  color: isActive
                      ? const Color(0xFF059669)
                      : const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _accountStatus,
                  style: GoogleFonts.inter(
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          GestureDetector(
            onTap: () => setState(() => _balanceVisible = !_balanceVisible),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color:
                    (isActive
                            ? const Color(0xFF059669)
                            : const Color(0xFFF59E0B))
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
                      color: isDark ? Colors.white54 : const Color(0xFF64748B),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _balanceVisible ? _accountBalance : '••••••••',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? const Color(0xFF059669)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                  Icon(
                    _balanceVisible ? Icons.visibility : Icons.visibility_off,
                    size: 14.sp,
                    color: isDark ? Colors.white54 : const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Field Label ──
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

  // ── Text Field ──
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int maxLines = 1,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
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
        hintStyle: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
        ),
        prefixStyle: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : const Color(0xFF374151),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF161B22) : Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF30363D) : const Color(0xFFE2E8F0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF30363D) : const Color(0xFFE2E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E8B8B), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
        ),
      ),
    );
  }

  // ── Submit Button ──
  Widget _buildSubmitButton(bool isDark) {
    return Container(
      width: double.infinity,
      height: 6.5.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E8B8B), Color(0xFF3BA5A5)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E8B8B).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomIconWidget(
              iconName: 'lock',
              color: Colors.white,
              size: 22,
            ),
            SizedBox(width: 2.w),
            Text(
              'Proceed to Verify',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// QR WITHDRAWAL OTP SCREEN
// ════════════════════════════════════════════════════════════════════════════
