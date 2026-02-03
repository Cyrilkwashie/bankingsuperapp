import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/transaction_card_widget.dart';
import './widgets/filter_section_widget.dart';

/// Transaction History Screen - Comprehensive transaction tracking and analysis
class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _sortBy = 'Date';

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'TXN001234567',
      'type': 'deposit',
      'merchant': 'John Mensah',
      'amount': 5000.00,
      'date': '2026-02-03 14:30',
      'status': 'success',
      'reference': 'REF-2026-02-03-001',
      'fee': 10.00,
      'notes': 'Cash deposit for savings account',
    },
    {
      'id': 'TXN001234566',
      'type': 'withdrawal',
      'merchant': 'Ama Asante',
      'amount': 2500.00,
      'date': '2026-02-03 13:15',
      'status': 'success',
      'reference': 'REF-2026-02-03-002',
      'fee': 5.00,
      'notes': 'Cash withdrawal',
    },
    {
      'id': 'TXN001234565',
      'type': 'transfer',
      'merchant': 'Kwame Boateng',
      'amount': 1500.00,
      'date': '2026-02-03 11:45',
      'status': 'pending',
      'reference': 'REF-2026-02-03-003',
      'fee': 8.00,
      'notes': 'Same bank transfer',
    },
    {
      'id': 'TXN001234564',
      'type': 'payment',
      'merchant': 'Abena Osei',
      'amount': 750.00,
      'date': '2026-02-03 10:20',
      'status': 'success',
      'reference': 'REF-2026-02-03-004',
      'fee': 3.00,
      'notes': 'Bill payment',
    },
    {
      'id': 'TXN001234563',
      'type': 'deposit',
      'merchant': 'Kofi Adjei',
      'amount': 3200.00,
      'date': '2026-02-02 16:50',
      'status': 'success',
      'reference': 'REF-2026-02-02-005',
      'fee': 10.00,
      'notes': 'QR deposit',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTransactions {
    var filtered = _transactions;

    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((txn) => txn['type'] == _selectedFilter.toLowerCase())
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((txn) {
        return txn['id'].toLowerCase().contains(query) ||
            txn['merchant'].toLowerCase().contains(query) ||
            txn['amount'].toString().contains(query);
      }).toList();
    }

    if (_sortBy == 'Amount') {
      filtered.sort((a, b) => b['amount'].compareTo(a['amount']));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 2.h),
              _buildSearchBar(),
              SizedBox(height: 2.h),
              FilterSectionWidget(
                selectedFilter: _selectedFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
              SizedBox(height: 2.h),
              _buildSortAndExport(),
              SizedBox(height: 2.h),
              Expanded(
                child: _filteredTransactions.isEmpty
                    ? _buildEmptyState()
                    : _buildTransactionList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        children: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: const Color(0xFF1A1D23),
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'Transaction History',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1D23),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search by ID, merchant, or amount',
          hintStyle: GoogleFonts.inter(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
          ),
          prefixIcon: Icon(Icons.search, color: const Color(0xFF6B7280)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: const Color(0xFF6B7280)),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: const Color(0xFF1B365D), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildSortAndExport() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Icon(Icons.sort, size: 20, color: const Color(0xFF6B7280)),
                  SizedBox(width: 2.w),
                  Text(
                    'Sort by:',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  DropdownButton<String>(
                    value: _sortBy,
                    underline: const SizedBox(),
                    items: ['Date', 'Amount'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1D23),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 3.w),
          ElevatedButton.icon(
            onPressed: _exportTransactions,
            icon: Icon(Icons.download, size: 18),
            label: Text(
              'Export',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B365D),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        itemCount: _filteredTransactions.length,
        itemBuilder: (context, index) {
          return TransactionCardWidget(
            transaction: _filteredTransactions[index],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: const Color(0xFF6B7280).withValues(alpha: 0.3),
          ),
          SizedBox(height: 2.h),
          Text(
            'No Transactions Found',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1D23),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your filters or search',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  void _exportTransactions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Export Transactions',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1D23),
              ),
            ),
            SizedBox(height: 3.h),
            _buildExportOption('PDF', Icons.picture_as_pdf),
            SizedBox(height: 2.h),
            _buildExportOption('CSV', Icons.table_chart),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption(String format, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exporting as $format...'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFBFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1B365D), size: 24),
            SizedBox(width: 3.w),
            Text(
              'Export as $format',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1D23),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: const Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }
}
