import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CategoryCardWidget({
    super.key,
    required this.category,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        height: 25.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image collage
              CustomImageWidget(
                imageUrl: (category["posterCollage"] as String?) ?? "",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),

              // Gradient overlay for text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Content overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Trending indicator
                      if ((category["isTrending"] as bool?) == true)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryRed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'trending_up',
                                color: AppTheme.textPrimary,
                                size: 12,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Trending',
                                style: AppTheme.captionBoldTextStyle(
                                  isLight: false,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 1.h),

                      // Genre name
                      Text(
                        (category["name"] as String?) ?? "",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 0.5.h),

                      // Movie count and new releases indicator
                      Row(
                        children: [
                          Text(
                            "${category["movieCount"] ?? 0} movies",
                            style: AppTheme.captionTextStyle(
                              isLight: false,
                              fontSize: 12,
                            ),
                          ),

                          if ((category["hasNewReleases"] as bool?) ==
                              true) ...[
                            SizedBox(width: 3.w),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppTheme.accentGold,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'New',
                              style: AppTheme.captionBoldTextStyle(
                                isLight: false,
                                fontSize: 10,
                              ).copyWith(color: AppTheme.accentGold),
                            ),
                          ],

                          const Spacer(),

                          // High rated indicator
                          if ((category["hasHighRated"] as bool?) == true)
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color: AppTheme.accentGold,
                                  size: 14,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Top Rated',
                                  style: AppTheme.captionBoldTextStyle(
                                    isLight: false,
                                    fontSize: 10,
                                  ).copyWith(color: AppTheme.accentGold),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
