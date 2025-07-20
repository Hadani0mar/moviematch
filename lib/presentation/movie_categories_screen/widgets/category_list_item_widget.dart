import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryListItemWidget extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CategoryListItemWidget({
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
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Category thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImageWidget(
                imageUrl: (category["posterCollage"] as String?) ?? "",
                width: 20.w,
                height: 15.w,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: 4.w),

            // Category details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category name with trending indicator
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          (category["name"] as String?) ?? "",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if ((category["isTrending"] as bool?) == true)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryRed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Trending',
                            style: AppTheme.captionBoldTextStyle(
                              isLight: false,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Movie count and indicators
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'movie',
                        color: isDark
                            ? AppTheme.textSecondary
                            : AppTheme.textMediumEmphasisLight,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        "${category["movieCount"] ?? 0} movies",
                        style: AppTheme.captionTextStyle(
                          isLight: !isDark,
                          fontSize: 12,
                        ),
                      ),
                      if ((category["hasNewReleases"] as bool?) == true) ...[
                        SizedBox(width: 3.w),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: AppTheme.accentGold,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'New',
                          style: AppTheme.captionBoldTextStyle(
                            isLight: !isDark,
                            fontSize: 10,
                          ).copyWith(color: AppTheme.accentGold),
                        ),
                      ],
                      if ((category["hasHighRated"] as bool?) == true) ...[
                        SizedBox(width: 3.w),
                        CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.accentGold,
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Top Rated',
                          style: AppTheme.captionBoldTextStyle(
                            isLight: !isDark,
                            fontSize: 10,
                          ).copyWith(color: AppTheme.accentGold),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Arrow indicator
            CustomIconWidget(
              iconName: 'chevron_right',
              color: isDark
                  ? AppTheme.textSecondary
                  : AppTheme.textMediumEmphasisLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
