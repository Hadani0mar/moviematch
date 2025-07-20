import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String type; // 'empty_search', 'no_results', 'trending'
  final String? searchQuery;
  final VoidCallback? onClearFilters;
  final Function(String)? onGenreTap;
  final List<Map<String, dynamic>>? trendingMovies;
  final List<String>? popularGenres;

  const EmptyStateWidget({
    super.key,
    required this.type,
    this.searchQuery,
    this.onClearFilters,
    this.onGenreTap,
    this.trendingMovies,
    this.popularGenres,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case 'empty_search':
        return _buildEmptySearch();
      case 'no_results':
        return _buildNoResults();
      case 'trending':
        return _buildTrendingState(context, isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEmptySearch() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          CustomIconWidget(
            iconName: 'search',
            color: isDark
                ? AppTheme.textSecondary
                : AppTheme.textMediumEmphasisLight,
            size: 80,
          ),
          SizedBox(height: 3.h),
          Text(
            'search.empty_search'.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'search.empty_search_desc'.tr(),
            style: AppTheme.captionTextStyle(
              isLight: !isDark,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          if (widget.popularGenres != null) ...[
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'filters.genres'.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            SizedBox(height: 2.h),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 2.w,
              runSpacing: 1.h,
              children: widget.popularGenres!.map((genre) {
                return GestureDetector(
                  onTap: () => widget.onGenreTap?.call(genre),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.primaryRed,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          CustomIconWidget(
            iconName: 'search_off',
            color: isDark
                ? AppTheme.textSecondary
                : AppTheme.textMediumEmphasisLight,
            size: 80,
          ),
          SizedBox(height: 3.h),
          Text(
            'search.no_results'.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'search.no_results_desc'.tr(),
            style: AppTheme.captionTextStyle(
              isLight: !isDark,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.onClearFilters != null) ...[
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: widget.onClearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: AppTheme.textPrimary,
              ),
              child: Text('search.clear_filters'.tr()),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrendingState(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (trendingMovies != null && trendingMovies!.isNotEmpty)
            _buildTrendingSection(context, isDark),
        ],
      ),
    );
  }

  Widget _buildTrendingSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trending Now',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
              ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trendingMovies!.take(10).length,
            itemBuilder: (context, index) {
              final movie = trendingMovies![index];
              return Container(
                width: 30.w,
                margin: EdgeInsets.only(right: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: movie['poster_url'] ?? '',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      movie['title'] ?? 'Unknown',
                      style: Theme.of(context).textTheme.labelSmall,
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

  Widget _buildPopularGenresSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Genres',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
              ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: popularGenres!
              .map(
                (genre) => GestureDetector(
                  onTap: () => onGenreTap?.call(genre),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
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
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.primaryRed,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSuggestions(BuildContext context, bool isDark) {
    final suggestions = [
      'Avengers',
      'Spider-Man',
      'Batman',
      'Star Wars',
      'Marvel',
      'Action',
      'Comedy',
      'Drama',
      'Horror',
      'Sci-Fi'
    ];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: suggestions
          .map(
            (suggestion) => GestureDetector(
              onTap: () => onGenreTap?.call(suggestion),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                    width: 1,
                  ),
                ),
                child: Text(
                  suggestion,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppTheme.textSecondary
                            : AppTheme.textMediumEmphasisLight,
                      ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
