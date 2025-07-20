import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrailerSectionWidget extends StatefulWidget {
  final Map<String, dynamic> movieData;

  const TrailerSectionWidget({
    super.key,
    required this.movieData,
  });

  @override
  State<TrailerSectionWidget> createState() => _TrailerSectionWidgetState();
}

class _TrailerSectionWidgetState extends State<TrailerSectionWidget> {
  bool _isPlaying = false;
  bool _isFullscreen = false;

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String? trailerUrl = widget.movieData['trailer_url'];

    if (trailerUrl == null || trailerUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Trailer',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.5.h),

          // Video player container
          Container(
            width: double.infinity,
            height: 25.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Video thumbnail/background
                  Positioned.fill(
                    child: widget.movieData['backdrop_url'] != null
                        ? CustomImageWidget(
                            imageUrl: widget.movieData['backdrop_url'],
                            width: double.infinity,
                            height: 25.h,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.black,
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'movie',
                                color: AppTheme.textSecondary,
                                size: 48,
                              ),
                            ),
                          ),
                  ),

                  // Dark overlay
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.4),
                    ),
                  ),

                  // Play controls overlay
                  Positioned.fill(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Play/Pause button
                          GestureDetector(
                            onTap: _togglePlayback,
                            child: Container(
                              width: 15.w,
                              height: 15.w,
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.primaryRed.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: _isPlaying ? 'pause' : 'play_arrow',
                                  color: AppTheme.textPrimary,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Control buttons overlay
                  Positioned(
                    top: 2.h,
                    right: 3.w,
                    child: Row(
                      children: [
                        // Fullscreen button
                        GestureDetector(
                          onTap: _toggleFullscreen,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: _isFullscreen
                                  ? 'fullscreen_exit'
                                  : 'fullscreen',
                              color: AppTheme.textPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Video progress indicator (mock)
                  if (_isPlaying) ...[
                    Positioned(
                      bottom: 1.h,
                      left: 3.w,
                      right: 3.w,
                      child: Column(
                        children: [
                          // Progress bar
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.textSecondary.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.3, // Mock 30% progress
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryRed,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 1.h),

                          // Time indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1:23',
                                style: AppTheme.dataTextStyle(
                                  isLight: false,
                                  fontSize: 12,
                                ).copyWith(color: AppTheme.textPrimary),
                              ),
                              Text(
                                '4:15',
                                style: AppTheme.dataTextStyle(
                                  isLight: false,
                                  fontSize: 12,
                                ).copyWith(color: AppTheme.textPrimary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          SizedBox(height: 1.h),

          // Video info
          Row(
            children: [
              CustomIconWidget(
                iconName: 'play_circle_outline',
                color: isDark
                    ? AppTheme.textSecondary
                    : AppTheme.textMediumEmphasisLight,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Official Trailer • HD Quality',
                style: AppTheme.captionTextStyle(
                  isLight: !isDark,
                  fontSize: 12,
                ),
              ),

              Spacer(),

              // Picture-in-picture button
              GestureDetector(
                onTap: () {
                  // Mock PiP functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Picture-in-Picture mode activated'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color:
                          isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'picture_in_picture',
                        color: isDark
                            ? AppTheme.textSecondary
                            : AppTheme.textMediumEmphasisLight,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'PiP',
                        style: AppTheme.captionTextStyle(
                          isLight: !isDark,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
