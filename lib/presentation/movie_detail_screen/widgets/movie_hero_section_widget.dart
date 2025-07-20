import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MovieHeroSectionWidget extends StatelessWidget {
  final Map<String, dynamic> movieData;

  const MovieHeroSectionWidget({
    super.key,
    required this.movieData,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 60.h,
      child: Stack(
        children: [
          // Movie backdrop/poster
          Positioned.fill(
            child: CustomImageWidget(
              imageUrl:
                  movieData['backdrop_url'] ?? movieData['poster_url'] ?? '',
              width: double.infinity,
              height: 60.h,
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
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
          ),

          // Movie information overlay
          Positioned(
            bottom: 4.h,
            left: 4.w,
            right: 4.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie title
                Text(
                  movieData['title'] ?? 'Unknown Title',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 1.h),

                // Rating and year row
                Row(
                  children: [
                    // Rating with star
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGold.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'star',
                            color: AppTheme.textDark,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            (movieData['rating'] ?? 0.0).toStringAsFixed(1),
                            style: AppTheme.dataBoldTextStyle(
                              isLight: false,
                              fontSize: 12,
                            ).copyWith(color: AppTheme.textDark),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 3.w),

                    // Release year
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.dividerDark.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        movieData['release_year']?.toString() ?? 'N/A',
                        style: AppTheme.dataTextStyle(
                          isLight: false,
                          fontSize: 12,
                        ).copyWith(color: AppTheme.textPrimary),
                      ),
                    ),

                    SizedBox(width: 3.w),

                    // Runtime
                    if (movieData['runtime'] != null) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.dividerDark.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              color: AppTheme.textSecondary,
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${movieData['runtime']}m',
                              style: AppTheme.dataTextStyle(
                                isLight: false,
                                fontSize: 12,
                              ).copyWith(color: AppTheme.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 1.h),

                // Genres
                if (movieData['genres'] != null &&
                    (movieData['genres'] as List).isNotEmpty) ...[
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children:
                        (movieData['genres'] as List).take(3).map((genre) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.primaryRed.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          genre.toString(),
                          style: AppTheme.captionBoldTextStyle(
                            isLight: false,
                            fontSize: 11,
                          ).copyWith(color: AppTheme.textPrimary),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
