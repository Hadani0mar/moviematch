import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterModalWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterModalWidget({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late Map<String, dynamic> _tempFilters;

  final List<String> _genres = [
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'History',
    'Horror',
    'Music',
    'Mystery',
    'Romance',
    'Science Fiction',
    'TV Movie',
    'Thriller',
    'War',
    'Western'
  ];

  final List<String> _sortOptions = [
    'popularity',
    'release_date',
    'rating',
    'title',
    'revenue'
  ];

  @override
  void initState() {
    super.initState();
    _tempFilters = Map<String, dynamic>.from(widget.currentFilters);

    // Initialize default values if not present
    _tempFilters['genres'] ??= <String>[];
    _tempFilters['yearRange'] ??= const RangeValues(1990, 2024);
    _tempFilters['minRating'] ??= 0.0;
    _tempFilters['sortBy'] ??= 'popularity';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Movies',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _resetFilters,
                      child: Text(
                        'Reset',
                        style: TextStyle(color: AppTheme.primaryRed),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.onApplyFilters(_tempFilters);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: AppTheme.primaryRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGenreSection(context, isDark),
                  SizedBox(height: 3.h),
                  _buildYearSection(context, isDark),
                  SizedBox(height: 3.h),
                  _buildRatingSection(context, isDark),
                  SizedBox(height: 3.h),
                  _buildSortSection(context, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Genres',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _genres.map((genre) {
            final isSelected = (_tempFilters['genres'] as List).contains(genre);
            return GestureDetector(
              onTap: () {
                setState(() {
                  final genres = List<String>.from(_tempFilters['genres']);
                  if (isSelected) {
                    genres.remove(genre);
                  } else {
                    genres.add(genre);
                  }
                  _tempFilters['genres'] = genres;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryRed
                      : (isDark
                          ? AppTheme.darkBackground
                          : AppTheme.lightBackground),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryRed
                        : (isDark
                            ? AppTheme.dividerDark
                            : AppTheme.dividerLight),
                    width: 1,
                  ),
                ),
                child: Text(
                  genre,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppTheme.textSecondary
                                : AppTheme.textMediumEmphasisLight),
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildYearSection(BuildContext context, bool isDark) {
    final yearRange = _tempFilters['yearRange'] as RangeValues;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Release Year',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        Text(
          '${yearRange.start.round()} - ${yearRange.end.round()}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryRed,
                fontWeight: FontWeight.w500,
              ),
        ),
        RangeSlider(
          values: yearRange,
          min: 1950,
          max: 2024,
          divisions: 74,
          activeColor: AppTheme.primaryRed,
          inactiveColor: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
          onChanged: (RangeValues values) {
            setState(() {
              _tempFilters['yearRange'] = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRatingSection(BuildContext context, bool isDark) {
    final minRating = _tempFilters['minRating'] as double;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Rating',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        Row(
          children: List.generate(10, (index) {
            final rating = index + 1;
            final isSelected = rating <= minRating;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _tempFilters['minRating'] = rating.toDouble();
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 1.w),
                child: CustomIconWidget(
                  iconName: 'star',
                  color: isSelected
                      ? AppTheme.accentGold
                      : (isDark ? AppTheme.dividerDark : AppTheme.dividerLight),
                  size: 24,
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 1.h),
        Text(
          '${minRating.round()}+ stars',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryRed,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildSortSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: 1.h),
        ...(_sortOptions.map((option) {
          final isSelected = _tempFilters['sortBy'] == option;
          final displayName = option
              .replaceAll('_', ' ')
              .split(' ')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' ');

          return RadioListTile<String>(
            title: Text(
              displayName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            value: option,
            groupValue: _tempFilters['sortBy'],
            activeColor: AppTheme.primaryRed,
            onChanged: (String? value) {
              setState(() {
                _tempFilters['sortBy'] = value;
              });
            },
            contentPadding: EdgeInsets.zero,
            dense: true,
          );
        }).toList()),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _tempFilters = {
        'genres': <String>[],
        'yearRange': const RangeValues(1990, 2024),
        'minRating': 0.0,
        'sortBy': 'popularity',
      };
    });
  }
}
