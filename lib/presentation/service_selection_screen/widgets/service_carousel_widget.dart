import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

/// Auto-sliding carousel widget for service images
class ServiceCarouselWidget extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final PageController pageController;
  final int currentPage;
  final Function(int) onPageChanged;
  final Function(int) onDotTapped;

  const ServiceCarouselWidget({
    super.key,
    required this.items,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          height: 50.h,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildCarouselItem(context, items[index], theme);
            },
          ),
        ),
        SizedBox(height: 2.h),
        _buildDotIndicators(theme),
      ],
    );
  }

  Widget _buildCarouselItem(
    BuildContext context,
    Map<String, dynamic> item,
    ThemeData theme,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomImageWidget(
              imageUrl: item["image"] as String,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              semanticLabel: item["semanticLabel"] as String,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 3.h,
              left: 4.w,
              right: 4.w,
              child: Text(
                item["title"] as String,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
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

  Widget _buildDotIndicators(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        items.length,
        (index) => GestureDetector(
          onTap: () => onDotTapped(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            width: currentPage == index ? 8.w : 2.w,
            height: 1.h,
            decoration: BoxDecoration(
              color: currentPage == index
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
