import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum ViewMode { grid, list }

class ViewToggleWidget extends StatelessWidget {
  final ViewMode currentMode;
  final Function(ViewMode) onModeChanged;

  const ViewToggleWidget({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            context: context,
            mode: ViewMode.grid,
            icon: 'grid_view',
            label: 'Grid',
            isSelected: currentMode == ViewMode.grid,
            isDark: isDark,
          ),
          SizedBox(width: 1.w),
          _buildToggleButton(
            context: context,
            mode: ViewMode.list,
            icon: 'list',
            label: 'List',
            isSelected: currentMode == ViewMode.list,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required BuildContext context,
    required ViewMode mode,
    required String icon,
    required String label,
    required bool isSelected,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => onModeChanged(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryRed : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isSelected
                  ? AppTheme.textPrimary
                  : (isDark
                      ? AppTheme.textSecondary
                      : AppTheme.textMediumEmphasisLight),
              size: 18,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.textPrimary
                        : (isDark
                            ? AppTheme.textSecondary
                            : AppTheme.textMediumEmphasisLight),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
