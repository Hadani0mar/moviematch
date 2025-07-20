import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SynopsisSectionWidget extends StatefulWidget {
  final Map<String, dynamic> movieData;

  const SynopsisSectionWidget({
    super.key,
    required this.movieData,
  });

  @override
  State<SynopsisSectionWidget> createState() => _SynopsisSectionWidgetState();
}

class _SynopsisSectionWidgetState extends State<SynopsisSectionWidget> {
  bool _isExpanded = false;
  final int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String synopsis = widget.movieData['synopsis'] ??
        widget.movieData['overview'] ??
        'No synopsis available for this movie.';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Synopsis',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.5.h),

          // Synopsis text
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(
              synopsis,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppTheme.textSecondary : AppTheme.textDark,
                height: 1.6,
                letterSpacing: 0.3,
              ),
              maxLines: _maxLines,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              synopsis,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppTheme.textSecondary : AppTheme.textDark,
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
          ),

          // Read More/Less button
          if (synopsis.length > 150) ...[
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
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
                      _isExpanded ? 'Read Less' : 'Read More',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
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
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
