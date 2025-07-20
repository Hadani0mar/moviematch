import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CategorySearchWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onClear;

  const CategorySearchWidget({
    super.key,
    required this.onSearchChanged,
    required this.onClear,
  });

  @override
  State<CategorySearchWidget> createState() => _CategorySearchWidgetState();
}

class _CategorySearchWidgetState extends State<CategorySearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearchActive = false;
    });
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isSearchActive
              ? AppTheme.primaryRed
              : (isDark ? AppTheme.dividerDark : AppTheme.dividerLight),
          width: _isSearchActive ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _isSearchActive = value.isNotEmpty;
          });
          widget.onSearchChanged(value);
        },
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search movie categories...',
          hintStyle: AppTheme.captionTextStyle(
            isLight: !isDark,
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: _isSearchActive
                  ? AppTheme.primaryRed
                  : (isDark
                      ? AppTheme.textSecondary
                      : AppTheme.textMediumEmphasisLight),
              size: 20,
            ),
          ),
          suffixIcon: _isSearchActive
              ? GestureDetector(
                  onTap: _clearSearch,
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'clear',
                      color: isDark
                          ? AppTheme.textSecondary
                          : AppTheme.textMediumEmphasisLight,
                      size: 20,
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
        ),
      ),
    );
  }
}
