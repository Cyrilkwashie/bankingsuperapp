import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Service selection card with gradient background and enter button
class ServiceCardWidget extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ServiceCardWidget({
    super.key,
    required this.service,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientColors = service["gradientColors"] as List<Color>;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: service["icon"] as String,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service["title"] as String,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          service["subtitle"] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Enter',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: gradientColors[0],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'arrow_forward',
                          color: gradientColors[0],
                          size: 18,
                        ),
                      ],
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
}
