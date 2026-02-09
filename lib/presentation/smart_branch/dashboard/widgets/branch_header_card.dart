import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class BranchHeaderCard extends StatefulWidget {
  final bool isDark;

  const BranchHeaderCard({super.key, required this.isDark});

  @override
  State<BranchHeaderCard> createState() => _BranchHeaderCardState();
}

class _BranchHeaderCardState extends State<BranchHeaderCard> {
  bool _statsVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(),
        SizedBox(height: 2.h),
        _buildBranchCard(),
      ],
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        // Branch avatar with glow
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B365D).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B365D), Color(0xFF2E5A8F)],
              ),
            ),
            child: const Center(
              child: Icon(Icons.account_balance_rounded,
                  color: Colors.white, size: 21),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to',
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w400,
                  color: widget.isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF6B7280),
                ),
              ),
              Text(
                'Accra Main Branch',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color:
                      widget.isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        // Open pill
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                'Open',
                style: GoogleFonts.inter(
                  fontSize: 7.5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        _buildNotificationBell(),
      ],
    );
  }

  Widget _buildNotificationBell() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: widget.isDark
              ? const Color(0xFF1E2328)
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: widget.isDark
                ? const Color(0xFF2A2F35)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: CustomIconWidget(
                iconName: 'notifications_outlined',
                color:
                    widget.isDark ? Colors.white70 : const Color(0xFF475569),
                size: 20,
              ),
            ),
            Positioned(
              right: 11,
              top: 10,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isDark
                        ? const Color(0xFF1E2328)
                        : const Color(0xFFF1F5F9),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B365D).withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 10),
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.5.w),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B365D),
                    Color(0xFF264B87),
                    Color(0xFF3062A8),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shift info + eye toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            color: Colors.white.withValues(alpha: 0.5),
                            size: 14,
                          ),
                          SizedBox(width: 1.5.w),
                          Text(
                            'Morning Shift • 08:00 - 16:00',
                            style: GoogleFonts.inter(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => setState(
                            () => _statsVisible = !_statsVisible),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: _statsVisible
                                  ? 'visibility'
                                  : 'visibility_off',
                              color: Colors.white.withValues(alpha: 0.6),
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  // Volume label
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF60A5FA),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Today\'s Volume',
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.65),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _statsVisible ? 'GH₵ 1,250,000' : 'GH₵ ••••••',
                      key: ValueKey(_statsVisible),
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Stats
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 3.w, vertical: 1.1.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildMiniStat(
                            'Deposits', '156', Icons.south_west_rounded),
                        _buildStatDivider(),
                        _buildMiniStat(
                            'Withdrawals', '94', Icons.north_east_rounded),
                        _buildStatDivider(),
                        _buildMiniStat(
                            'Accounts', '12', Icons.person_add_rounded),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      _buildInfoChip('Branch 001', 'badge'),
                      SizedBox(width: 2.w),
                      _buildInfoChip('Accra, Ghana', 'location_on'),
                    ],
                  ),
                ],
              ),
            ),
            // Decorative
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -40,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.02),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 26,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      color: Colors.white.withValues(alpha: 0.1),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.35), size: 13),
          SizedBox(width: 1.5.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 6.5.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, String iconName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: Colors.white.withValues(alpha: 0.4),
            size: 11,
          ),
          SizedBox(width: 1.w),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 7.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
