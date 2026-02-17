part of 'agency_full_statement_screen.dart';

class _StatementResultScreen extends StatefulWidget {
  final String accountNo;
  final String accountName;
  final String statementType;
  final DateTime startDate;
  final DateTime endDate;
  final String? pickupBranch;
  final double charges;
  final Color accentColor;
  final List<Color> gradientColors;

  const _StatementResultScreen({
    required this.accountNo,
    required this.accountName,
    required this.statementType,
    required this.startDate,
    required this.endDate,
    required this.pickupBranch,
    required this.charges,
    required this.accentColor,
    required this.gradientColors,
  });

  @override
  State<_StatementResultScreen> createState() => _StatementResultScreenState();
}

class _StatementResultScreenState extends State<_StatementResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  bool _isLoading = true;
  List<_StatementEntry> _entries = [];

  // Mock statement data
  static final _mockStatementData = [
    _StatementEntry(
      date: DateTime(2026, 1, 3),
      description: 'Salary Credit - Jan 2026',
      reference: 'SAL/2026/001',
      debit: 0,
      credit: 5200.00,
      balance: 12450.00,
    ),
    _StatementEntry(
      date: DateTime(2026, 1, 5),
      description: 'ATM Withdrawal - Accra Mall',
      reference: 'ATM/2026/0012',
      debit: 500.00,
      credit: 0,
      balance: 11950.00,
    ),
    _StatementEntry(
      date: DateTime(2026, 1, 8),
      description: 'Mobile Transfer to Ama Mensah',
      reference: 'MOB/2026/0034',
      debit: 1200.00,
      credit: 0,
      balance: 10750.00,
    ),
    _StatementEntry(
      date: DateTime(2026, 1, 10),
      description: 'POS Purchase - Melcom',
      reference: 'POS/2026/0089',
      debit: 350.00,
      credit: 0,
      balance: 10400.00,
    ),
    _StatementEntry(
      date: DateTime(2026, 1, 12),
      description: 'Standing Order - Rent',
      reference: 'STO/2026/0005',
      debit: 2500.00,
      credit: 0,
      balance: 7900.00,
    ),
    _StatementEntry(
      date: DateTime(2026, 1, 15),
      description: 'Interest Credit',
      reference: 'INT/2026/001',
      debit: 0,
      credit: 45.50,
      balance: 7945.50,
    ),
    _StatementEntry(
      date: DateTime(2026, 1, 18),
      description: 'Cash Deposit - Agency',
      reference: 'AGD/2026/0112',
      debit: 0,
      credit: 3000.00,
      balance: 10945.50,
    ),
    _StatementEntry(
      date: DateTime(2026, 1, 20),
      description: 'Bill Payment - ECG',
      reference: 'BPY/2026/0045',
      debit: 280.00,
      credit: 0,
      balance: 10665.50,
    ),
    _StatementEntry(
      date: DateTime(2026, 1, 22),
      description: 'Transfer from Kofi Adjei',
      reference: 'TRF/2026/0067',
      debit: 0,
      credit: 800.00,
      balance: 11465.50,
    ),
    _StatementEntry(
      date: DateTime(2026, 1, 25),
      description: 'Mobile Money Withdrawal',
      reference: 'MMW/2026/0023',
      debit: 600.00,
      credit: 0,
      balance: 10865.50,
    ),
    _StatementEntry(
      date: DateTime(2026, 1, 28),
      description: 'E-Levy Charge',
      reference: 'CHG/2026/0011',
      debit: 15.50,
      credit: 0,
      balance: 10850.00,
    ),
    _StatementEntry(
      date: DateTime(2026, 2, 1),
      description: 'Salary Credit - Feb 2026',
      reference: 'SAL/2026/002',
      debit: 0,
      credit: 5200.00,
      balance: 16050.00,
    ),
    _StatementEntry(
      date: DateTime(2026, 2, 3),
      description: 'Cash Withdrawal - Agency',
      reference: 'AGW/2026/0034',
      debit: 1500.00,
      credit: 0,
      balance: 14550.00,
    ),
    _StatementEntry(
      date: DateTime(2026, 2, 5),
      description: 'Insurance Premium',
      reference: 'INS/2026/0003',
      debit: 450.00,
      credit: 0,
      balance: 14100.00,
    ),
    _StatementEntry(
      date: DateTime(2026, 2, 8),
      description: 'School Fees Payment',
      reference: 'SCH/2026/0012',
      debit: 2800.00,
      credit: 0,
      balance: 11300.00,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _fetchStatement();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetchStatement() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _entries = _mockStatementData
            .where(
              (e) =>
                  !e.date.isBefore(widget.startDate) &&
                  !e.date.isAfter(widget.endDate),
            )
            .toList();
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String _formatCurrency(double amount) {
    return 'GH₵ ${amount.toStringAsFixed(2)}';
  }

  double get _totalDebits => _entries.fold(0.0, (sum, e) => sum + e.debit);
  double get _totalCredits => _entries.fold(0.0, (sum, e) => sum + e.credit);

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
            if (_isLoading)
              Expanded(child: _buildLoadingState(isDark))
            else
              Expanded(child: _buildStatementContent(isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: widget.accentColor,
            ),
          ),
          SizedBox(height: 2.5.h),
          Text(
            'Fetching Statement...',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 0.8.h),
          Text(
            'Please wait while we retrieve the account statement',
            style: GoogleFonts.inter(
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatementContent(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account summary card
          _buildAccountSummaryCard(isDark),
          SizedBox(height: 2.h),

          // Summary totals
          _buildSummaryTotals(isDark),
          SizedBox(height: 2.h),

          // Statement entries
          if (_entries.isEmpty)
            _buildEmptyEntries(isDark)
          else
            _buildEntriesList(isDark),

          SizedBox(height: 3.h),

          // Done button
          _buildDoneButton(isDark),
          SizedBox(height: 1.2.h),
          _buildNewRequestButton(isDark),
        ],
      ),
    );
  }

  Widget _buildAccountSummaryCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : [
                  widget.accentColor.withValues(alpha: 0.06),
                  widget.accentColor.withValues(alpha: 0.02),
                ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: widget.accentColor.withValues(alpha: isDark ? 0.15 : 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    widget.statementType == 'electronic'
                        ? Icons.email_rounded
                        : Icons.description_rounded,
                    color: widget.accentColor,
                    size: 22,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.accountName,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1A1D23),
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'A/C: ${widget.accountNo}',
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: widget.accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_formatDate(widget.startDate)}  →  ${_formatDate(widget.endDate)}',
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: widget.accentColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.3.h,
                  ),
                  decoration: BoxDecoration(
                    color: widget.accentColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_entries.length} entries',
                    style: GoogleFonts.inter(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTotals(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(3.5.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161B22) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_downward_rounded,
                      color: const Color(0xFF10B981),
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Total Credits',
                      style: GoogleFonts.inter(
                        fontSize: 7.5.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatCurrency(_totalCredits),
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(3.5.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161B22) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFEF4444).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_upward_rounded,
                      color: const Color(0xFFEF4444),
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Total Debits',
                      style: GoogleFonts.inter(
                        fontSize: 7.5.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatCurrency(_totalDebits),
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyEntries(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5.h),
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
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 48,
            color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
          ),
          SizedBox(height: 1.5.h),
          Text(
            'No Transactions Found',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'No transactions within the selected date range',
            style: GoogleFonts.inter(
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList(bool isDark) {
    return Container(
      width: double.infinity,
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
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 3.w, 4.w, 2.w),
            child: Text(
              'Transaction History',
              style: GoogleFonts.inter(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
          ),
          ..._entries.asMap().entries.map((entry) {
            final i = entry.key;
            final e = entry.value;
            final isLast = i == _entries.length - 1;
            return _buildEntryItem(e, isDark, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildEntryItem(_StatementEntry entry, bool isDark, bool isLast) {
    final isCredit = entry.credit > 0;
    final amountColor = isCredit
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);
    final amount = isCredit ? entry.credit : entry.debit;
    final sign = isCredit ? '+' : '-';

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: amountColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    isCredit
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: amountColor,
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
                      entry.description,
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1A1D23),
                      ),
                    ),
                    SizedBox(height: 0.3.h),
                    Row(
                      children: [
                        Text(
                          _formatDate(entry.date),
                          style: GoogleFonts.inter(
                            fontSize: 7.5.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? Colors.white38
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '• ${entry.reference}',
                          style: GoogleFonts.inter(
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? Colors.white24
                                : const Color(0xFFD1D5DB),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$sign ${_formatCurrency(amount)}',
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: amountColor,
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    'Bal: ${_formatCurrency(entry.balance)}',
                    style: GoogleFonts.inter(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 4.w,
            endIndent: 4.w,
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFF3F4F6),
          ),
      ],
    );
  }

  Widget _buildDoneButton(bool isDark) {
    return GestureDetector(
      onTap: () {
        // Pop back to the main form (pop OTP replacement + this)
        Navigator.of(context).pop(); // pop result screen
        Navigator.of(context).pop(); // pop back to form
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.accentColor,
              widget.accentColor.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Done',
            style: GoogleFonts.inter(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewRequestButton(bool isDark) {
    return GestureDetector(
      onTap: () {
        // Pop back to the form screen only
        Navigator.of(context).pop();
      },
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
            'New Request',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: widget.accentColor,
            ),
          ),
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
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
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
                      'Account Statement',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Full Statement Request',
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
                      Icons.receipt_long_rounded,
                      size: 12,
                      color: Colors.white70,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${_entries.length}',
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

// ── Statement Entry Model ──
class _StatementEntry {
  final DateTime date;
  final String description;
  final String reference;
  final double debit;
  final double credit;
  final double balance;

  const _StatementEntry({
    required this.date,
    required this.description,
    required this.reference,
    required this.debit,
    required this.credit,
    required this.balance,
  });
}
