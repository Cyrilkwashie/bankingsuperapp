import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../widgets/custom_image_widget.dart';

class ServiceCarouselWidget extends StatelessWidget {
  final PageController pageController;
  final List<Map<String, dynamic>> carouselItems;
  final int currentPage;
  final Function(int) onPageChanged;
  final Function(int) onDotTapped;

  const ServiceCarouselWidget({
    super.key,
    required this.pageController,
    required this.carouselItems,
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
            itemCount: carouselItems.length,
            itemBuilder: (context, index) {
              final item = carouselItems[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CustomImageWidget(
                          imageUrl: item['image'],
                          fit: BoxFit.cover,
                          semanticLabel: item['semanticLabel'],
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
                            item['title'],
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            carouselItems.length,
            (index) => GestureDetector(
              onTap: () => onDotTapped(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.3,
                        ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}