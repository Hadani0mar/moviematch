import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CastCarouselWidget extends StatelessWidget {
  final Map<String, dynamic> movieData;

  const CastCarouselWidget({
    super.key,
    required this.movieData,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<dynamic> cast = movieData['cast'] ?? [];

    if (cast.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Cast',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: 1.5.h),

          // Cast horizontal scroll
          SizedBox(
            height: 20.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: cast.length > 10 ? 10 : cast.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final actor = cast[index] as Map<String, dynamic>;
                return _buildCastCard(context, actor, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastCard(
      BuildContext context, Map<String, dynamic> actor, bool isDark) {
    return Container(
      width: 20.w,
      child: Column(
        children: [
          // Actor photo
          Container(
            width: 20.w,
            height: 12.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
              border: Border.all(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: actor['profile_path'] != null &&
                      actor['profile_path'].toString().isNotEmpty
                  ? CustomImageWidget(
                      imageUrl: actor['profile_path'],
                      width: 20.w,
                      height: 12.h,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 20.w,
                      height: 12.h,
                      color:
                          isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: isDark
                              ? AppTheme.textSecondary
                              : AppTheme.textMediumEmphasisLight,
                          size: 24,
                        ),
                      ),
                    ),
            ),
          ),

          SizedBox(height: 1.h),

          // Actor name
          Text(
            actor['name'] ?? 'Unknown Actor',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 0.5.h),

          // Character name
          if (actor['character'] != null) ...[
            Text(
              actor['character'],
              style: AppTheme.captionTextStyle(
                isLight: !isDark,
                fontSize: 10,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
