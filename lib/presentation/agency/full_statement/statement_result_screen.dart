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

  late final String _referenceNo;
  late final DateTime _timestamp;

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
    _timestamp = DateTime.now();
    _referenceNo = _generateReference();
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

  String _generateReference() {
    final now = DateTime.now();
    return 'FST/${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}/${now.millisecond.toString().padLeft(4, '0').substring(0, 4)}';
  }

  String _formatTimestamp(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}  $h:$m:$s $period';
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
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String _formatCurrency(double amount) {
    return 'GH₵ ${amount.toStringAsFixed(2)}';
  }

  String _maskAccountNo(String no) {
    if (no.length >= 7) {
      return '${no.substring(0, 3)} •••• ${no.substring(no.length - 3)}';
    }
    return no;
  }

  double get _totalDebits => _entries.fold(0.0, (sum, e) => sum + e.debit);
  double get _totalCredits => _entries.fold(0.0, (sum, e) => sum + e.credit);

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
            _AgencyFullStatementScreenState.buildFlowStepIndicator(4, isDark),
            if (_isLoading)
              Expanded(child: _buildLoadingState(isDark))
            else
              Expanded(child: _buildStatementContent(isDark)),
            if (!_isLoading) _buildStickyDone(isDark),
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
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: widget.accentColor,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Fetching Statement...',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 0.6.h),
          Text(
            'Please wait while we retrieve the account statement',
            style: GoogleFonts.inter(
              fontSize: 7.5.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatementContent(bool isDark) {
    final isElectronic = widget.statementType == 'electronic';

    if (!isElectronic) {
      return _buildOrdinarySuccessContent(isDark);
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSuccessHeader(isDark, isElectronic: true),
          SizedBox(height: 1.5.h),
          _buildReceiptCard(isDark),
          SizedBox(height: 1.5.h),
          _buildAccountSummaryCard(isDark),
          SizedBox(height: 1.5.h),
          _buildSummaryTotals(isDark),
          SizedBox(height: 1.5.h),
          if (_entries.isEmpty)
            _buildEmptyEntries(isDark)
          else
            _buildEntriesList(isDark),
        ],
      ),
    );
  }

  Widget _buildOrdinarySuccessContent(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 2.h),
      child: Column(
        children: [
          _buildSuccessHeader(isDark, isElectronic: false),
          SizedBox(height: 1.5.h),
          _buildReceiptCard(isDark),
          if (widget.pickupBranch != null) ...[
            SizedBox(height: 1.2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.9.h),
              decoration: BoxDecoration(
                color: widget.accentColor.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: 0.12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: widget.accentColor,
                    size: 14,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Pickup: ${widget.pickupBranch}',
                      style: GoogleFonts.inter(
                        fontSize: 7.5.sp,
                        fontWeight: FontWeight.w600,
                        color: widget.accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 1.2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.9.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  color: Color(0xFFF59E0B),
                  size: 14,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Processing: 3–5 working days',
                  style: GoogleFonts.inter(
                    fontSize: 7.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader(bool isDark, {required bool isElectronic}) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF059669).withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF059669).withValues(alpha: 0.25),
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              color: Color(0xFF059669),
              size: 28,
            ),
          ),
        ),
        SizedBox(height: 1.2.h),
        Text(
          isElectronic ? 'Statement Ready' : 'Request Submitted',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          isElectronic
              ? 'Electronic statement for ${widget.accountName}'
              : 'Ordinary statement for ${widget.accountName} has been submitted successfully.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 8.sp,
            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.accentColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          _receiptRow(
            isDark,
            'Reference',
            _referenceNo,
            mono: true,
            accent: true,
          ),
          _divider(isDark),
          _receiptRow(isDark, 'Timestamp', _formatTimestamp(_timestamp)),
          _divider(isDark),
          _receiptRow(isDark, 'Account Holder', widget.accountName),
          _divider(isDark),
          _receiptRow(
            isDark,
            'Account',
            _maskAccountNo(widget.accountNo),
            mono: true,
          ),
          _divider(isDark),
          _receiptRow(
            isDark,
            'Period',
            '${_formatDate(widget.startDate)} – ${_formatDate(widget.endDate)}',
          ),
          _divider(isDark),
          _receiptRow(
            isDark,
            'Fee',
            _formatCurrency(widget.charges),
            accent: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSummaryCard(bool isDark) {
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
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: widget.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                Icons.email_outlined,
                color: widget.accentColor,
                size: 18,
              ),
            ),
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.accountName,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 0.15.h),
                Text(
                  '${_formatDate(widget.startDate)} → ${_formatDate(widget.endDate)}',
                  style: GoogleFonts.inter(
                    fontSize: 7.sp,
                    color: isDark ? Colors.white54 : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.25.h),
            decoration: BoxDecoration(
              color: widget.accentColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${_entries.length} entries',
              style: GoogleFonts.inter(
                fontSize: 6.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
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
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161B22) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_downward_rounded,
                      color: Color(0xFF10B981),
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Total Credits',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.4.h),
                Text(
                  _formatCurrency(_totalCredits),
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 2.5.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161B22) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFEF4444).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward_rounded,
                      color: Color(0xFFEF4444),
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Total Debits',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.4.h),
                Text(
                  _formatCurrency(_totalDebits),
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
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
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 40,
            color: isDark ? Colors.white24 : const Color(0xFFD1D5DB),
          ),
          SizedBox(height: 1.2.h),
          Text(
            'No Transactions Found',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 0.4.h),
          Text(
            'No transactions within the selected date range',
            style: GoogleFonts.inter(
              fontSize: 7.5.sp,
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
        borderRadius: BorderRadius.circular(14),
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
            padding: EdgeInsets.fromLTRB(3.5.w, 3.w, 3.5.w, 2.w),
            child: Text(
              'History',
              style: GoogleFonts.inter(
                fontSize: 9.sp,
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
          padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.2.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: amountColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
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
              SizedBox(width: 2.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.description,
                      style: GoogleFonts.inter(
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1A1D23),
                      ),
                    ),
                    SizedBox(height: 0.25.h),
                    Row(
                      children: [
                        Text(
                          _formatDate(entry.date),
                          style: GoogleFonts.inter(
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? Colors.white38
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                        SizedBox(width: 1.5.w),
                        Text(
                          '• ${entry.reference}',
                          style: GoogleFonts.inter(
                            fontSize: 6.5.sp,
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
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w700,
                      color: amountColor,
                    ),
                  ),
                  SizedBox(height: 0.25.h),
                  Text(
                    'Bal: ${_formatCurrency(entry.balance)}',
                    style: GoogleFonts.inter(
                      fontSize: 6.5.sp,
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
            indent: 3.5.w,
            endIndent: 3.5.w,
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFF3F4F6),
          ),
      ],
    );
  }

  Widget _receiptRow(
    bool isDark,
    String label,
    String value, {
    bool mono = false,
    bool accent = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.7.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28.w,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: mono
                  ? GoogleFonts.jetBrainsMono(
                      fontSize: 7.5.sp,
                      fontWeight: FontWeight.w600,
                      color: accent
                          ? widget.accentColor
                          : (isDark ? Colors.white : const Color(0xFF111827)),
                    )
                  : GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      color: accent
                          ? widget.accentColor
                          : (isDark ? Colors.white : const Color(0xFF111827)),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) => Divider(
        height: 0,
        thickness: 1,
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF3F4F6),
      );

  Widget _buildStickyDone(bool isDark) {
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
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.25.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.accentColor,
                      widget.accentColor.withValues(alpha: 0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Done',
                    style: GoogleFonts.inter(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 0.8.h),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Text(
                'New Request',
                style: GoogleFonts.inter(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w500,
                  color: widget.accentColor,
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
              : widget.gradientColors,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.8.h),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF34D399),
                    size: 22,
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
                ),
                child: const Center(
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.statementType == 'electronic'
                          ? 'Account Statement'
                          : 'Request Complete',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 0.2.h),
                    Text(
                      'Full Statement · Step 4 of 4',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF059669).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_rounded,
                      size: 12,
                      color: Color(0xFF34D399),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Success',
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF34D399),
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
