part of 'merchant_qr_withdrawal_screen.dart';

class _MerchantQrWithdrawalOtpScreen extends StatefulWidget {
  final String accountNo;
  final String accountName;
  final String amount;
  final String narration;
  final String fixedNarration;
  final String merchantFloat;
  final Color accentColor;
  final List<Color> gradientColors;

  const _MerchantQrWithdrawalOtpScreen({
    required this.accountNo,
    required this.accountName,
    required this.amount,
    required this.narration,
    required this.fixedNarration,
    required this.merchantFloat,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_MerchantQrWithdrawalOtpScreen> createState() =>
      _MerchantQrWithdrawalOtpScreenState();
}

class _MerchantQrWithdrawalOtpScreenState
    extends State<_MerchantQrWithdrawalOtpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isVerifying = false;
  int _resendCountdown = 60;
  Timer? _resendTimer;

  // Mock OTP for demo
  static const _mockOtp = '123456';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    // Show OTP sent message after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendOtp();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _sendOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'OTP sent to customer\'s registered phone',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: widget.accentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    setState(() => _resendCountdown = 60);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
  }

  String get _otpValue => _otpControllers.map((c) => c.text).join();

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_otpValue.length == 6) {
      _verifyOtp();
    }
  }

  void _handleKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_otpControllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpValue.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter the complete 6-digit OTP',
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

    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    if (_otpValue == _mockOtp) {
      // Navigate to receipt screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => _MerchantQrWithdrawalReceiptScreen(
            accountNo: widget.accountNo,
            accountName: widget.accountName,
            amount: widget.amount,
            narration: widget.narration,
            fixedNarration: widget.fixedNarration,
            merchantFloat: widget.merchantFloat,
            accentColor: widget.accentColor,
            gradientColors: widget.gradientColors,
          ),
        ),
      );
    } else {
      setState(() => _isVerifying = false);
      for (var c in _otpControllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid OTP. Please try again.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFDC2626),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
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
                padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 4.h),
                child: Column(
                  children: [
                    _buildOtpIcon(isDark),
                    SizedBox(height: 2.h),
                    Text(
                      'Enter OTP',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1A1D23),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'A 6-digit code has been sent to the customer\'s registered phone number',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    _buildOtpInput(isDark),
                    SizedBox(height: 2.h),
                    _buildResendSection(isDark),
                    SizedBox(height: 3.h),
                    _buildTransactionSummary(isDark),
                    SizedBox(height: 3.h),
                    _buildVerifyButton(isDark),
                  ],
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
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.gradientColors,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: widget.accentColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 1.5.h, 4.w, 2.5.h),
          child: Row(
            children: [
              _buildBackButton(),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Verify Withdrawal',
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

  Widget _buildOtpIcon(bool isDark) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: widget.accentColor.withValues(alpha: isDark ? 0.15 : 0.1),
        shape: BoxShape.circle,
      ),
      child: CustomIconWidget(
        iconName: 'lock',
        color: widget.accentColor,
        size: 48,
      ),
    );
  }

  Widget _buildOtpInput(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          width: 12.w,
          height: 14.w,
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _handleKeyEvent(event, index),
            child: TextFormField(
              controller: _otpControllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              obscureText: true,
              onChanged: (v) => _onOtpChanged(index, v),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1A1D23),
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: isDark ? const Color(0xFF161B22) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? const Color(0xFF30363D)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? const Color(0xFF30363D)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.accentColor, width: 2),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildResendSection(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Didn\'t receive the code? ',
          style: GoogleFonts.inter(
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white60 : const Color(0xFF64748B),
          ),
        ),
        if (_resendCountdown > 0)
          Text(
            'Resend in ${_resendCountdown}s',
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: widget.accentColor,
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
                decoration: TextDecoration.underline,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionSummary(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF30363D) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Transaction Summary',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 2.h),
          _buildSummaryRow(
            'Amount',
            'GH₵ ${widget.amount}',
            isDark,
            highlight: true,
          ),
          _buildSummaryRow('Account', widget.accountNo, isDark),
          _buildSummaryRow('Name', widget.accountName, isDark),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDark, {
    bool highlight = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : const Color(0xFF64748B),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: highlight ? 12.sp : 9.5.sp,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
              color: highlight
                  ? widget.accentColor
                  : (isDark ? Colors.white : const Color(0xFF1A1D23)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton(bool isDark) {
    return Container(
      width: double.infinity,
      height: 6.5.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: widget.gradientColors),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: widget.accentColor.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isVerifying ? null : _verifyOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isVerifying
            ? SizedBox(
                width: 6.w,
                height: 6.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomIconWidget(
                    iconName: 'verified',
                    color: Colors.white,
                    size: 22,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Verify & Continue',
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
// MERCHANT QR WITHDRAWAL RECEIPT SCREEN
// ════════════════════════════════════════════════════════════════════════════
