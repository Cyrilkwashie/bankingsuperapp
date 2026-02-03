import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Bottom sheet displaying detailed service information
class ServiceInfoBottomSheet extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceInfoBottomSheet({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientColors = service["gradientColors"] as List<Color>;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      service["subtitle"] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'About This Service',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            service["description"] as String,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(service["route"] as String);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: gradientColors[0],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Get Started',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
