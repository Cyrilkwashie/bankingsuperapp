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
  static const Color _accent = Color(0xFF2E8B8B);
  static const List<Color> _gradient = [Color(0xFF1B365D), Color(0xFF2E8B8B)];
  static const Color _success = Color(0xFF059669);
  static const double _fieldRadius = 10;

  EdgeInsets get _fieldPadding =>
      EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.95.h);

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
          backgroundColor: _success,
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

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _QrWithdrawalOtpScreen(
          accountNo: _scannedAccountNo,
          accountName: _accountName,
          amount: _amountController.text.trim(),
          narration: _narrationController.text.trim(),
          fixedNarration: _fixedNarration,
          agentFloat: 'GH₵ 250,000.00',
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
                        title: 'Scan QR Code',
                        subtitle: 'Scan the customer\'s withdrawal QR to verify account',
                        icon: Icons.qr_code_scanner_rounded,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildQrScannerArea(isDark),
                            if (_accountVerified) _buildAccountInfoCard(isDark),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      _buildSectionCard(
                        isDark: isDark,
                        title: 'Withdrawal Details',
                        subtitle: 'Amount and optional narration',
                        icon: Icons.payments_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Amount', isDark),
                            SizedBox(height: 0.4.h),
                            _buildAmountField(isDark),
                            SizedBox(height: 1.3.h),
                            _buildFieldLabel('Narration (optional)', isDark),
                            SizedBox(height: 0.4.h),
                            _buildTextField(
                              controller: _narrationController,
                              hint: 'Add a note for this withdrawal',
                              isDark: isDark,
                              maxLines: 2,
                              onChanged: (_) => setState(() {}),
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
                    Icons.qr_code_scanner_rounded,
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
                      'QR Withdrawal',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.5.w,
                      vertical: 0.45.h,
                    ),
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
                        SizedBox(width: 1.2.w),
                        Text(
                          'Online',
                          style: GoogleFonts.inter(
                            fontSize: 6.5.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  GestureDetector(
                    onTap: () => setState(() => _floatVisible = !_floatVisible),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.5.w,
                        vertical: 0.45.h,
                      ),
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
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 11,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _floatVisible ? '250,000' : '••••••',
                            style: GoogleFonts.inter(
                              fontSize: 6.5.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(width: 0.8.w),
                          Icon(
                            _floatVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 11,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
          _stepDot(1, currentStep, 'Scan', isDark),
          _stepConnector(currentStep >= 2, isDark),
          _stepDot(2, currentStep, 'Verify', isDark),
          _stepConnector(currentStep >= 3, isDark),
          _stepDot(3, currentStep, 'Confirm', isDark),
        ],
      ),
    );
  }

  Widget _stepConnector(bool active, bool isDark) {
    return Expanded(
      child: Container(
        height: 2,
        margin: EdgeInsets.only(bottom: 2.2.h, left: 1.w, right: 1.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: active
              ? LinearGradient(
                  colors: [_accent, _accent.withValues(alpha: 0.5)],
                )
              : null,
          color: active
              ? null
              : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFE5E7EB)),
        ),
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
              'Scan the customer QR code, enter the withdrawal amount, then verify with OTP before confirming.',
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

  Widget _buildQrScannerArea(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _accountVerified
              ? _success.withValues(alpha: 0.35)
              : isDark
              ? Colors.white.withValues(alpha: 0.08)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _accent.withValues(alpha: 0.2)),
            ),
            child: _isScanning
                ? Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _accent,
                      ),
                    ),
                  )
                : Icon(
                    _accountVerified
                        ? Icons.qr_code_2_rounded
                        : Icons.qr_code_scanner_rounded,
                    color: _accountVerified ? _success : _accent,
                    size: 26,
                  ),
          ),
          SizedBox(height: 1.h),
          if (!_accountVerified) ...[
            Text(
              'Scan customer\'s QR code to verify account',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                height: 1.35,
                color: isDark ? Colors.white54 : const Color(0xFF64748B),
              ),
            ),
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: _isScanning ? null : _scanQrCode,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.85.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_accent, _accent.withValues(alpha: 0.85)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: _accent.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 1.5.w),
                    Text(
                      _isScanning ? 'Scanning...' : 'Scan QR Code',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified_rounded, color: _success, size: 16),
                SizedBox(width: 1.5.w),
                Text(
                  'QR Code Verified',
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: _success,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.6.h),
            GestureDetector(
              onTap: _clearScan,
              child: Text(
                'Scan Again',
                style: GoogleFonts.inter(
                  fontSize: 7.5.sp,
                  fontWeight: FontWeight.w500,
                  color: _accent,
                ),
              ),
            ),
          ],
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
                        _maskAccountNo(_scannedAccountNo),
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
            if (enabled) ...[
              const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 16),
              SizedBox(width: 1.5.w),
            ],
            Text(
              'Proceed to Verify',
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
