import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './view_toggle_widget.dart';

class LoadingSkeletonWidget extends StatefulWidget {
  final ViewMode viewMode;

  const LoadingSkeletonWidget({
    super.key,
    required this.viewMode,
  });

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return widget.viewMode == ViewMode.grid
        ? _buildGridSkeleton(isDark)
        : _buildListSkeleton(isDark);
  }

  Widget _buildGridSkeleton(bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: 6,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: 25.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight)
                    .withValues(alpha: _animation.value),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: (isDark
                                ? AppTheme.darkBackground
                                : AppTheme.lightBackground)
                            .withValues(alpha: _animation.value * 0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60.w,
                            height: 2.h,
                            decoration: BoxDecoration(
                              color: (isDark
                                      ? AppTheme.darkBackground
                                      : AppTheme.lightBackground)
                                  .withValues(alpha: _animation.value * 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            width: 40.w,
                            height: 1.5.h,
                            decoration: BoxDecoration(
                              color: (isDark
                                      ? AppTheme.darkBackground
                                      : AppTheme.lightBackground)
                                  .withValues(alpha: _animation.value * 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListSkeleton(bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: 8,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight)
                    .withValues(alpha: _animation.value),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: (isDark
                              ? AppTheme.darkBackground
                              : AppTheme.lightBackground)
                          .withValues(alpha: _animation.value * 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50.w,
                          height: 2.h,
                          decoration: BoxDecoration(
                            color: (isDark
                                    ? AppTheme.darkBackground
                                    : AppTheme.lightBackground)
                                .withValues(alpha: _animation.value * 0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          width: 30.w,
                          height: 1.5.h,
                          decoration: BoxDecoration(
                            color: (isDark
                                    ? AppTheme.darkBackground
                                    : AppTheme.lightBackground)
                                .withValues(alpha: _animation.value * 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
