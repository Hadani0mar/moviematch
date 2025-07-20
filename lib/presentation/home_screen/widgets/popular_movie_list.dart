import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PopularMovieList extends StatelessWidget {
  final List<Map<String, dynamic>> movies;
  final Function(Map<String, dynamic>) onMovieTap;

  const PopularMovieList({
    Key? key,
    required this.movies,
    required this.onMovieTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: movies.length > 5 ? 5 : movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: GestureDetector(
            onTap: () => onMovieTap(movie),
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 20.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: movie['poster'] as String,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie['title'] as String,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          movie['description'] as String,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.primaryRed.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                movie['genre'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppTheme.primaryRed,
                                      fontSize: 9.sp,
                                    ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            CustomIconWidget(
                              iconName: 'star',
                              color: AppTheme.accentGold,
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              movie['rating'].toString(),
                              style: AppTheme.dataTextStyle(
                                isLight: !isDark,
                                fontSize: 11.sp,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              movie['year'].toString(),
                              style: AppTheme.captionTextStyle(
                                isLight: !isDark,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () => _toggleWatchlist(movie),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: movie['isInWatchlist'] == true
                            ? 'bookmark'
                            : 'bookmark_border',
                        color: AppTheme.primaryRed,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleWatchlist(Map<String, dynamic> movie) {
    // Toggle watchlist functionality
    movie['isInWatchlist'] = !(movie['isInWatchlist'] ?? false);
  }
}
