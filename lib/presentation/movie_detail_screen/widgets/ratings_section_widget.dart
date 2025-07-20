import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RatingsSectionWidget extends StatefulWidget {
  final Map<String, dynamic> movieData;

  const RatingsSectionWidget({
    super.key,
    required this.movieData,
  });

  @override
  State<RatingsSectionWidget> createState() => _RatingsSectionWidgetState();
}

class _RatingsSectionWidgetState extends State<RatingsSectionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double imdbRating =
        (widget.movieData['imdb_rating'] ?? 0.0).toDouble();
    final double tmdbRating = (widget.movieData['rating'] ?? 0.0).toDouble();
    final int voteCount = widget.movieData['vote_count'] ?? 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Ratings & Reviews',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.5.h),

          // Ratings grid
          Row(
            children: [
              // IMDB Rating
              Expanded(
                child: _buildRatingCard(
                  context,
                  'IMDB',
                  imdbRating,
                  '10',
                  AppTheme.accentGold,
                  isDark,
                ),
              ),

              SizedBox(width: 3.w),

              // TMDB Rating
              Expanded(
                child: _buildRatingCard(
                  context,
                  'TMDB',
                  tmdbRating,
                  '10',
                  AppTheme.primaryRed,
                  isDark,
                ),
              ),

              SizedBox(width: 3.w),

              // Vote Count
              Expanded(
                child: _buildVoteCountCard(context, voteCount, isDark),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // User Reviews Section
          _buildUserReviewsSection(context, isDark),
        ],
      ),
    );
  }

  Widget _buildRatingCard(
    BuildContext context,
    String source,
    double rating,
    String maxRating,
    Color accentColor,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            source,
            style: AppTheme.captionTextStyle(
              isLight: !isDark,
              fontSize: 11,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'star',
                color: accentColor,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                rating.toStringAsFixed(1),
                style: AppTheme.dataBoldTextStyle(
                  isLight: !isDark,
                  fontSize: 16,
                ).copyWith(color: accentColor),
              ),
              Text(
                '/$maxRating',
                style: AppTheme.dataTextStyle(
                  isLight: !isDark,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoteCountCard(BuildContext context, int voteCount, bool isDark) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Votes',
            style: AppTheme.captionTextStyle(
              isLight: !isDark,
              fontSize: 11,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'people',
                color: isDark
                    ? AppTheme.textSecondary
                    : AppTheme.textMediumEmphasisLight,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                _formatVoteCount(voteCount),
                style: AppTheme.dataBoldTextStyle(
                  isLight: !isDark,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserReviewsSection(BuildContext context, bool isDark) {
    final List<Map<String, dynamic>> mockReviews = [
      {
        "user": "MovieBuff2024",
        "rating": 4.5,
        "review":
            "Absolutely stunning cinematography and incredible performances. The story kept me engaged throughout.",
        "date": "2024-07-15",
      },
      {
        "user": "CinemaLover",
        "rating": 4.0,
        "review":
            "Great movie with excellent direction. Some pacing issues in the middle but overall very entertaining.",
        "date": "2024-07-12",
      },
      {
        "user": "FilmCritic99",
        "rating": 3.5,
        "review":
            "Solid performances and good production value. Worth watching but not groundbreaking.",
        "date": "2024-07-10",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Reviews header with expand button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'User Reviews',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? 'Show Less' : 'Show All',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.primaryRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: _isExpanded
                          ? 'keyboard_arrow_up'
                          : 'keyboard_arrow_down',
                      color: AppTheme.primaryRed,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        // Reviews list
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isExpanded ? null : 15.h,
          child: ListView.separated(
            shrinkWrap: true,
            physics: _isExpanded
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            itemCount: _isExpanded ? mockReviews.length : 1,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final review = mockReviews[index];
              return _buildReviewCard(context, review, isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(
      BuildContext context, Map<String, dynamic> review, bool isDark) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['user'],
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: AppTheme.accentGold,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    review['rating'].toStringAsFixed(1),
                    style: AppTheme.dataTextStyle(
                      isLight: !isDark,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Review text
          Text(
            review['review'],
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppTheme.textSecondary
                  : AppTheme.textMediumEmphasisLight,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 1.h),

          // Review date
          Text(
            review['date'],
            style: AppTheme.captionTextStyle(
              isLight: !isDark,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  String _formatVoteCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
