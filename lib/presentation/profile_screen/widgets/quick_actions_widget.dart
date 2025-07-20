import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class QuickActionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentlyWatched;
  final List<String> favoriteGenres;
  final VoidCallback? onViewHistoryPressed;

  const QuickActionsWidget({
    super.key,
    required this.recentlyWatched,
    required this.favoriteGenres,
    this.onViewHistoryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'profile.watchlist'.tr(),
                  'bookmark',
                  AppTheme.primaryRed,
                  widget.onWatchlistTap,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  'profile.favorites'.tr(),
                  'favorite',
                  Colors.pink,
                  widget.onFavoritesTap,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'profile.ratings'.tr(),
                  'star',
                  AppTheme.accentGold,
                  widget.onRatingsTap,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  'profile.reviews'.tr(),
                  'rate_review',
                  Colors.blue,
                  widget.onReviewsTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    String icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyWatchedSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently Watched',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 20.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentlyWatched.length,
            itemBuilder: (context, index) {
              final movie = recentlyWatched[index];
              return Container(
                width: 30.w,
                margin: EdgeInsets.only(right: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomImageWidget(
                          imageUrl: movie['poster'] as String,
                          width: 30.w,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      movie['title'] as String,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteGenresSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Favorite Genres',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: favoriteGenres.map((genre) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.primaryRed.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                genre,
                style: AppTheme.captionBoldTextStyle(
                  isLight: !isDark,
                  fontSize: 11.sp,
                ).copyWith(color: AppTheme.primaryRed),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildViewingHistoryCard(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: onViewHistoryPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
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
            CustomIconWidget(
              iconName: 'history',
              color: AppTheme.primaryRed,
              size: 6.w,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Viewing History',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'See all your watched movies',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: isDark
                  ? AppTheme.textSecondary
                  : AppTheme.textMediumEmphasisLight,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
