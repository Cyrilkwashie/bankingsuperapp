part of 'agency_mini_statement_screen.dart';

// ══════════════════════════════════════════════════════════════
// ── Mini Statement Result Screen ──
// ══════════════════════════════════════════════════════════════

class _MiniStatementResultScreen extends StatefulWidget {
  final String accountNo;
  final String accountName;
  final String accountBalance;
  final String accountType;
  final int txnCount;
  final Color accentColor;
  final List<Color> gradientColors;

  const _MiniStatementResultScreen({
    required this.accountNo,
    required this.accountName,
    required this.accountBalance,
    required this.accountType,
    required this.txnCount,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_MiniStatementResultScreen> createState() =>
      _MiniStatementResultScreenState();
}

class _MiniStatementResultScreenState
    extends State<_MiniStatementResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _pulse;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  late final String _referenceNo;
  late final DateTime _timestamp;

  // Mock transactions
  late final List<_MockTransaction> _transactions;

  @override
  void initState() {
    super.initState();

    _timestamp = DateTime.now();
    _referenceNo = _generateReference();
    _transactions = _generateMockTransactions(widget.txnCount);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String _generateReference() {
    final now = DateTime.now();
    return 'MS${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
  }

  String _formatTimestamp(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}, '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _maskAccountNo(String no) {
    if (no.length >= 7) {
      return '${no.substring(0, 3)}****${no.substring(no.length - 3)}';
    }
    return no;
  }

  List<_MockTransaction> _generateMockTransactions(int count) {
    final mockData = <_MockTransaction>[
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(hours: 2)),
        description: 'POS Purchase - Melcom',
        amount: -245.00,
        balance: 12205.00,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(hours: 8)),
        description: 'Salary Credit - Employer',
        amount: 3500.00,
        balance: 12450.00,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'ATM Withdrawal',
        amount: -500.00,
        balance: 8950.00,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        description: 'Mobile Money Transfer',
        amount: -150.00,
        balance: 9450.00,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Bank Transfer In',
        amount: 1200.00,
        balance: 9600.00,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
        description: 'Utility Payment - ECG',
        amount: -89.50,
        balance: 8400.00,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 3)),
        description: 'Cheque Deposit',
        amount: 2000.00,
        balance: 8489.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
        description: 'Standing Order - Rent',
        amount: -800.00,
        balance: 6489.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 4)),
        description: 'DSTV Subscription',
        amount: -65.00,
        balance: 7289.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 4, hours: 2)),
        description: 'Cash Deposit - Branch',
        amount: 500.00,
        balance: 7354.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 5)),
        description: 'Fuel Purchase - Shell',
        amount: -120.00,
        balance: 6854.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 5, hours: 4)),
        description: 'POS Purchase - Game',
        amount: -340.00,
        balance: 6974.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 6)),
        description: 'Transfer From Savings',
        amount: 1500.00,
        balance: 7314.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 6, hours: 6)),
        description: 'Internet Banking - Vodafone',
        amount: -55.00,
        balance: 5814.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 7)),
        description: 'Cash Withdrawal - ATM',
        amount: -200.00,
        balance: 5869.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 7, hours: 3)),
        description: 'Dividend Credit',
        amount: 750.00,
        balance: 6069.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 8)),
        description: 'POS Purchase - Shoprite',
        amount: -180.00,
        balance: 5319.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 8, hours: 5)),
        description: 'Standing Order - Insurance',
        amount: -250.00,
        balance: 5499.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 9)),
        description: 'Cash Deposit',
        amount: 300.00,
        balance: 5749.50,
      ),
      _MockTransaction(
        date: DateTime.now().subtract(const Duration(days: 10)),
        description: 'Transfer Out - John Doe',
        amount: -400.00,
        balance: 5449.50,
      ),
    ];
    return mockData.take(count).toList();
  }

  // ── Build ──────────────────────────────────────────────────

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
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 4.h),
                  child: Column(
                    children: [
                      // Success icon
                      ScaleTransition(
                        scale: _pulse,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF059669),
                                const Color(0xFF10B981),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF059669)
                                    .withValues(alpha: 0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Statement Generated',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Mini statement for the last ${widget.txnCount} transactions',
                        style: GoogleFonts.inter(
                          fontSize: 8.5.sp,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF6B7280),
                        ),
                      ),

                      SizedBox(height: 2.5.h),

                      // Reference & timestamp
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.5.w),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF161B22)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: widget.accentColor
                                .withValues(alpha: 0.15),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Reference',
                                  style: GoogleFonts.inter(
                                    fontSize: 8.sp,
                                    color: isDark
                                        ? Colors.white38
                                        : const Color(0xFF9CA3AF),
                                  ),
                                ),
                                Text(
                                  _referenceNo,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 8.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: widget.accentColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.8.h),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date & Time',
                                  style: GoogleFonts.inter(
                                    fontSize: 8.sp,
                                    color: isDark
                                        ? Colors.white38
                                        : const Color(0xFF9CA3AF),
                                  ),
                                ),
                                Text(
                                  _formatTimestamp(_timestamp),
                                  style: GoogleFonts.inter(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? Colors.white70
                                        : const Color(0xFF374151),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.8.h),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Account',
                                  style: GoogleFonts.inter(
                                    fontSize: 8.sp,
                                    color: isDark
                                        ? Colors.white38
                                        : const Color(0xFF9CA3AF),
                                  ),
                                ),
                                Text(
                                  '${widget.accountName} • ${_maskAccountNo(widget.accountNo)}',
                                  style: GoogleFonts.inter(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? Colors.white70
                                        : const Color(0xFF374151),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Available balance
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.5.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.accentColor
                                  .withValues(alpha: isDark ? 0.15 : 0.08),
                              const Color(0xFF10B981)
                                  .withValues(alpha: isDark ? 0.08 : 0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: widget.accentColor
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Available Balance',
                              style: GoogleFonts.inter(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white54
                                    : const Color(0xFF64748B),
                              ),
                            ),
                            Text(
                              widget.accountBalance,
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: widget.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Transaction list header
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Recent Transactions',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF374151),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),

                      // Transaction list
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF161B22)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Column(
                          children: _transactions
                              .asMap()
                              .entries
                              .map((entry) {
                            final i = entry.key;
                            final txn = entry.value;
                            final isLast =
                                i == _transactions.length - 1;
                            return _buildTransactionRow(
                              isDark: isDark,
                              txn: txn,
                              showDivider: !isLast,
                            );
                          }).toList(),
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Print / Share buttons row
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Printing mini statement…',
                                      style: GoogleFonts.inter(
                                          fontWeight:
                                              FontWeight.w500),
                                    ),
                                    behavior: SnackBarBehavior
                                        .floating,
                                    backgroundColor:
                                        widget.accentColor,
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                              10),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1.5.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.accentColor,
                                      widget.accentColor
                                          .withValues(
                                              alpha: 0.85),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.accentColor
                                          .withValues(
                                              alpha: 0.3),
                                      blurRadius: 10,
                                      offset:
                                          const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                        Icons.print_rounded,
                                        size: 18,
                                        color: Colors.white),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Print',
                                      style: GoogleFonts.inter(
                                        fontSize: 10.sp,
                                        fontWeight:
                                            FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Sharing mini statement…',
                                      style: GoogleFonts.inter(
                                          fontWeight:
                                              FontWeight.w500),
                                    ),
                                    behavior: SnackBarBehavior
                                        .floating,
                                    backgroundColor:
                                        widget.accentColor,
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                              10),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1.5.h),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF161B22)
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  border: Border.all(
                                    color: widget.accentColor
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.share_rounded,
                                      size: 18,
                                      color: widget.accentColor,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Share',
                                      style: GoogleFonts.inter(
                                        fontSize: 10.sp,
                                        fontWeight:
                                            FontWeight.w600,
                                        color:
                                            widget.accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 1.5.h),

                      // Done button
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).popUntil((route) =>
                              route.isFirst
                                  ? true
                                  : route.settings.name ==
                                      '/agency-banking-dashboard');
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF161B22)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white
                                      .withValues(alpha: 0.08)
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Back to Dashboard',
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

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow({
    required bool isDark,
    required _MockTransaction txn,
    required bool showDivider,
  }) {
    final isCredit = txn.amount > 0;
    final amountColor =
        isCredit ? const Color(0xFF059669) : const Color(0xFFDC2626);
    final amountPrefix = isCredit ? '+' : '';
    final dateStr = _formatShortDate(txn.date);

    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.3.h),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: amountColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    isCredit
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: amountColor,
                    size: 16,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txn.description,
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF111827),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      dateStr,
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        color: isDark
                            ? Colors.white38
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${amountPrefix}GH₵ ${txn.amount.abs().toStringAsFixed(2)}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: amountColor,
                    ),
                  ),
                  SizedBox(height: 0.2.h),
                  Text(
                    'Bal: GH₵ ${txn.balance.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 6.5.sp,
                      color: isDark
                          ? Colors.white38
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 0,
            thickness: 1,
            indent: 4.w,
            endIndent: 4.w,
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : const Color(0xFFF3F4F6),
          ),
      ],
    );
  }

  String _formatShortDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]}, '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
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
          padding:
              EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: const Center(
                  child: Icon(Icons.check_circle_rounded,
                      color: Color(0xFF34D399), size: 22),
                ),
              ),
              SizedBox(width: 3.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mini Statement',
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
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669)
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF059669)
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 12, color: Color(0xFF4ADE80)),
                    SizedBox(width: 1.w),
                    Text(
                      'Success',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4ADE80),
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

// ── Mock Transaction Model ───────────────────────────────────

class _MockTransaction {
  final DateTime date;
  final String description;
  final double amount;
  final double balance;

  const _MockTransaction({
    required this.date,
    required this.description,
    required this.amount,
    required this.balance,
  });
}
