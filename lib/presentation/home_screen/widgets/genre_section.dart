import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GenreSection extends StatelessWidget {
  final String genreName;
  final List<Map<String, dynamic>> movies;
  final Function(Map<String, dynamic>) onMovieTap;
  final VoidCallback onSeeAllTap;

  const GenreSection({
    Key? key,
    required this.genreName,
    required this.movies,
    required this.onMovieTap,
    required this.onSeeAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                genreName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: onSeeAllTap,
                child: Text(
                  'See All',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.primaryRed,
                      ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 4.w),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () => onMovieTap(movie),
                child: Container(
                  width: 30.w,
                  margin: EdgeInsets.only(right: 3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? AppTheme.shadowDark
                                    : AppTheme.shadowLight,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                CustomImageWidget(
                                  imageUrl: movie['poster'] as String,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 2.w,
                                  right: 2.w,
                                  child: Container(
                                    padding: EdgeInsets.all(1.w),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'star',
                                          color: AppTheme.accentGold,
                                          size: 10,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          movie['rating'].toString(),
                                          style: AppTheme.dataTextStyle(
                                            isLight: false,
                                            fontSize: 9.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        movie['title'] as String,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        movie['year'].toString(),
                        style: AppTheme.captionTextStyle(
                          isLight: !isDark,
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
