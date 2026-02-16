import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AgentHeaderCard extends StatefulWidget {
  final bool isDark;

  const AgentHeaderCard({super.key, required this.isDark});

  @override
  State<AgentHeaderCard> createState() => _AgentHeaderCardState();
}

class _AgentHeaderCardState extends State<AgentHeaderCard> {
  bool _balanceVisible = true;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning!';
    if (hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  @override
  Widget build(BuildContext context) {
    // Status bar light icons on dark gradient
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: widget.isDark
              ? [const Color(0xFF0A2A2A), const Color(0xFF0D1117)]
              : [
                  AppTheme.secondaryTealLight,
                  const Color(0xFF1B6B6B),
                  const Color(0xFF165858),
                ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            top: 0.5.h,
            bottom: 3.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              SizedBox(height: 2.5.h),
              _buildBalanceSection(),
              SizedBox(height: 1.2.h),
              _buildAccountNumber(),
              SizedBox(height: 2.h),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        // Avatar
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withValues(alpha: 0.2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              'KC',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        // Greeting + name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: GoogleFonts.inter(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              Text(
                'KWASHIE CYRIL',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        // Notification bell
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 9,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Account Balance',
              style: GoogleFonts.inter(
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: () => setState(() => _balanceVisible = !_balanceVisible),
              child: Icon(
                _balanceVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.white.withValues(alpha: 0.5),
                size: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.6.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            _balanceVisible ? 'GH₵ 1,440,840.36' : 'GH₵ ••••••',
            key: ValueKey(_balanceVisible),
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountNumber() {
    return Text(
      'Account no: *** *** 4521',
      style: GoogleFonts.inter(
        fontSize: 8.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white.withValues(alpha: 0.45),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.4.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.south_west_rounded,
                    color: AppTheme.secondaryTealLight,
                    size: 17,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Cash In',
                    style: GoogleFonts.inter(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1D23),
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
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.4.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.north_east_rounded, color: Colors.white, size: 17),
                  SizedBox(width: 2.w),
                  Text(
                    'Cash Out',
                    style: GoogleFonts.inter(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
