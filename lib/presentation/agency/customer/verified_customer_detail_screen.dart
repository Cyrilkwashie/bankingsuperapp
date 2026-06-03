import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/agency_customer_lookup.dart';
import '../../../models/verified_customer.dart';
import 'customer_document_viewer_screen.dart';

class VerifiedCustomerDetailScreen extends StatelessWidget {
  final VerifiedCustomer customer;
  final Color accentColor;

  const VerifiedCustomerDetailScreen({
    super.key,
    required this.customer,
    required this.accentColor,
  });

  void _openViewer(BuildContext context, CustomerDocumentViewType type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CustomerDocumentViewerScreen(
          customer: customer,
          viewType: type,
          accentColor: accentColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = customer.status == 'Active';
    final statusColor =
        isActive ? const Color(0xFF059669) : const Color(0xFFF59E0B);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFC),
        body: Column(
          children: [
            _buildHeader(context, isDark),
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 0),
              child: _buildSummaryCard(context, isDark, statusColor),
            ),
            SizedBox(height: 1.5.h),
            TabBar(
              labelColor: accentColor,
              unselectedLabelColor:
                  isDark ? Colors.white54 : const Color(0xFF6B7280),
              indicatorColor: accentColor,
              indicatorWeight: 2.5,
              labelStyle: GoogleFonts.inter(
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Photo'),
                Tab(text: 'Signature'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPhotoTab(context, isDark),
                  _buildSignatureTab(context, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162032), const Color(0xFF0D1117)]
              : [const Color(0xFF1B365D), accentColor],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
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
              SizedBox(width: 3.w),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Customer Details',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
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

  Widget _buildSummaryCard(
    BuildContext context,
    bool isDark,
    Color statusColor,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.5.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  customer.photoAssetPath,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 48,
                    height: 48,
                    color: accentColor,
                    child: Center(
                      child: Text(
                        AgencyCustomerLookup.initials(customer.name),
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 0.3.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.25.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        customer.status,
                        style: GoogleFonts.inter(
                          fontSize: 6.5.sp,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),
          _detailRow(
            isDark,
            'Account Number',
            customer.accountNumber,
            mono: true,
          ),
          _detailRow(
            isDark,
            'Primary Account',
            customer.primaryAccount,
          ),
          _detailRow(
            isDark,
            'Phone Number',
            customer.phone.isNotEmpty
                ? AgencyCustomerLookup.formatPhone(customer.phone)
                : 'Not on file',
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    bool isDark,
    String label,
    String value, {
    bool mono = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.45.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 34.w,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 7.5.sp,
                color: isDark ? Colors.white54 : const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: mono
                  ? GoogleFonts.jetBrainsMono(
                      fontSize: 7.5.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    )
                  : GoogleFonts.inter(
                      fontSize: 7.5.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: _documentFrame(
        isDark: isDark,
        title: 'Customer Photograph',
        subtitle: 'Tap to view full-size passport photo',
        child: _tappablePreview(
          isDark: isDark,
          onTap: () => _openViewer(context, CustomerDocumentViewType.photo),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    customer.photoAssetPath,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.65),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              customer.name,
                              style: GoogleFonts.inter(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.fullscreen_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: _documentFrame(
        isDark: isDark,
        title: 'Signature Specimen',
        subtitle: 'Tap to view full-size signature',
        child: _tappablePreview(
          isDark: isDark,
          onTap: () => _openViewer(context, CustomerDocumentViewType.signature),
          child: AspectRatio(
            aspectRatio: 720 / 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      child: SvgPicture.asset(
                        customer.signatureAssetPath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.55),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              customer.name,
                              style: GoogleFonts.inter(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.fullscreen_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tappablePreview({
    required bool isDark,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
    );
  }

  Widget _documentFrame({
    required bool isDark,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(3.5.w, 2.5.w, 3.5.w, 1.5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 7.sp,
                    color: isDark ? Colors.white54 : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(3.5.w, 0, 3.5.w, 3.5.w),
            child: child,
          ),
        ],
      ),
    );
  }
}
