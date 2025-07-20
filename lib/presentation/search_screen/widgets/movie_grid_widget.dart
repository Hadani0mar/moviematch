import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MovieGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> movies;
  final Function(Map<String, dynamic>) onMovieTap;
  final Function(Map<String, dynamic>) onMovieLongPress;
  final Set<int> selectedMovies;
  final bool isSelectionMode;

  const MovieGridWidget({
    super.key,
    required this.movies,
    required this.onMovieTap,
    required this.onMovieLongPress,
    required this.selectedMovies,
    required this.isSelectionMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final isSelected = selectedMovies.contains(movie['id']);

        return GestureDetector(
          onTap: () => onMovieTap(movie),
          onLongPress: () => onMovieLongPress(movie),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.surfaceDark
                                : AppTheme.surfaceLight,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                          ),
                          child: CustomImageWidget(
                            imageUrl: movie['poster_url'] ?? '',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.surfaceDark
                                : AppTheme.surfaceLight,
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                movie['title'] ?? 'Unknown Title',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'star',
                                    color: AppTheme.accentGold,
                                    size: 12,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    '${movie['rating'] ?? 0.0}',
                                    style: AppTheme.dataTextStyle(
                                      isLight: !isDark,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${movie['year'] ?? 'N/A'}',
                                    style: AppTheme.captionTextStyle(
                                      isLight: !isDark,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelectionMode)
                  Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryRed
                            : Colors.transparent,
                        border: Border.all(
                          color:
                              isSelected ? AppTheme.primaryRed : Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: isSelected
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: Colors.white,
                              size: 12,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
