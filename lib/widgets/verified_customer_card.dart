import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../data/agency_customer_lookup.dart';
import '../models/verified_customer.dart';
import '../presentation/agency/customer/verified_customer_detail_screen.dart';

class VerifiedCustomerCard extends StatelessWidget {
  final VerifiedCustomer customer;
  final Color accentColor;
  final bool isDark;
  final Widget? footer;

  const VerifiedCustomerCard({
    super.key,
    required this.customer,
    required this.accentColor,
    required this.isDark,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = customer.status == 'Active';
    final statusColor =
        isActive ? const Color(0xFF059669) : const Color(0xFFF59E0B);

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: isDark ? 0.08 : 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: statusColor.withValues(alpha: 0.18)),
        ),
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VerifiedCustomerDetailScreen(
                        customer: customer,
                        accentColor: accentColor,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentColor.withValues(alpha: 0.85),
                            accentColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Center(
                        child: Text(
                          AgencyCustomerLookup.initials(customer.name),
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.5.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.name,
                            style: GoogleFonts.inter(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 0.15.h),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  AgencyCustomerLookup.maskAccountNo(
                                    customer.accountNumber,
                                  ),
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 7.sp,
                                    color: isDark
                                        ? Colors.white54
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              SizedBox(width: 1.5.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 1.5.w,
                                  vertical: 0.15.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  customer.primaryAccount,
                                  style: GoogleFonts.inter(
                                    fontSize: 6.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white54
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (customer.phone.isNotEmpty) ...[
                            SizedBox(height: 0.2.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  size: 11,
                                  color: isDark
                                      ? Colors.white38
                                      : const Color(0xFF94A3B8),
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  AgencyCustomerLookup.formatPhone(
                                    customer.phone,
                                  ),
                                  style: GoogleFonts.inter(
                                    fontSize: 6.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? Colors.white54
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.3.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            customer.status,
                            style: GoogleFonts.inter(
                              fontSize: 6.5.sp,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: isDark ? Colors.white38 : const Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),
            ),
            if (footer != null) ...[
              SizedBox(height: 0.9.h),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
