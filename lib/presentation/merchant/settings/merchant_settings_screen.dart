import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../main.dart';
import '../../../widgets/banking_bottom_navigation.dart';

/// Merchant Settings screen with configuration options
class MerchantSettingsScreen extends StatefulWidget {
  const MerchantSettingsScreen({super.key});

  @override
  State<MerchantSettingsScreen> createState() => _MerchantSettingsScreenState();
}

class _MerchantSettingsScreenState extends State<MerchantSettingsScreen> {
  final int _currentIndex = 2; // Settings tab is selected (Merchant has 3 items)

  // Merchant brand color - Green
  static const Color _brandColor = Color(0xFF059669);

  void _onNavigationTap(int index) {
    if (index == _currentIndex) return;

    // Navigate to different screens based on index
    switch (index) {
      case 0: // Dashboard
        AppRoutes.replaceWithoutTransition(
          context,
          AppRoutes.merchantBankingDashboard,
        );
        break;
      case 1: // Transactions
        AppRoutes.replaceWithoutTransition(
          context,
          AppRoutes.merchantTransactions,
        );
        break;
      case 2: // Settings (current)
        // Already here
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
        backgroundColor: theme.brightness == Brightness.light
            ? const Color(0xFFFAFBFC)
            : const Color(0xFF0F1419),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0.5.h),
                    Text(
                      'Merchant Settings',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFFFAFBFC)
                            : const Color(0xFF1A1D23),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _buildSectionHeader(context, 'Profile', isDark),
                    SizedBox(height: 0.5.h),
                    _buildProfileCard(context, isDark),
                    SizedBox(height: 2.h),
                    _buildSectionHeader(context, 'Security', isDark),
                    SizedBox(height: 0.5.h),
                    _buildSettingItem(
                      context,
                      icon: Icons.fingerprint,
                      title: 'Biometric Authentication',
                      subtitle: 'Use fingerprint or face ID',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeThumbColor: _brandColor,
                      ),
                      isDark: isDark,
                    ),
                    SizedBox(height: 0.5.h),
                    _buildSettingItem(
                      context,
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your login password',
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      onTap: () {},
                      isDark: isDark,
                    ),
                    SizedBox(height: 0.5.h),
                    _buildSettingItem(
                      context,
                      icon: Icons.pin,
                      title: 'Change PIN',
                      subtitle: 'Update your transaction PIN',
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      onTap: () {},
                      isDark: isDark,
                    ),
                    SizedBox(height: 2.h),
                    _buildSectionHeader(context, 'Notifications', isDark),
                    SizedBox(height: 0.5.h),
                    _buildSettingItem(
                      context,
                      icon: Icons.notifications_outlined,
                      title: 'Transaction Alerts',
                      subtitle: 'Get notified for all transactions',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeThumbColor: _brandColor,
                      ),
                      isDark: isDark,
                    ),
                    SizedBox(height: 0.5.h),
                    _buildSettingItem(
                      context,
                      icon: Icons.campaign_outlined,
                      title: 'Promotional Messages',
                      subtitle: 'Receive offers and updates',
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {},
                        activeThumbColor: _brandColor,
                      ),
                      isDark: isDark,
                    ),
                    SizedBox(height: 2.h),
                    _buildSectionHeader(context, 'Display', isDark),
                    SizedBox(height: 0.5.h),
                    _buildSettingItem(
                      context,
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      subtitle: 'Switch to dark theme',
                      trailing: Switch(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                        activeThumbColor: _brandColor,
                      ),
                      isDark: isDark,
                    ),
                    SizedBox(height: 0.5.h),
                    _buildSettingItem(
                      context,
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: 'English (US)',
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      onTap: () {},
                      isDark: isDark,
                    ),
                    SizedBox(height: 2.h),
                    _buildSectionHeader(context, 'Support', isDark),
                    SizedBox(height: 0.5.h),
                    _buildSettingItem(
                      context,
                      icon: Icons.location_on_outlined,
                      title: 'Branch & ATM Locations',
                      subtitle: 'Find nearby branches',
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      onTap: () {},
                      isDark: isDark,
                    ),
                    SizedBox(height: 0.5.h),
                    _buildSettingItem(
                      context,
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get assistance',
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      onTap: () {},
                      isDark: isDark,
                    ),
                    SizedBox(height: 0.5.h),
                    _buildSettingItem(
                      context,
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'App version 1.0.0',
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      onTap: () {},
                      isDark: isDark,
                    ),
                    SizedBox(height: 2.h),
                    _buildLogoutButton(context, isDark),
                    SizedBox(height: 0.5.h),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BankingBottomNavigation(
          currentIndex: _currentIndex,
          onTap: _onNavigationTap,
          items: BankingNavigationItems.merchantItems,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2328) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.white : Colors.black).withValues(
              alpha: 0.08,
            ),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _brandColor.withValues(alpha: 0.1),
            ),
            child: Icon(Icons.person, color: _brandColor, size: 20),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mike Johnson',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? const Color(0xFFFAFBFC)
                        : const Color(0xFF1A1D23),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  'MR-2024-1523',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  'mike.johnson@merchant.com',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.edit_outlined,
            size: 20,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2328) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.08,
                ),
                offset: const Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _brandColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _brandColor, size: 16),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFFFAFBFC)
                            : const Color(0xFF1A1D23),
                      ),
                    ),
                    SizedBox(height: 0.3.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: isDark ? const Color(0xFF1E2328) : Colors.white,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFDC2626),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Sign Out',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: isDark ? Colors.white : const Color(0xFF1A1D23),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to sign out?',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF1A1D23),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You will need to enter your credentials again to access your Merchant Banking account.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: isDark
                                ? const Color(0xFF374151)
                                : const Color(0xFFE5E7EB),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.serviceSelection,
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Sign Out',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFDC2626).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, color: Color(0xFFDC2626), size: 16),
              SizedBox(width: 2.w),
              Text(
                'Logout',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
