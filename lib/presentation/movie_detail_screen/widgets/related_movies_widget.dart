import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RelatedMoviesWidget extends StatelessWidget {
  final Map<String, dynamic> movieData;

  const RelatedMoviesWidget({
    super.key,
    required this.movieData,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Mock related movies data
    final List<Map<String, dynamic>> relatedMovies = [
      {
        "id": 1,
        "title": "Inception",
        "poster_url":
            "https://images.unsplash.com/photo-1489599511986-c2d6e6b5b6b8?w=300&h=450&fit=crop",
        "rating": 8.8,
        "release_year": 2010,
        "genre": "Sci-Fi",
      },
      {
        "id": 2,
        "title": "The Dark Knight",
        "poster_url":
            "https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=300&h=450&fit=crop",
        "rating": 9.0,
        "release_year": 2008,
        "genre": "Action",
      },
      {
        "id": 3,
        "title": "Interstellar",
        "poster_url":
            "https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=300&h=450&fit=crop",
        "rating": 8.6,
        "release_year": 2014,
        "genre": "Sci-Fi",
      },
      {
        "id": 4,
        "title": "Pulp Fiction",
        "poster_url":
            "https://images.unsplash.com/photo-1489599511986-c2d6e6b5b6b8?w=300&h=450&fit=crop",
        "rating": 8.9,
        "release_year": 1994,
        "genre": "Crime",
      },
      {
        "id": 5,
        "title": "The Matrix",
        "poster_url":
            "https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=300&h=450&fit=crop",
        "rating": 8.7,
        "release_year": 1999,
        "genre": "Sci-Fi",
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'More Like This',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/movie-categories-screen');
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.primaryRed.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View All',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.primaryRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'arrow_forward',
                          color: AppTheme.primaryRed,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 1.5.h),

          // Related movies horizontal scroll
          SizedBox(
            height: 32.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: relatedMovies.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final movie = relatedMovies[index];
                return _buildMovieCard(context, movie, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(
      BuildContext context, Map<String, dynamic> movie, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/movie-detail-screen',
          arguments: movie,
        );
      },
      child: Container(
        width: 30.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie poster
            Container(
              width: 30.w,
              height: 22.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                border: Border.all(
                  color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Poster image
                    CustomImageWidget(
                      imageUrl: movie['poster_url'] ?? '',
                      width: 30.w,
                      height: 22.h,
                      fit: BoxFit.cover,
                    ),

                    // Rating overlay
                    Positioned(
                      top: 1.h,
                      right: 2.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.5.w, vertical: 0.5.h),
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
                              size: 12,
                            ),
                            SizedBox(width: 0.5.w),
                            Text(
                              movie['rating'].toStringAsFixed(1),
                              style: AppTheme.dataTextStyle(
                                isLight: false,
                                fontSize: 10,
                              ).copyWith(
                                color: AppTheme.textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Play button overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withValues(alpha: 0.0),
                        ),
                        child: Center(
                          child: Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryRed.withValues(alpha: 0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'play_arrow',
                                color: AppTheme.textPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 1.h),

            // Movie title
            Text(
              movie['title'] ?? 'Unknown Title',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 0.5.h),

            // Movie details
            Row(
              children: [
                Text(
                  movie['release_year'].toString(),
                  style: AppTheme.captionTextStyle(
                    isLight: !isDark,
                    fontSize: 10,
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppTheme.textSecondary
                        : AppTheme.textMediumEmphasisLight,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    movie['genre'] ?? '',
                    style: AppTheme.captionTextStyle(
                      isLight: !isDark,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
