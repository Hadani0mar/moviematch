import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class UserStatsWidget extends StatelessWidget {
  final int moviesWatched;
  final int watchlistCount;
  final List<String> favoriteGenres;

  const UserStatsWidget({
    super.key,
    required this.moviesWatched,
    required this.watchlistCount,
    required this.favoriteGenres,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'profile.statistics'.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'profile.movies_watched'.tr(),
                  widget.moviesWatched.toString(),
                  'movie',
                  AppTheme.primaryRed,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatItem(
                  'profile.hours_watched'.tr(),
                  widget.hoursWatched.toString(),
                  'schedule',
                  AppTheme.accentGold,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'profile.favorite_genre'.tr(),
                  widget.favoriteGenre,
                  'favorite',
                  Colors.purple,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatItem(
                  'profile.ratings'.tr(),
                  widget.totalRatings.toString(),
                  'star',
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, String iconName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.primaryRed,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.dataBoldTextStyle(
              isLight: !isDark,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.captionTextStyle(
              isLight: !isDark,
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
