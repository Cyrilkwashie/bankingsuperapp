import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/banking_bottom_navigation.dart';

/// Agency Locations Screen - Shows branches and ATM locations
class AgencyLocationsScreen extends StatefulWidget {
  const AgencyLocationsScreen({super.key});

  @override
  State<AgencyLocationsScreen> createState() => _AgencyLocationsScreenState();
}

class _AgencyLocationsScreenState extends State<AgencyLocationsScreen>
    with SingleTickerProviderStateMixin {
  final int _currentIndex = 2; // Locations tab is selected
  late TabController _tabController;
  String _selectedFilter = 'All';

  // Agency brand color - Teal
  static const Color _brandColor = Color(0xFF2E8B8B);

  final List<Map<String, dynamic>> _branches = [
    {
      'name': 'Main Branch - Accra Central',
      'address': '25 Independence Avenue, Accra',
      'phone': '+233 30 123 4567',
      'hours': 'Mon-Fri: 8:00 AM - 5:00 PM',
      'services': ['Cash Deposit', 'Withdrawal', 'Account Opening', 'Loans'],
      'distance': '0.5 km',
      'isOpen': true,
      'type': 'branch',
    },
    {
      'name': 'Osu Branch',
      'address': '15 Oxford Street, Osu, Accra',
      'phone': '+233 30 234 5678',
      'hours': 'Mon-Fri: 8:30 AM - 4:30 PM',
      'services': ['Cash Deposit', 'Withdrawal', 'Money Transfer'],
      'distance': '1.2 km',
      'isOpen': true,
      'type': 'branch',
    },
    {
      'name': 'East Legon Branch',
      'address': '45 Boundary Road, East Legon',
      'phone': '+233 30 345 6789',
      'hours': 'Mon-Fri: 8:00 AM - 5:00 PM',
      'services': ['Cash Deposit', 'Withdrawal', 'Account Opening', 'Forex'],
      'distance': '3.5 km',
      'isOpen': true,
      'type': 'branch',
    },
    {
      'name': 'Tema Branch',
      'address': 'Community 1, Tema',
      'phone': '+233 30 456 7890',
      'hours': 'Mon-Fri: 8:00 AM - 4:00 PM',
      'services': ['Cash Deposit', 'Withdrawal', 'Bill Payment'],
      'distance': '8.2 km',
      'isOpen': false,
      'type': 'branch',
    },
    {
      'name': 'Kumasi Main Branch',
      'address': 'Adum, Kumasi',
      'phone': '+233 32 123 4567',
      'hours': 'Mon-Fri: 8:00 AM - 5:00 PM',
      'services': ['Cash Deposit', 'Withdrawal', 'Account Opening', 'Loans'],
      'distance': '250 km',
      'isOpen': true,
      'type': 'branch',
    },
  ];

  final List<Map<String, dynamic>> _atms = [
    {
      'name': 'ATM - Accra Mall',
      'address': 'Accra Mall, Spintex Road',
      'hours': '24/7',
      'services': ['Cash Withdrawal', 'Balance Inquiry', 'Mini Statement'],
      'distance': '2.1 km',
      'isOpen': true,
      'type': 'atm',
      'status': 'Online',
    },
    {
      'name': 'ATM - Airport City',
      'address': 'Airport City, Accra',
      'hours': '24/7',
      'services': ['Cash Withdrawal', 'Balance Inquiry', 'Fund Transfer'],
      'distance': '4.5 km',
      'isOpen': true,
      'type': 'atm',
      'status': 'Online',
    },
    {
      'name': 'ATM - West Hills Mall',
      'address': 'West Hills Mall, Weija',
      'hours': '24/7',
      'services': ['Cash Withdrawal', 'Balance Inquiry'],
      'distance': '12.3 km',
      'isOpen': true,
      'type': 'atm',
      'status': 'Online',
    },
    {
      'name': 'ATM - Makola Market',
      'address': 'Makola Market, Accra Central',
      'hours': '6:00 AM - 10:00 PM',
      'services': ['Cash Withdrawal', 'Balance Inquiry'],
      'distance': '0.8 km',
      'isOpen': false,
      'type': 'atm',
      'status': 'Maintenance',
    },
    {
      'name': 'ATM - University of Ghana',
      'address': 'Legon Campus, Accra',
      'hours': '24/7',
      'services': ['Cash Withdrawal', 'Balance Inquiry', 'Mini Statement'],
      'distance': '6.7 km',
      'isOpen': true,
      'type': 'atm',
      'status': 'Online',
    },
    {
      'name': 'ATM - Achimota Retail Centre',
      'address': 'Achimota, Accra',
      'hours': '24/7',
      'services': ['Cash Withdrawal', 'Balance Inquiry'],
      'distance': '5.2 km',
      'isOpen': true,
      'type': 'atm',
      'status': 'Low Cash',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavigationTap(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0: // Dashboard
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.agencyBankingDashboard);
        break;
      case 1: // Transactions
        Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutes.agencyTransactions);
        break;
      case 2: // Locations (current)
        // Already here
        break;
      case 3: // Settings
        Navigator.of(context).pushReplacementNamed(AppRoutes.agencySettings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0F1419)
            : const Color(0xFFFAFBFC),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF1E2328) : Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Branches & ATMs',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A1D23),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: isDark ? Colors.white70 : const Color(0xFF6B7280),
              ),
              onPressed: () => _showSearchDialog(context),
            ),
            IconButton(
              icon: Icon(
                Icons.map_outlined,
                color: isDark ? Colors.white70 : const Color(0xFF6B7280),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Map view coming soon!')),
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: _brandColor,
            unselectedLabelColor: isDark
                ? Colors.white54
                : const Color(0xFF6B7280),
            indicatorColor: _brandColor,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(
                icon: Icon(Icons.account_balance, size: 20),
                text: 'Branches (${_branches.length})',
              ),
              Tab(
                icon: Icon(Icons.atm, size: 20),
                text: 'ATMs (${_atms.length})',
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // Filter chips
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', isDark),
                    SizedBox(width: 2.w),
                    _buildFilterChip('Open Now', isDark),
                    SizedBox(width: 2.w),
                    _buildFilterChip('Nearby', isDark),
                    SizedBox(width: 2.w),
                    _buildFilterChip('24/7', isDark),
                  ],
                ),
              ),
            ),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildBranchList(isDark), _buildATMList(isDark)],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BankingBottomNavigation(
          currentIndex: _currentIndex,
          onTap: _onNavigationTap,
          items: BankingNavigationItems.agencyItems,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isDark) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? _brandColor
              : (isDark ? const Color(0xFF1E2328) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? _brandColor
                : (isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB)),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 8.sp,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : const Color(0xFF6B7280)),
          ),
        ),
      ),
    );
  }

  Widget _buildBranchList(bool isDark) {
    final filteredBranches = _getFilteredLocations(_branches);

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        itemCount: filteredBranches.length,
        itemBuilder: (context, index) {
          return _buildBranchCard(filteredBranches[index], isDark);
        },
      ),
    );
  }

  Widget _buildATMList(bool isDark) {
    final filteredATMs = _getFilteredLocations(_atms);

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        itemCount: filteredATMs.length,
        itemBuilder: (context, index) {
          return _buildATMCard(filteredATMs[index], isDark);
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredLocations(
    List<Map<String, dynamic>> locations,
  ) {
    switch (_selectedFilter) {
      case 'Open Now':
        return locations.where((loc) => loc['isOpen'] == true).toList();
      case 'Nearby':
        return locations.where((loc) {
          final distance =
              double.tryParse(
                loc['distance'].toString().replaceAll(' km', ''),
              ) ??
              0;
          return distance < 5;
        }).toList();
      case '24/7':
        return locations.where((loc) => loc['hours'] == '24/7').toList();
      default:
        return locations;
    }
  }

  Widget _buildBranchCard(Map<String, dynamic> branch, bool isDark) {
    final isOpen = branch['isOpen'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2328) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLocationDetails(branch, isDark),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: _brandColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.account_balance,
                        color: _brandColor,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            branch['name'],
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A1D23),
                            ),
                          ),
                          SizedBox(height: 0.3.h),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 12,
                                color: isDark
                                    ? Colors.white54
                                    : const Color(0xFF6B7280),
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Text(
                                  branch['address'],
                                  style: GoogleFonts.inter(
                                    fontSize: 8.sp,
                                    color: isDark
                                        ? Colors.white54
                                        : const Color(0xFF6B7280),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.3.h,
                          ),
                          decoration: BoxDecoration(
                            color: isOpen
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isOpen ? 'Open' : 'Closed',
                            style: GoogleFonts.inter(
                              fontSize: 7.sp,
                              fontWeight: FontWeight.w600,
                              color: isOpen ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          branch['distance'],
                          style: GoogleFonts.inter(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: _brandColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      branch['hours'],
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.phone, size: 12, color: _brandColor),
                    SizedBox(width: 1.w),
                    Text(
                      branch['phone'],
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color: _brandColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 1.5.w,
                  runSpacing: 0.5.h,
                  children: (branch['services'] as List<dynamic>).take(3).map((
                    service,
                  ) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.3.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        service,
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF4B5563),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildATMCard(Map<String, dynamic> atm, bool isDark) {
    final status = atm['status'] as String;

    Color statusColor;
    switch (status) {
      case 'Online':
        statusColor = Colors.green;
        break;
      case 'Low Cash':
        statusColor = Colors.orange;
        break;
      case 'Maintenance':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2328) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLocationDetails(atm, isDark),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: _brandColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.atm, color: _brandColor, size: 20),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            atm['name'],
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A1D23),
                            ),
                          ),
                          SizedBox(height: 0.3.h),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 12,
                                color: isDark
                                    ? Colors.white54
                                    : const Color(0xFF6B7280),
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Text(
                                  atm['address'],
                                  style: GoogleFonts.inter(
                                    fontSize: 8.sp,
                                    color: isDark
                                        ? Colors.white54
                                        : const Color(0xFF6B7280),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.3.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                status,
                                style: GoogleFonts.inter(
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          atm['distance'],
                          style: GoogleFonts.inter(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                            color: _brandColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      atm['hours'],
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    if (atm['hours'] == '24/7') ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w,
                          vertical: 0.2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '24/7',
                          style: GoogleFonts.inter(
                            fontSize: 6.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 1.5.w,
                  runSpacing: 0.5.h,
                  children: (atm['services'] as List<dynamic>).map((service) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.3.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        service,
                        style: GoogleFonts.inter(
                          fontSize: 7.sp,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF4B5563),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLocationDetails(Map<String, dynamic> location, bool isDark) {
    final isBranch = location['type'] == 'branch';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2328) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: _brandColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isBranch ? Icons.account_balance : Icons.atm,
                            color: _brandColor,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location['name'],
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1A1D23),
                                ),
                              ),
                              Text(
                                location['address'],
                                style: GoogleFonts.inter(
                                  fontSize: 9.sp,
                                  color: isDark
                                      ? Colors.white54
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    // Details
                    _buildDetailRow(
                      Icons.access_time,
                      'Hours',
                      location['hours'],
                      isDark,
                    ),
                    SizedBox(height: 1.5.h),
                    if (isBranch) ...[
                      _buildDetailRow(
                        Icons.phone,
                        'Phone',
                        location['phone'],
                        isDark,
                      ),
                      SizedBox(height: 1.5.h),
                    ],
                    _buildDetailRow(
                      Icons.directions,
                      'Distance',
                      location['distance'],
                      isDark,
                    ),
                    SizedBox(height: 2.h),
                    // Services
                    Text(
                      'Available Services',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1A1D23),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: (location['services'] as List<dynamic>).map((
                        service,
                      ) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 0.8.h,
                          ),
                          decoration: BoxDecoration(
                            color: _brandColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _brandColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            service,
                            style: GoogleFonts.inter(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w500,
                              color: _brandColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Spacer(),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Opening directions...'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.directions, size: 18),
                            label: Text(
                              'Get Directions',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _brandColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        if (isBranch) ...[
                          SizedBox(width: 3.w),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Calling ${location['phone']}...',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.phone, size: 18),
                              label: Text(
                                'Call Branch',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _brandColor,
                                side: BorderSide(color: _brandColor),
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
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

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _brandColor),
        SizedBox(width: 2.w),
        Text(
          '$label: ',
          style: GoogleFonts.inter(
            fontSize: 9.sp,
            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1A1D23),
          ),
        ),
      ],
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E2328) : Colors.white,
          title: Text(
            'Search Locations',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A1D23),
            ),
          ),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter location name or area...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: isDark ? Colors.white54 : const Color(0xFF6B7280),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _brandColor),
              ),
            ),
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1A1D23),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white54 : const Color(0xFF6B7280),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Search feature coming soon!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandColor,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Search',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
