import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
part 'reverse_otp_screen.dart';
part 'reverse_confirmation_screen.dart';
part 'reverse_success_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Agency Reverse Transaction Screen ──
// ══════════════════════════════════════════════════════════════

class _ReverseTxn {
  final String reference;
  final String type;
  final String customer;
  final String accountNo;
  final String amount;
  final String phone;
  final String time;
  final String date;

  const _ReverseTxn({
    required this.reference,
    required this.type,
    required this.customer,
    required this.accountNo,
    required this.amount,
    required this.phone,
    required this.time,
    required this.date,
  });
}

class AgencyReverseTransactionScreen extends StatefulWidget {
  const AgencyReverseTransactionScreen({super.key});

  @override
  State<AgencyReverseTransactionScreen> createState() =>
      _AgencyReverseTransactionScreenState();
}

class _AgencyReverseTransactionScreenState
    extends State<AgencyReverseTransactionScreen>
    with SingleTickerProviderStateMixin {
  static const Color _accent = Color(0xFF2E8B8B);
  static const List<Color> _gradient = [Color(0xFF1B365D), Color(0xFF2E8B8B)];
  static const Color _success = Color(0xFF059669);
  static const double _fieldRadius = 10;

  EdgeInsets get _fieldPadding =>
      EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.95.h);

  final _formKey = GlobalKey<FormState>();
  final _referenceController = TextEditingController();
  final _narrationController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  bool _isLookingUp = false;
  bool _referenceNotFound = false;
  _ReverseTxn? _selectedTxn;
  String? _selectedReason;
  Timer? _debounce;

  static const _reversalReasons = [
    'Customer Request',
    'Duplicate Transaction',
    'Wrong Amount',
    'Wrong Account',
    'Agent Error',
    'System Error',
  ];

  static const _mockTransactionsByRef = {
    'AGY-REF-001': _ReverseTxn(
      reference: 'AGY-REF-001',
      type: 'Cash Deposit',
      customer: 'Kwame Asante',
      accountNo: '0012345678',
      amount: '1,500.00',
      phone: '232501234567',
      time: '09:15 AM',
      date: '25 May 2026',
    ),
    'AGY-REF-002': _ReverseTxn(
      reference: 'AGY-REF-002',
      type: 'Cash Withdrawal',
      customer: 'Ama Mensah',
      accountNo: '0023456789',
      amount: '800.00',
      phone: '232502345678',
      time: '10:42 AM',
      date: '25 May 2026',
    ),
    'AGY-REF-003': _ReverseTxn(
      reference: 'AGY-REF-003',
      type: 'Same Bank Transfer',
      customer: 'Kofi Adjei',
      accountNo: '0034567890',
      amount: '2,250.00',
      phone: '232503456789',
      time: '11:08 AM',
      date: '25 May 2026',
    ),
    'AGY-REF-004': _ReverseTxn(
      reference: 'AGY-REF-004',
      type: 'QR Deposit',
      customer: 'Abena Osei',
      accountNo: '0045678901',
      amount: '350.00',
      phone: '232504567890',
      time: '12:30 PM',
      date: '25 May 2026',
    ),
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
    _referenceController.dispose();
    _narrationController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onReferenceChanged(String value) {
    _debounce?.cancel();
    final query = value.trim().toUpperCase();
    if (query.length < 6) {
      setState(() {
        _selectedTxn = null;
        _referenceNotFound = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _lookupReference(query);
    });
  }

  Future<void> _lookupReference(String query) async {
    setState(() {
      _isLookingUp = true;
      _selectedTxn = null;
      _referenceNotFound = false;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    final txn = _mockTransactionsByRef[query];
    setState(() {
      _isLookingUp = false;
      if (txn != null) {
        _selectedTxn = txn;
        _referenceNotFound = false;
      } else {
        _referenceNotFound = true;
      }
    });
  }

  bool get _canContinue => _selectedTxn != null && _selectedReason != null;

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    if (!_canContinue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectedTxn == null
                ? 'Please locate a transaction to reverse'
                : 'Please select a reversal reason',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFDC2626),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final txn = _selectedTxn!;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ReverseOtpScreen(
          txn: txn,
          reason: _selectedReason!,
          narration: _narrationController.text.trim(),
          accentColor: _accent,
          gradientColors: _gradient,
        ),
      ),
    );
  }

  static String maskAccountNo(String no) {
    if (no.length >= 7) {
      return '${no.substring(0, 3)} •••• ${no.substring(no.length - 3)}';
    }
    return no;
  }

  static Widget buildFlowStepIndicator(int currentStep, bool isDark) {
    const labels = ['Find', 'Verify', 'Confirm'];
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
        children: List.generate(3, (i) {
          final step = i + 1;
          final isLast = step == 3;
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
            buildFlowStepIndicator(1, isDark),
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
                        title: 'Locate Transaction',
                        subtitle: 'Find a same-day transaction to reverse',
                        icon: Icons.search_rounded,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Transaction Reference', isDark),
                            SizedBox(height: 0.4.h),
                            _buildReferenceField(isDark),
                            if (_isLookingUp) _buildLookupLoader(isDark),
                            if (_referenceNotFound) _buildNotFoundCard(isDark),
                            if (_selectedTxn != null) ...[
                              SizedBox(height: 1.3.h),
                              _buildTxnDetailCard(_selectedTxn!, isDark),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      _buildSectionCard(
                        isDark: isDark,
                        title: 'Reversal Details',
                        subtitle: 'Reason and optional narration',
                        icon: Icons.edit_note_rounded,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Reversal Reason', isDark),
                            SizedBox(height: 0.4.h),
                            _buildReasonDropdown(isDark),
                            SizedBox(height: 1.3.h),
                            _buildFieldLabel('Narration (Optional)', isDark),
                            SizedBox(height: 0.4.h),
                            _buildNarrationField(isDark),
                          ],
                        ),
                      ),
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
                    Icons.undo_rounded,
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
                      'Reverse Transaction',
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
              'Only same-day transactions can be reversed. Locate the original transaction, verify with customer OTP, then confirm the reversal.',
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

  Widget _buildReferenceField(bool isDark) {
    return TextFormField(
      controller: _referenceController,
      onChanged: _onReferenceChanged,
      textCapitalization: TextCapitalization.characters,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 9.sp,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : const Color(0xFF1A1D23),
        letterSpacing: 0.5,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: 'AGY-REF-001',
        hintStyle: GoogleFonts.jetBrainsMono(
          fontSize: 9.sp,
          color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
        contentPadding: _fieldPadding,
        prefixIcon: Icon(
          Icons.tag_outlined,
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
            color: _selectedTxn != null
                ? _accent.withValues(alpha: 0.4)
                : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFE5E7EB)),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_fieldRadius),
          borderSide: const BorderSide(color: _accent, width: 1),
        ),
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
              color: isDark ? Colors.white38 : _accent,
            ),
          ),
          SizedBox(width: 2.5.w),
          Text(
            'Looking up transaction...',
            style: GoogleFonts.inter(
              fontSize: 8.sp,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundCard(bool isDark) {
    return Padding(
      padding: EdgeInsets.only(top: 1.2.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFFDC2626).withValues(alpha: 0.08)
              : const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFDC2626).withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 16),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'Transaction not found. Check the reference and try again.',
                style: GoogleFonts.inter(
                  fontSize: 7.5.sp,
                  color: isDark ? Colors.white54 : const Color(0xFF991B1B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTxnDetailCard(_ReverseTxn txn, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _success.withValues(alpha: isDark ? 0.1 : 0.05),
            _success.withValues(alpha: isDark ? 0.03 : 0.01),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _success.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_outlined, color: _success, size: 16),
              SizedBox(width: 2.w),
              Text(
                'Transaction Found',
                style: GoogleFonts.inter(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w700,
                  color: _success,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _detailRow('Type', txn.type, isDark),
          _detailRow('Customer', txn.customer, isDark),
          _detailRow('Account', maskAccountNo(txn.accountNo), isDark),
          _detailRow('Amount', 'GH₵ ${txn.amount}', isDark, highlight: true),
          _detailRow('Original Ref', txn.reference, isDark, mono: true),
          _detailRow('Date', txn.date, isDark),
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value,
    bool isDark, {
    bool highlight = false,
    bool mono = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.35.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: mono
                  ? GoogleFonts.jetBrainsMono(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    )
                  : GoogleFonts.inter(
                      fontSize: highlight ? 9.sp : 8.sp,
                      fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                      color: highlight
                          ? _accent
                          : (isDark ? Colors.white : const Color(0xFF111827)),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonDropdown(bool isDark) {
    return Container(
      height: 42,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(_fieldRadius),
        border: Border.all(
          color: _selectedReason != null
              ? _accent.withValues(alpha: 0.4)
              : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFE5E7EB)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedReason,
          isExpanded: true,
          isDense: true,
          hint: Text(
            'Select reason',
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: _selectedReason != null
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
          items: _reversalReasons
              .map(
                (r) => DropdownMenuItem<String>(
                  value: r,
                  child: Text(r),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _selectedReason = v),
        ),
      ),
    );
  }

  Widget _buildNarrationField(bool isDark) {
    return TextFormField(
      controller: _narrationController,
      maxLines: 2,
      maxLength: 120,
      style: GoogleFonts.inter(
        fontSize: 9.sp,
        color: isDark ? Colors.white : const Color(0xFF1A1D23),
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Additional notes (optional)',
        hintStyle: GoogleFonts.inter(
          fontSize: 9.sp,
          color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
        contentPadding: _fieldPadding,
        counterText: '',
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
          borderSide: const BorderSide(color: _accent, width: 1),
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
        child: GestureDetector(
          onTap: _canContinue ? _onContinue : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 1.25.h),
            decoration: BoxDecoration(
              gradient: _canContinue
                  ? LinearGradient(
                      colors: [_accent, _accent.withValues(alpha: 0.85)],
                    )
                  : null,
              color: _canContinue
                  ? null
                  : (isDark ? const Color(0xFF1E2328) : const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(10),
              boxShadow: _canContinue
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
                  color: _canContinue
                      ? Colors.white
                      : (isDark ? Colors.white24 : const Color(0xFF9CA3AF)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
