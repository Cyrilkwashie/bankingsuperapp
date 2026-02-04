import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

/// Settings screen with configuration options for agent preferences and security
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
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
                  SizedBox(height: 1.h),
                  Text(
                    'Settings',
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
                  SizedBox(height: 1.h),
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
                      activeThumbColor: theme.colorScheme.primary,
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
                      activeThumbColor: theme.colorScheme.primary,
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
                      activeThumbColor: theme.colorScheme.primary,
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
                      value: isDark,
                      onChanged: (value) {},
                      activeThumbColor: theme.colorScheme.primary,
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
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12.sp,
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
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Anderson',
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
                  'AG-2024-1523',
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
                  'john.anderson@bank.com',
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
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
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
            builder: (context) => AlertDialog(
              title: Text(
                'Logout',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700),
              ),
              content: Text(
                'Are you sure you want to logout?',
                style: GoogleFonts.inter(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.serviceSelection,
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Logout',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFDC2626),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
