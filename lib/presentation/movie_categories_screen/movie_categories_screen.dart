import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/category_card_widget.dart';
import './widgets/category_list_item_widget.dart';
import './widgets/category_preview_widget.dart';
import './widgets/category_search_widget.dart';
import './widgets/loading_skeleton_widget.dart';
import './widgets/view_toggle_widget.dart' as view_toggle;

class MovieCategoriesScreen extends StatefulWidget {
  const MovieCategoriesScreen({super.key});

  @override
  State<MovieCategoriesScreen> createState() => _MovieCategoriesScreenState();
}

class _MovieCategoriesScreenState extends State<MovieCategoriesScreen> {
  view_toggle.ViewMode _currentViewMode = view_toggle.ViewMode.grid;
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  Map<String, dynamic>? _selectedCategoryPreview;

  // Mock data for movie categories
  final List<Map<String, dynamic>> _allCategories = [
    {
      "id": 1,
      "name": "Action & Adventure",
      "movieCount": 1247,
      "isTrending": true,
      "hasNewReleases": true,
      "hasHighRated": true,
      "posterCollage":
          "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "topMovies": [
        {
          "title": "Mad Max: Fury Road",
          "poster":
              "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "rating": 8.1,
          "year": 2015
        },
        {
          "title": "John Wick",
          "poster":
              "https://images.unsplash.com/photo-1440404653325-ab127d49abc1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "rating": 7.4,
          "year": 2014
        },
        {
          "title": "Mission: Impossible",
          "poster":
              "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "rating": 7.7,
          "year": 2023
        }
      ]
    },
    {
      "id": 2,
      "name": "Drama",
      "movieCount": 892,
      "isTrending": false,
      "hasNewReleases": true,
      "hasHighRated": true,
      "posterCollage":
          "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "topMovies": [
        {
          "title": "The Shawshank Redemption",
          "poster":
              "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "rating": 9.3,
          "year": 1994
        },
        {
          "title": "Forrest Gump",
          "poster":
              "https://images.unsplash.com/photo-1440404653325-ab127d49abc1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "rating": 8.8,
          "year": 1994
        }
      ]
    },
    {
      "id": 3,
      "name": "Comedy",
      "movieCount": 634,
      "isTrending": true,
      "hasNewReleases": false,
      "hasHighRated": false,
      "posterCollage":
          "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "topMovies": [
        {
          "title": "The Grand Budapest Hotel",
          "poster":
              "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "rating": 8.1,
          "year": 2014
        }
      ]
    },
    {
      "id": 4,
      "name": "Horror",
      "movieCount": 456,
      "isTrending": false,
      "hasNewReleases": true,
      "hasHighRated": false,
      "posterCollage":
          "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "topMovies": [
        {
          "title": "Hereditary",
          "poster":
              "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "rating": 7.3,
          "year": 2018
        }
      ]
    },
    {
      "id": 5,
      "name": "Science Fiction",
      "movieCount": 789,
      "isTrending": true,
      "hasNewReleases": true,
      "hasHighRated": true,
      "posterCollage":
          "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "topMovies": [
        {
          "title": "Blade Runner 2049",
          "poster":
              "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "rating": 8.0,
          "year": 2017
        }
      ]
    },
    {
      "id": 6,
      "name": "Romance",
      "movieCount": 523,
      "isTrending": false,
      "hasNewReleases": false,
      "hasHighRated": true,
      "posterCollage":
          "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "topMovies": [
        {
          "title": "The Notebook",
          "poster":
              "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "rating": 7.8,
          "year": 2004
        }
      ]
    },
    {
      "id": 7,
      "name": "Thriller",
      "movieCount": 678,
      "isTrending": false,
      "hasNewReleases": true,
      "hasHighRated": true,
      "posterCollage":
          "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "topMovies": [
        {
          "title": "Gone Girl",
          "poster":
              "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "rating": 8.1,
          "year": 2014
        }
      ]
    },
    {
      "id": 8,
      "name": "Animation",
      "movieCount": 345,
      "isTrending": true,
      "hasNewReleases": true,
      "hasHighRated": false,
      "posterCollage":
          "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "topMovies": [
        {
          "title": "Spider-Man: Into the Spider-Verse",
          "poster":
              "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
          "rating": 8.4,
          "year": 2018
        }
      ]
    }
  ];

  List<Map<String, dynamic>> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _allCategories;
    }
    return (_allCategories as List)
        .where((dynamic category) {
          final categoryMap = category as Map<String, dynamic>;
          final name = (categoryMap["name"] as String?) ?? "";
          return name.toLowerCase().contains(_searchQuery.toLowerCase());
        })
        .toList()
        .cast<Map<String, dynamic>>();
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshCategories() async {
    await _loadCategories();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
    });
  }

  void _onSearchClear() {
    setState(() {
      _searchQuery = '';
      _isSearching = false;
    });
  }

  void _onViewModeChanged(view_toggle.ViewMode mode) {
    setState(() {
      _currentViewMode = mode;
    });
  }

  void _onCategoryTap(Map<String, dynamic> category) {
    // Navigate to genre-specific movie grid
    Navigator.pushNamed(context, '/movie-detail-screen');
  }

  void _onCategoryLongPress(Map<String, dynamic> category) {
    setState(() {
      _selectedCategoryPreview = category;
    });
  }

  void _onPreviewClose() {
    setState(() {
      _selectedCategoryPreview = null;
    });
  }

  void _onPreviewViewAll() {
    _onPreviewClose();
    Navigator.pushNamed(context, '/movie-detail-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildSearchAndFilter(),
              _buildViewToggle(),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            'categories.title'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Search functionality
            },
            icon: CustomIconWidget(
              iconName: 'search',
              color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return CategorySearchWidget(
      onSearchChanged: _onSearchChanged,
      onClear: _onSearchClear,
    );
  }

  Widget _buildViewToggle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          const Spacer(),
          view_toggle.ViewToggleWidget(
            currentMode: _currentViewMode,
            onModeChanged: _onViewModeChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_filteredCategories.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshCategories,
      color: AppTheme.primaryRed,
      child: _currentViewMode == view_toggle.ViewMode.grid
          ? _buildGridView()
          : _buildListView(),
    );
  }

  Widget _buildGridView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: _filteredCategories.length,
      itemBuilder: (context, index) {
        final category = _filteredCategories[index];
        return CategoryCardWidget(
          category: category,
          onTap: () => _onCategoryTap(category),
          onLongPress: () => _onCategoryLongPress(category),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: _filteredCategories.length,
      itemBuilder: (context, index) {
        final category = _filteredCategories[index];
        return CategoryListItemWidget(
          category: category,
          onTap: () => _onCategoryTap(category),
          onLongPress: () => _onCategoryLongPress(category),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'movie_filter',
            color: isDark
                ? AppTheme.textSecondary
                : AppTheme.textMediumEmphasisLight,
            size: 64,
          ),
          SizedBox(height: 3.h),
          Text(
            'No categories found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            _isSearching
                ? 'Try searching with different keywords'
                : 'Categories will appear here',
            style: AppTheme.captionTextStyle(
              isLight: !isDark,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          if (_isSearching) ...[
            SizedBox(height: 3.h),
            TextButton(
              onPressed: _onSearchClear,
              child: Text(
                'Clear Search',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.primaryRed,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: CategoryPreviewWidget(
          category: _selectedCategoryPreview!,
          onViewAll: _onPreviewViewAll,
          onClose: _onPreviewClose,
        ),
      ),
    );
  }
}
