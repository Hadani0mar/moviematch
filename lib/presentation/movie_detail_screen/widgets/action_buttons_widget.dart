import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatefulWidget {
  final Map<String, dynamic> movieData;
  final VoidCallback? onWatchlistToggle;
  final VoidCallback? onWatchedToggle;
  final VoidCallback? onShare;

  const ActionButtonsWidget({
    super.key,
    required this.movieData,
    this.onWatchlistToggle,
    this.onWatchedToggle,
    this.onShare,
  });

  @override
  State<ActionButtonsWidget> createState() => _ActionButtonsWidgetState();
}

class _ActionButtonsWidgetState extends State<ActionButtonsWidget> {
  bool _isInWatchlist = false;
  bool _isWatched = false;

  void _handleWatchlistTap() {
    HapticFeedback.lightImpact();
    setState(() {
      _isInWatchlist = !_isInWatchlist;
    });
    widget.onWatchlistToggle?.call();
  }

  void _handleWatchedTap() {
    HapticFeedback.lightImpact();
    setState(() {
      _isWatched = !_isWatched;
    });
    widget.onWatchedToggle?.call();
  }

  void _handleShareTap() {
    HapticFeedback.selectionClick();
    widget.onShare?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          // Add to Watchlist button
          Expanded(
            child: GestureDetector(
              onTap: _handleWatchlistTap,
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: _isInWatchlist
                      ? AppTheme.primaryRed
                      : (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isInWatchlist
                        ? AppTheme.primaryRed
                        : (isDark
                            ? AppTheme.dividerDark
                            : AppTheme.dividerLight),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: _isInWatchlist ? 'bookmark' : 'bookmark_border',
                      color: _isInWatchlist
                          ? AppTheme.textPrimary
                          : (isDark
                              ? AppTheme.textSecondary
                              : AppTheme.textDark),
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _isInWatchlist ? 'In Watchlist' : 'Watchlist',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: _isInWatchlist
                            ? AppTheme.textPrimary
                            : (isDark
                                ? AppTheme.textSecondary
                                : AppTheme.textDark),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Mark as Watched button
          Expanded(
            child: GestureDetector(
              onTap: _handleWatchedTap,
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: _isWatched
                      ? AppTheme.accentGold
                      : (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isWatched
                        ? AppTheme.accentGold
                        : (isDark
                            ? AppTheme.dividerDark
                            : AppTheme.dividerLight),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName:
                          _isWatched ? 'check_circle' : 'check_circle_outline',
                      color: _isWatched
                          ? AppTheme.textDark
                          : (isDark
                              ? AppTheme.textSecondary
                              : AppTheme.textDark),
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _isWatched ? 'Watched' : 'Mark Watched',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: _isWatched
                            ? AppTheme.textDark
                            : (isDark
                                ? AppTheme.textSecondary
                                : AppTheme.textDark),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Share button
          GestureDetector(
            onTap: _handleShareTap,
            child: Container(
              width: 12.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                  width: 1,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'share',
                  color: isDark ? AppTheme.textSecondary : AppTheme.textDark,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
