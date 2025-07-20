import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onVoiceSearch;
  final VoidCallback onFilterTap;
  final List<String> recentSearches;
  final List<String> trendingQueries;
  final bool showSuggestions;
  final Function(String) onSuggestionTap;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onVoiceSearch,
    required this.onFilterTap,
    required this.recentSearches,
    required this.trendingQueries,
    required this.showSuggestions,
    required this.onSuggestionTap,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _isVoiceSearching = false;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleVoiceSearch() async {
    setState(() {
      _isVoiceSearching = true;
    });

    // Simulate voice search processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isVoiceSearching = false;
    });

    widget.onVoiceSearch();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: TextField(
              controller: widget.searchController,
              onChanged: widget.onSearchChanged,
              onTap: () {
                setState(() {
                  _isSearchFocused = true;
                });
              },
              onSubmitted: (value) {
                setState(() {
                  _isSearchFocused = false;
                });
                FocusScope.of(context).unfocus();
              },
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'search.placeholder'.tr(),
                hintStyle: AppTheme.captionTextStyle(
                  isLight: !isDark,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 3.h,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: isDark
                        ? AppTheme.textSecondary
                        : AppTheme.textMediumEmphasisLight,
                    size: 20,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.searchController.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          widget.searchController.clear();
                          widget.onSearchChanged('');
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: isDark
                              ? AppTheme.textSecondary
                              : AppTheme.textMediumEmphasisLight,
                          size: 20,
                        ),
                      ),
                    IconButton(
                      onPressed: widget.onVoiceSearch,
                      icon: CustomIconWidget(
                        iconName: 'mic',
                        color: AppTheme.primaryRed,
                        size: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onFilterTap,
                      icon: CustomIconWidget(
                        iconName: 'filter_list',
                        color:
                            isDark ? AppTheme.textPrimary : AppTheme.textDark,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.showSuggestions && _isSearchFocused) _buildSuggestions(),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(top: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.recentSearches.isNotEmpty) ...[
            Text(
              'search.recent_searches'.tr(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isDark
                        ? AppTheme.textSecondary
                        : AppTheme.textMediumEmphasisLight,
                  ),
            ),
            SizedBox(height: 1.h),
            ...widget.recentSearches.map((search) => _buildSuggestionItem(
                  search,
                  'history',
                  () => widget.onSuggestionTap(search),
                )),
            SizedBox(height: 2.h),
          ],
          Text(
            'search.trending_searches'.tr(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isDark
                      ? AppTheme.textSecondary
                      : AppTheme.textMediumEmphasisLight,
                ),
          ),
          SizedBox(height: 1.h),
          ...widget.trendingQueries.map((query) => _buildSuggestionItem(
                query,
                'trending_up',
                () => widget.onSuggestionTap(query),
              )),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String text, String icon, VoidCallback onTap) {
    return ListTile(
      dense: true,
      leading: CustomIconWidget(
        iconName: icon,
        color:
            isDark ? AppTheme.textSecondary : AppTheme.textMediumEmphasisLight,
        size: 16,
      ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: onTap,
    );
  }
}
