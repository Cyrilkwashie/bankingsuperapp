import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../../core/app_export.dart';
import './widgets/merchant_filter_section_widget.dart';
import './widgets/merchant_transaction_card_widget.dart';

/// Merchant Transaction History Screen - Comprehensive transaction tracking for merchant operations
class MerchantTransactionHistoryScreen extends StatefulWidget {
  const MerchantTransactionHistoryScreen({super.key});

  @override
  State<MerchantTransactionHistoryScreen> createState() =>
      _MerchantTransactionHistoryScreenState();
}

class _MerchantTransactionHistoryScreenState
    extends State<MerchantTransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _sortBy = 'Date';
  DateTimeRange? _selectedDateRange;

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 'TXN-M001234567',
      'type': 'card_payment',
      'customer': 'John Mensah',
      'amount': 5000.00,
      'date': '2026-02-03 14:30',
      'status': 'success',
      'reference': 'REF-M-2026-02-03-001',
      'commission': 50.00,
      'paymentMethod': 'Visa Card',
      'settlementStatus': 'Settled',
      'notes': 'POS card payment',
    },
    {
      'id': 'TXN-M001234566',
      'type': 'qr_transaction',
      'customer': 'Ama Asante',
      'amount': 2500.00,
      'date': '2026-02-03 13:15',
      'status': 'success',
      'reference': 'REF-M-2026-02-03-002',
      'commission': 25.00,
      'paymentMethod': 'QR Code',
      'settlementStatus': 'Settled',
      'notes': 'QR payment scan',
    },
    {
      'id': 'TXN-M001234565',
      'type': 'cash_deposit',
      'customer': 'Kwame Boateng',
      'amount': 1500.00,
      'date': '2026-02-03 11:45',
      'status': 'pending',
      'reference': 'REF-M-2026-02-03-003',
      'commission': 15.00,
      'paymentMethod': 'Cash',
      'settlementStatus': 'Pending',
      'notes': 'Cash deposit to account',
    },
    {
      'id': 'TXN-M001234564',
      'type': 'refund',
      'customer': 'Abena Osei',
      'amount': 750.00,
      'date': '2026-02-03 10:20',
      'status': 'success',
      'reference': 'REF-M-2026-02-03-004',
      'commission': -7.50,
      'paymentMethod': 'Visa Card',
      'settlementStatus': 'Refunded',
      'notes': 'Customer refund request',
    },
    {
      'id': 'TXN-M001234563',
      'type': 'card_payment',
      'customer': 'Kofi Adjei',
      'amount': 3200.00,
      'date': '2026-02-02 16:50',
      'status': 'success',
      'reference': 'REF-M-2026-02-02-005',
      'commission': 32.00,
      'paymentMethod': 'Mastercard',
      'settlementStatus': 'Settled',
      'notes': 'Online card payment',
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

    if (_selectedDateRange != null) {
      filtered = filtered.where((txn) {
        final txnDate = DateTime.parse(txn['date']);
        return txnDate.isAfter(
              _selectedDateRange!.start.subtract(const Duration(days: 1)),
            ) &&
            txnDate.isBefore(
              _selectedDateRange!.end.add(const Duration(days: 1)),
            );
      }).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((txn) {
        return txn['id'].toLowerCase().contains(query) ||
            txn['customer'].toLowerCase().contains(query) ||
            txn['amount'].toString().contains(query) ||
            txn['paymentMethod'].toLowerCase().contains(query);
      }).toList();
    }

    if (_sortBy == 'Amount') {
      filtered.sort((a, b) => b['amount'].compareTo(a['amount']));
    }

    return filtered;
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF059669),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1A1D23),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  Future<void> _exportToPDF() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Merchant Transaction History',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Generated: ${DateTime.now().toString().substring(0, 16)}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['ID', 'Customer', 'Amount', 'Date', 'Status'],
                  data: _filteredTransactions.map((txn) {
                    return [
                      txn['id'],
                      txn['customer'],
                      'GH₵${txn['amount'].toStringAsFixed(2)}',
                      txn['date'],
                      txn['status'],
                    ];
                  }).toList(),
                ),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      _downloadFile(bytes, 'merchant_transactions.pdf');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF exported successfully'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Future<void> _exportToCSV() async {
    try {
      final csvData = StringBuffer();
      csvData.writeln(
        'ID,Customer,Amount,Date,Status,Commission,Payment Method,Settlement',
      );

      for (var txn in _filteredTransactions) {
        csvData.writeln(
          '${txn['id']},${txn['customer']},${txn['amount']},${txn['date']},${txn['status']},${txn['commission']},${txn['paymentMethod']},${txn['settlementStatus']}',
        );
      }

      final bytes = utf8.encode(csvData.toString());
      _downloadFile(bytes, 'merchant_transactions.csv');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CSV exported successfully'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _downloadFile(List<int> bytes, String filename) {
    if (kIsWeb) {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 2.h),
              _buildSearchBar(),
              SizedBox(height: 2.h),
              MerchantFilterSectionWidget(
                selectedFilter: _selectedFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
              SizedBox(height: 2.h),
              _buildDateRangeSelector(),
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
          hintText: 'Search by ID, customer, amount, or payment method',
          hintStyle: GoogleFonts.inter(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
          ),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Color(0xFF6B7280)),
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
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF059669), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _selectDateRange,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      size: 20,
                      color: Color(0xFF059669),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        _selectedDateRange == null
                            ? 'Select date range'
                            : '${_selectedDateRange!.start.toString().substring(0, 10)} - ${_selectedDateRange!.end.toString().substring(0, 10)}',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: _selectedDateRange == null
                              ? const Color(0xFF6B7280)
                              : const Color(0xFF1A1D23),
                          fontWeight: _selectedDateRange == null
                              ? FontWeight.w400
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (_selectedDateRange != null)
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 18,
                          color: Color(0xFF6B7280),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedDateRange = null;
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                  const Icon(Icons.sort, size: 20, color: Color(0xFF6B7280)),
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
          SizedBox(width: 2.w),
          _buildExportButton(Icons.picture_as_pdf, 'PDF', _exportToPDF),
          SizedBox(width: 2.w),
          _buildExportButton(Icons.table_chart, 'CSV', _exportToCSV),
        ],
      ),
    );
  }

  Widget _buildExportButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: const Color(0xFF059669),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white),
            SizedBox(width: 1.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        itemCount: _filteredTransactions.length,
        itemBuilder: (context, index) {
          return MerchantTransactionCardWidget(
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
            Icons.receipt_long,
            size: 80,
            color: const Color(0xFF6B7280).withValues(alpha: 0.3),
          ),
          SizedBox(height: 2.h),
          Text(
            'No transactions found',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your filters',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
