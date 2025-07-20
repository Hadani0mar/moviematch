import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategoryPreviewWidget extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onViewAll;
  final VoidCallback onClose;

  const CategoryPreviewWidget({
    super.key,
    required this.category,
    required this.onViewAll,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topMovies = (category["topMovies"] as List?) ?? [];

    return Container(
      width: 85.w,
      constraints: BoxConstraints(maxHeight: 60.h),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    (category["name"] as String?) ?? "",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.textPrimary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category stats
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'movie',
                        color: isDark
                            ? AppTheme.textSecondary
                            : AppTheme.textMediumEmphasisLight,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "${category["movieCount"] ?? 0} movies available",
                        style: AppTheme.captionTextStyle(
                          isLight: !isDark,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Top 3 movies
                  Text(
                    "Top Movies in ${category["name"] ?? "Category"}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  SizedBox(height: 2.h),

                  // Movie list
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: topMovies.length > 3 ? 3 : topMovies.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 1.h),
                      itemBuilder: (context, index) {
                        final movie = topMovies[index] as Map<String, dynamic>;
                        return Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.darkBackground.withValues(alpha: 0.5)
                                : AppTheme.lightBackground
                                    .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? AppTheme.dividerDark
                                  : AppTheme.dividerLight,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Movie poster
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CustomImageWidget(
                                  imageUrl: (movie["poster"] as String?) ?? "",
                                  width: 15.w,
                                  height: 20.w,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              SizedBox(width: 3.w),

                              // Movie details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (movie["title"] as String?) ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'star',
                                          color: AppTheme.accentGold,
                                          size: 14,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          "${movie["rating"] ?? "0.0"}",
                                          style: AppTheme.dataBoldTextStyle(
                                            isLight: !isDark,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Text(
                                          "${movie["year"] ?? ""}",
                                          style: AppTheme.captionTextStyle(
                                            isLight: !isDark,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // View All button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onViewAll,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'View All Movies',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
