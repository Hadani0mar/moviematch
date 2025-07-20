import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/movie_grid_widget.dart';
import './widgets/search_bar_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounceTimer;

  List<Map<String, dynamic>> _searchResults = [];
  List<String> _recentSearches = [];
  List<String> _trendingQueries = [];
  Map<String, dynamic> _activeFilters = {};
  Set<int> _selectedMovies = {};

  bool _isLoading = false;
  bool _showSuggestions = false;
  bool _isSelectionMode = false;
  String _currentQuery = '';

  // Mock data
  final List<Map<String, dynamic>> _mockMovies = [
    {
      "id": 1,
      "title": "The Dark Knight",
      "poster_url":
          "https://images.unsplash.com/photo-1489599511986-c2d9e8b1b5c1?w=400&h=600&fit=crop",
      "rating": 9.0,
      "year": 2008,
      "genres": ["Action", "Crime", "Drama"],
      "overview":
          "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice."
    },
    {
      "id": 2,
      "title": "Inception",
      "poster_url":
          "https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=400&h=600&fit=crop",
      "rating": 8.8,
      "year": 2010,
      "genres": ["Action", "Science Fiction", "Thriller"],
      "overview":
          "Dom Cobb is a skilled thief, the absolute best in the dangerous art of extraction, stealing valuable secrets from deep within the subconscious during the dream state."
    },
    {
      "id": 3,
      "title": "Interstellar",
      "poster_url":
          "https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=400&h=600&fit=crop",
      "rating": 8.6,
      "year": 2014,
      "genres": ["Adventure", "Drama", "Science Fiction"],
      "overview":
          "The adventures of a group of explorers who make use of a newly discovered wormhole to surpass the limitations on human space travel and conquer the vast distances involved in an interstellar voyage."
    },
    {
      "id": 4,
      "title": "The Matrix",
      "poster_url":
          "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
      "rating": 8.7,
      "year": 1999,
      "genres": ["Action", "Science Fiction"],
      "overview":
          "A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers."
    },
    {
      "id": 5,
      "title": "Pulp Fiction",
      "poster_url":
          "https://images.unsplash.com/photo-1489599511986-c2d9e8b1b5c1?w=400&h=600&fit=crop",
      "rating": 8.9,
      "year": 1994,
      "genres": ["Crime", "Drama"],
      "overview":
          "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption."
    },
    {
      "id": 6,
      "title": "Avatar",
      "poster_url":
          "https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=400&h=600&fit=crop",
      "rating": 7.8,
      "year": 2009,
      "genres": ["Action", "Adventure", "Fantasy"],
      "overview":
          "A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home."
    },
    {
      "id": 7,
      "title": "The Godfather",
      "poster_url":
          "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
      "rating": 9.2,
      "year": 1972,
      "genres": ["Crime", "Drama"],
      "overview":
          "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son."
    },
    {
      "id": 8,
      "title": "Titanic",
      "poster_url":
          "https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=400&h=600&fit=crop",
      "rating": 7.8,
      "year": 1997,
      "genres": ["Drama", "Romance"],
      "overview":
          "A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic."
    },
    {
      "id": 9,
      "title": "The Avengers",
      "poster_url":
          "https://images.unsplash.com/photo-1489599511986-c2d9e8b1b5c1?w=400&h=600&fit=crop",
      "rating": 8.0,
      "year": 2012,
      "genres": ["Action", "Adventure", "Science Fiction"],
      "overview":
          "Earth's mightiest heroes must come together and learn to fight as a team if they are going to stop the mischievous Loki and his alien army from enslaving humanity."
    },
    {
      "id": 10,
      "title": "Forrest Gump",
      "poster_url":
          "https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=400&h=600&fit=crop",
      "rating": 8.8,
      "year": 1994,
      "genres": ["Comedy", "Drama", "Romance"],
      "overview":
          "The presidencies of Kennedy and Johnson, the events of Vietnam, Watergate and other historical events unfold from the perspective of an Alabama man with an IQ of 75."
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _initializeData() {
    _recentSearches = ['Avengers', 'Batman', 'Marvel'];
    _trendingQueries = [
      'Spider-Man',
      'Star Wars',
      'Horror Movies',
      'Comedy 2024'
    ];
    _searchResults = List.from(_mockMovies);
  }

  void _onScroll() {
    if (_scrollController.position.pixels > 100) {
      FocusScope.of(context).unfocus();
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _currentQuery = query;
      _showSuggestions = query.isNotEmpty;
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = List.from(_mockMovies);
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Filter movies based on search query and active filters
    List<Map<String, dynamic>> filteredResults = _mockMovies.where((movie) {
      // Text search
      final titleMatch = (movie['title'] as String)
          .toLowerCase()
          .contains(query.toLowerCase());
      final genreMatch = (movie['genres'] as List).any((genre) =>
          (genre as String).toLowerCase().contains(query.toLowerCase()));

      if (!titleMatch && !genreMatch) return false;

      // Apply filters
      if (_activeFilters['genres'] != null &&
          (_activeFilters['genres'] as List).isNotEmpty) {
        final movieGenres = movie['genres'] as List<String>;
        final filterGenres = _activeFilters['genres'] as List<String>;
        if (!filterGenres.any((genre) => movieGenres.contains(genre))) {
          return false;
        }
      }

      if (_activeFilters['yearRange'] != null) {
        final yearRange = _activeFilters['yearRange'] as RangeValues;
        final movieYear = movie['year'] as int;
        if (movieYear < yearRange.start || movieYear > yearRange.end) {
          return false;
        }
      }

      if (_activeFilters['minRating'] != null) {
        final minRating = _activeFilters['minRating'] as double;
        final movieRating = movie['rating'] as double;
        if (movieRating < minRating) {
          return false;
        }
      }

      return true;
    }).toList();

    // Apply sorting
    if (_activeFilters['sortBy'] != null) {
      final sortBy = _activeFilters['sortBy'] as String;
      switch (sortBy) {
        case 'rating':
          filteredResults.sort((a, b) =>
              (b['rating'] as double).compareTo(a['rating'] as double));
          break;
        case 'release_date':
          filteredResults
              .sort((a, b) => (b['year'] as int).compareTo(a['year'] as int));
          break;
        case 'title':
          filteredResults.sort(
              (a, b) => (a['title'] as String).compareTo(b['title'] as String));
          break;
        default:
          // Keep original order for popularity
          break;
      }
    }

    setState(() {
      _searchResults = filteredResults;
      _isLoading = false;
    });

    // Add to recent searches if not empty and not already present
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches = _recentSearches.take(5).toList();
        }
      });
    }
  }

  void _onVoiceSearch() {
    // Simulate voice search result
    const voiceQuery = "action movies";
    _searchController.text = voiceQuery;
    _onSearchChanged(voiceQuery);
  }

  void _onFilterTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        currentFilters: _activeFilters,
        onApplyFilters: _applyFilters,
      ),
    );
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
    });
    _performSearch(_currentQuery);
  }

  void _onRemoveFilter(String filterKey) {
    setState(() {
      if (filterKey.startsWith('genre_')) {
        final genre = filterKey.substring(6);
        final genres = List<String>.from(_activeFilters['genres'] ?? []);
        genres.remove(genre);
        _activeFilters['genres'] = genres;
      } else {
        _activeFilters.remove(filterKey);
      }
    });
    _performSearch(_currentQuery);
  }

  void _onClearAllFilters() {
    setState(() {
      _activeFilters.clear();
    });
    _performSearch(_currentQuery);
  }

  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _onSearchChanged(suggestion);
    FocusScope.of(context).unfocus();
    setState(() {
      _showSuggestions = false;
    });
  }

  void _onMovieTap(Map<String, dynamic> movie) {
    if (_isSelectionMode) {
      _toggleMovieSelection(movie);
    } else {
      Navigator.pushNamed(context, '/movie-detail-screen', arguments: movie);
    }
  }

  void _onMovieLongPress(Map<String, dynamic> movie) {
    setState(() {
      _isSelectionMode = true;
    });
    _toggleMovieSelection(movie);
  }

  void _toggleMovieSelection(Map<String, dynamic> movie) {
    setState(() {
      final movieId = movie['id'] as int;
      if (_selectedMovies.contains(movieId)) {
        _selectedMovies.remove(movieId);
      } else {
        _selectedMovies.add(movieId);
      }

      if (_selectedMovies.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedMovies.clear();
    });
  }

  void _addSelectedToWatchlist() {
    // Simulate adding to watchlist
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('success.added_to_watchlist'
            .tr(args: ['${_selectedMovies.length}'])),
        backgroundColor: AppTheme.primaryRed,
      ),
    );
    _exitSelectionMode();
  }

  Widget _buildAppBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isSelectionMode) {
      return AppBar(
        backgroundColor:
            isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: _exitSelectionMode,
          icon: CustomIconWidget(
            iconName: 'close',
            color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
            size: 24,
          ),
        ),
        title: Text(
          'search.selected'.tr(args: ['${_selectedMovies.length}']),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: _addSelectedToWatchlist,
            icon: CustomIconWidget(
              iconName: 'playlist_add',
              color: AppTheme.primaryRed,
              size: 24,
            ),
          ),
        ],
      );
    }

    return AppBar(
      backgroundColor:
          isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
          size: 24,
        ),
      ),
      title: Text(
        'search.title'.tr(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: [
        IconButton(
          onPressed: () {
            _searchController.clear();
            setState(() {
              _currentQuery = '';
              _searchResults = List.from(_mockMovies);
              _showSuggestions = false;
            });
          },
          icon: CustomIconWidget(
            iconName: 'clear',
            color: isDark
                ? AppTheme.textSecondary
                : AppTheme.textMediumEmphasisLight,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryRed),
            ),
            SizedBox(height: 2.h),
            Text(
              'search.searching'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (_currentQuery.isEmpty) {
      return EmptyStateWidget(
        type: 'empty_search',
        trendingMovies: _mockMovies.take(6).toList(),
        popularGenres: [
          'filters.genre_list.action'.tr(),
          'filters.genre_list.comedy'.tr(),
          'filters.genre_list.drama'.tr(),
          'filters.genre_list.horror'.tr(),
          'filters.genre_list.science_fiction'.tr(),
          'filters.genre_list.romance'.tr(),
        ],
        onGenreTap: _onSuggestionTap,
      );
    }

    if (_searchResults.isEmpty) {
      return EmptyStateWidget(
        type: 'no_results',
        searchQuery: _currentQuery,
        onClearFilters: _activeFilters.isNotEmpty ? _onClearAllFilters : null,
        onGenreTap: _onSuggestionTap,
      );
    }

    return MovieGridWidget(
      movies: _searchResults,
      onMovieTap: _onMovieTap,
      onMovieLongPress: _onMovieLongPress,
      selectedMovies: _selectedMovies,
      isSelectionMode: _isSelectionMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _buildAppBar(),
      ),
      body: Column(
        children: [
          SearchBarWidget(
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            onVoiceSearch: _onVoiceSearch,
            onFilterTap: _onFilterTap,
            recentSearches: _recentSearches,
            trendingQueries: _trendingQueries,
            showSuggestions: _showSuggestions,
            onSuggestionTap: _onSuggestionTap,
          ),
          FilterChipsWidget(
            activeFilters: _activeFilters,
            onRemoveFilter: _onRemoveFilter,
            onClearAll: _onClearAllFilters,
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }
}
