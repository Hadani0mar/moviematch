import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final Map<String, dynamic> activeFilters;
  final Function(String) onRemoveFilter;
  final VoidCallback onClearAll;

  const FilterChipsWidget({
    super.key,
    required this.activeFilters,
    required this.onRemoveFilter,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (activeFilters.isEmpty) {
      return const SizedBox.shrink();
    }

    List<Widget> chips = [];

    // Genre filters
    if (activeFilters['genres'] != null &&
        (activeFilters['genres'] as List).isNotEmpty) {
      for (String genre in activeFilters['genres']) {
        chips.add(_buildFilterChip(
          context,
          label: genre,
          onRemove: () => onRemoveFilter('genre_$genre'),
          isDark: isDark,
        ));
      }
    }

    // Year filter
    if (activeFilters['yearRange'] != null) {
      final yearRange = activeFilters['yearRange'] as RangeValues;
      chips.add(_buildFilterChip(
        context,
        label: '${yearRange.start.round()}-${yearRange.end.round()}',
        onRemove: () => onRemoveFilter('yearRange'),
        isDark: isDark,
      ));
    }

    // Rating filter
    if (activeFilters['minRating'] != null) {
      chips.add(_buildFilterChip(
        context,
        label: '${activeFilters['minRating']}+ ⭐',
        onRemove: () => onRemoveFilter('minRating'),
        isDark: isDark,
      ));
    }

    // Sort filter
    if (activeFilters['sortBy'] != null &&
        activeFilters['sortBy'] != 'popularity') {
      chips.add(_buildFilterChip(
        context,
        label: 'Sort: ${activeFilters['sortBy']}',
        onRemove: () => onRemoveFilter('sortBy'),
        isDark: isDark,
      ));
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Filters (${chips.length})',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isDark
                          ? AppTheme.textSecondary
                          : AppTheme.textMediumEmphasisLight,
                    ),
              ),
              if (chips.length > 1)
                GestureDetector(
                  onTap: onClearAll,
                  child: Text(
                    'Clear All',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.primaryRed,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: chips,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required VoidCallback onRemove,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryRed.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.primaryRed,
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(width: 1.w),
          GestureDetector(
            onTap: onRemove,
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.primaryRed,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}
