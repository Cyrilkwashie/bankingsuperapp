part of 'agency_open_account_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Success – Account Opened ──
// ══════════════════════════════════════════════════════════════

class _OpenAccountSuccessScreen extends StatefulWidget {
  final String accountType;
  final String fullName;
  final String accountNumber;
  final String referenceNumber;
  final String phone;
  final Color accentColor;
  final List<Color> gradientColors;

  const _OpenAccountSuccessScreen({
    required this.accountType,
    required this.fullName,
    required this.accountNumber,
    required this.referenceNumber,
    required this.phone,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_OpenAccountSuccessScreen> createState() =>
      _OpenAccountSuccessScreenState();
}

class _OpenAccountSuccessScreenState extends State<_OpenAccountSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fade;
  late final DateTime _timestamp;

  @override
  void initState() {
    super.initState();
    _timestamp = DateTime.now();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String _formatTimestamp(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year} · '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
        body: FadeTransition(
          opacity: _fade,
          child: Column(
            children: [
              _OpenAccountUi.buildAgencyHeader(
                context: context,
                isDark: isDark,
                title: 'Account Opened',
                subtitle: 'Open Account · Complete',
                gradientColors: widget.gradientColors,
                showBack: false,
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _OpenAccountUi.success.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: _OpenAccountUi.success.withValues(alpha: 0.28),
                    ),
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    color: Color(0xFF34D399),
                    size: 19,
                  ),
                ),
                trailing: _OpenAccountUi.buildSuccessBadge(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 2.h),
                  child: Column(
                    children: [
                      _OpenAccountUi.buildSuccessIcon(isDark),
                      SizedBox(height: 1.8.h),
                      Text(
                        'Account Created Successfully',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF111827),
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${widget.accountType} account opened for ${widget.fullName}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 8.sp,
                          height: 1.4,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      _OpenAccountUi.buildReceiptCard(
                        isDark: isDark,
                        accentColor: widget.accentColor,
                        heroValue: widget.accountNumber,
                        heroLabel: 'New Account Number',
                        rows: [
                          _OpenAccountSummaryRow(
                            'Reference',
                            widget.referenceNumber,
                            mono: true,
                          ),
                          _OpenAccountSummaryRow(
                            'Account Holder',
                            widget.fullName,
                          ),
                          _OpenAccountSummaryRow(
                            'Account Type',
                            widget.accountType,
                            valueColor: widget.accentColor,
                          ),
                          _OpenAccountSummaryRow('Phone', widget.phone),
                          _OpenAccountSummaryRow(
                            'Date & Time',
                            _formatTimestamp(_timestamp),
                          ),
                          _OpenAccountSummaryRow(
                            'Status',
                            'Completed',
                            valueColor: _OpenAccountUi.success,
                          ),
                        ],
                      ),
                      SizedBox(height: 1.5.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.5.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: _OpenAccountUi.success
                              .withValues(alpha: isDark ? 0.08 : 0.06),
                          borderRadius:
                              BorderRadius.circular(_OpenAccountUi.fieldRadius),
                          border: Border.all(
                            color: _OpenAccountUi.success.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.sms_outlined,
                              color: _OpenAccountUi.success,
                              size: 15,
                            ),
                            SizedBox(width: 2.5.w),
                            Expanded(
                              child: Text(
                                'Customer will receive SMS confirmation at ${widget.phone}.',
                                style: GoogleFonts.inter(
                                  fontSize: 7.5.sp,
                                  height: 1.35,
                                  color: _OpenAccountUi.success,
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
              _OpenAccountUi.buildStickyActionBar(
                isDark: isDark,
                child: Column(
                  children: [
                    _OpenAccountUi.buildPrimaryButton(
                      isDark: isDark,
                      label: 'Make Initial Deposit',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AgencyCashDepositScreen(
                              prefilledAccountNumber: widget.accountNumber,
                              prefilledAccountName: widget.fullName,
                              prefilledAccountType: widget.accountType,
                              prefilledPhone: widget.phone,
                            ),
                          ),
                        );
                      },
                      accentColor: widget.accentColor,
                      icon: Icons.account_balance_wallet_rounded,
                      showArrow: false,
                    ),
                    SizedBox(height: 0.8.h),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Account details sent via SMS',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: _OpenAccountUi.success,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.6.h),
                        child: Text(
                          'Send Details via SMS',
                          style: GoogleFonts.inter(
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w600,
                            color: widget.accentColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.4.h),
                    GestureDetector(
                      onTap: () => Navigator.of(context).popUntil((route) =>
                          route.isFirst
                              ? true
                              : route.settings.name ==
                                  '/agency-banking-dashboard'),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.6.h),
                        child: Text(
                          'Back to Dashboard',
                          style: GoogleFonts.inter(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF6B7280),
                          ),
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
    );
  }
}
