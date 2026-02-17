part of 'agency_full_statement_screen.dart';

class _StatementOtpScreen extends StatefulWidget {
  final String customerPhone;
  final String accountNo;
  final String accountName;
  final String accountBalance;
  final String statementType;
  final DateTime startDate;
  final DateTime endDate;
  final String? pickupBranch;
  final Color accentColor;
  final List<Color> gradientColors;

  const _StatementOtpScreen({
    required this.customerPhone,
    required this.accountNo,
    required this.accountName,
    required this.accountBalance,
    required this.statementType,
    required this.startDate,
    required this.endDate,
    required this.pickupBranch,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_StatementOtpScreen> createState() => _StatementOtpScreenState();
}

class _StatementOtpScreenState extends State<_StatementOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
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
            builder: (_) => _StatementConfirmationScreen(
              accountNo: widget.accountNo,
              accountName: widget.accountName,
              accountBalance: widget.accountBalance,
              statementType: widget.statementType,
              startDate: widget.startDate,
              endDate: widget.endDate,
              pickupBranch: widget.pickupBranch,
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
      backgroundColor: isDark
          ? const Color(0xFF0D1117)
          : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(isDark),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 4.h),
              child: Column(
                children: [
                  // Icon
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
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 3.w,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _otpError
                                      ? const Color(0xFFDC2626)
                                      : isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : const Color(0xFFE5E7EB),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _otpError
                                      ? const Color(0xFFDC2626)
                                      : isDark
                                      ? Colors.white.withValues(alpha: 0.08)
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
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Color(0xFFDC2626),
                          size: 16,
                        ),
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

                  // Resend OTP
                  if (_resendCountdown > 0)
                    Text(
                      'Resend OTP in ${_resendCountdown}s',
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? Colors.white38
                            : const Color(0xFF9CA3AF),
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

                  // Verify Button
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
                                  widget.accentColor.withValues(alpha: 0.85),
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
                                  color: widget.accentColor.withValues(
                                    alpha: 0.3,
                                  ),
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

                  // Cancel Button
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
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Security note
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
                            'This OTP verification protects the account from unauthorized statement requests.',
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
                      'Statement Security',
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
// ── Confirmation Screen ──
// ══════════════════════════════════════════════════════════════
