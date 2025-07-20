import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/genre_section.dart';
import './widgets/popular_movie_list.dart';
import './widgets/recommended_movie_grid.dart';
import './widgets/theme_toggle_button.dart';
import './widgets/trending_movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentBottomNavIndex = 0;
  bool _isDarkMode = true;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  // Mock movie data
  final List<Map<String, dynamic>> _trendingMovies = [
    {
      "id": 1,
      "title": "Avatar: The Way of Water",
      "poster":
          "https://images.unsplash.com/photo-1489599162810-1d0d8d1c8b5c?w=400&h=600&fit=crop",
      "rating": 8.1,
      "year": 2022,
      "genre": "Sci-Fi",
      "description":
          "Jake Sully lives with his newfound family formed on the extrasolar moon Pandora.",
      "isInWatchlist": false,
    },
    {
      "id": 2,
      "title": "Top Gun: Maverick",
      "poster":
          "https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?w=400&h=600&fit=crop",
      "rating": 8.3,
      "year": 2022,
      "genre": "Action",
      "description":
          "After thirty years, Maverick is still pushing the envelope as a top naval aviator.",
      "isInWatchlist": true,
    },
    {
      "id": 3,
      "title": "Black Panther: Wakanda Forever",
      "poster":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=600&fit=crop",
      "rating": 7.3,
      "year": 2022,
      "genre": "Action",
      "description":
          "The people of Wakanda fight to protect their home from intervening world powers.",
      "isInWatchlist": false,
    },
    {
      "id": 4,
      "title": "The Batman",
      "poster":
          "https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?w=400&h=600&fit=crop",
      "rating": 7.8,
      "year": 2022,
      "genre": "Crime",
      "description":
          "Batman ventures into Gotham City's underworld when a sadistic killer leaves behind a trail of cryptic clues.",
      "isInWatchlist": false,
    },
  ];

  final List<Map<String, dynamic>> _recommendedMovies = [
    {
      "id": 5,
      "title": "Dune",
      "poster":
          "https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=400&h=600&fit=crop",
      "rating": 8.0,
      "year": 2021,
      "genre": "Sci-Fi",
      "description":
          "Paul Atreides leads nomadic tribes in a revolt against the galactic emperor.",
      "isInWatchlist": false,
    },
    {
      "id": 6,
      "title": "Spider-Man: No Way Home",
      "poster":
          "https://images.unsplash.com/photo-1635805737707-575885ab0820?w=400&h=600&fit=crop",
      "rating": 8.4,
      "year": 2021,
      "genre": "Action",
      "description":
          "Spider-Man seeks help from Doctor Strange to restore his secret identity.",
      "isInWatchlist": true,
    },
    {
      "id": 7,
      "title": "The Matrix Resurrections",
      "poster":
          "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
      "rating": 5.7,
      "year": 2021,
      "genre": "Sci-Fi",
      "description":
          "Neo lives a seemingly ordinary life as Thomas A. Anderson in a Matrix simulation.",
      "isInWatchlist": false,
    },
    {
      "id": 8,
      "title": "No Time to Die",
      "poster":
          "https://images.unsplash.com/photo-1489599162810-1d0d8d1c8b5c?w=400&h=600&fit=crop",
      "rating": 7.3,
      "year": 2021,
      "genre": "Action",
      "description":
          "James Bond has left active service when his friend Felix Leiter enlists his help.",
      "isInWatchlist": false,
    },
  ];

  final List<Map<String, dynamic>> _popularMovies = [
    {
      "id": 9,
      "title": "Oppenheimer",
      "poster":
          "https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=400&h=600&fit=crop",
      "rating": 8.6,
      "year": 2023,
      "genre": "Biography",
      "description":
          "The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb.",
      "isInWatchlist": false,
    },
    {
      "id": 10,
      "title": "Barbie",
      "poster":
          "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&h=600&fit=crop",
      "rating": 7.0,
      "year": 2023,
      "genre": "Comedy",
      "description":
          "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land.",
      "isInWatchlist": true,
    },
    {
      "id": 11,
      "title": "Guardians of the Galaxy Vol. 3",
      "poster":
          "https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=400&h=600&fit=crop",
      "rating": 7.9,
      "year": 2023,
      "genre": "Action",
      "description":
          "Still reeling from the loss of Gamora, Peter Quill rallies his team to defend the universe.",
      "isInWatchlist": false,
    },
    {
      "id": 12,
      "title": "Fast X",
      "poster":
          "https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?w=400&h=600&fit=crop",
      "rating": 5.8,
      "year": 2023,
      "genre": "Action",
      "description":
          "Dom Toretto and his family are targeted by the vengeful son of drug kingpin Hernan Reyes.",
      "isInWatchlist": false,
    },
    {
      "id": 13,
      "title": "John Wick: Chapter 4",
      "poster":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=600&fit=crop",
      "rating": 7.7,
      "year": 2023,
      "genre": "Action",
      "description": "John Wick uncovers a path to defeating The High Table.",
      "isInWatchlist": true,
    },
  ];

  final Map<String, List<Map<String, dynamic>>> _genreMovies = {
    "Action Movies": [
      {
        "id": 14,
        "title": "Mission: Impossible",
        "poster":
            "https://images.unsplash.com/photo-1489599162810-1d0d8d1c8b5c?w=400&h=600&fit=crop",
        "rating": 7.1,
        "year": 2023,
        "genre": "Action",
      },
      {
        "id": 15,
        "title": "Indiana Jones 5",
        "poster":
            "https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?w=400&h=600&fit=crop",
        "rating": 6.5,
        "year": 2023,
        "genre": "Adventure",
      },
      {
        "id": 16,
        "title": "Transformers: Rise",
        "poster":
            "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=600&fit=crop",
        "rating": 6.0,
        "year": 2023,
        "genre": "Action",
      },
    ],
    "Horror Movies": [
      {
        "id": 17,
        "title": "Scream VI",
        "poster":
            "https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?w=400&h=600&fit=crop",
        "rating": 6.5,
        "year": 2023,
        "genre": "Horror",
      },
      {
        "id": 18,
        "title": "Evil Dead Rise",
        "poster":
            "https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=400&h=600&fit=crop",
        "rating": 6.5,
        "year": 2023,
        "genre": "Horror",
      },
      {
        "id": 19,
        "title": "M3GAN",
        "poster":
            "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400&h=600&fit=crop",
        "rating": 6.3,
        "year": 2023,
        "genre": "Horror",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshMovies() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _navigateToMovieDetail(Map<String, dynamic> movie) {
    Navigator.pushNamed(context, '/movie-detail-screen', arguments: movie);
  }

  void _navigateToSearch() {
    Navigator.pushNamed(context, '/search-screen');
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/profile-screen');
  }

  void _navigateToCategories() {
    Navigator.pushNamed(context, '/movie-categories-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshMovies,
            color: AppTheme.primaryRed,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      _buildTrendingSection(),
                      SizedBox(height: 3.h),
                      _buildRecommendedSection(),
                      SizedBox(height: 3.h),
                      _buildPopularSection(),
                      SizedBox(height: 3.h),
                      ..._buildGenreSections(),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      flexibleSpace: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'app.name'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.primaryRed,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  'app.tagline'.tr(),
                  style: AppTheme.captionTextStyle(
                    isLight: !_isDarkMode,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ThemeToggleButton(
              isDarkMode: _isDarkMode,
              onThemeChanged: (isDark) {
                setState(() {
                  _isDarkMode = isDark;
                });
              },
            ),
            SizedBox(width: 3.w),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'notifications',
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'sections.trending_now'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 4.w),
            itemCount: _trendingMovies.length,
            itemBuilder: (context, index) {
              return TrendingMovieCard(
                movie: _trendingMovies[index],
                onTap: () => _navigateToMovieDetail(_trendingMovies[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'sections.recommended_for_you'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: _navigateToCategories,
                child: Text(
                  'sections.see_all'.tr(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.primaryRed,
                      ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        RecommendedMovieGrid(
          movies: _recommendedMovies,
          onMovieTap: _navigateToMovieDetail,
        ),
      ],
    );
  }

  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'sections.popular_movies'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: _navigateToCategories,
                child: Text(
                  'sections.see_all'.tr(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.primaryRed,
                      ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        PopularMovieList(
          movies: _popularMovies,
          onMovieTap: _navigateToMovieDetail,
        ),
      ],
    );
  }

  List<Widget> _buildGenreSections() {
    return _genreMovies.entries.map((entry) {
      return Column(
        children: [
          GenreSection(
            genreName: entry.key,
            movies: entry.value,
            onMovieTap: _navigateToMovieDetail,
            onSeeAllTap: _navigateToCategories,
          ),
          SizedBox(height: 3.h),
        ],
      );
    }).toList();
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: (index) {
        setState(() {
          _currentBottomNavIndex = index;
        });

        switch (index) {
          case 0:
            // Already on home
            break;
          case 1:
            _navigateToSearch();
            break;
          case 2:
            // Navigate to watchlist
            break;
          case 3:
            _navigateToProfile();
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: AppTheme.primaryRed,
      unselectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _currentBottomNavIndex == 0
                ? AppTheme.primaryRed
                : Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor!,
            size: 24,
          ),
          label: 'navigation.home'.tr(),
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'search',
            color: _currentBottomNavIndex == 1
                ? AppTheme.primaryRed
                : Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor!,
            size: 24,
          ),
          label: 'navigation.search'.tr(),
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'bookmark',
            color: _currentBottomNavIndex == 2
                ? AppTheme.primaryRed
                : Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor!,
            size: 24,
          ),
          label: 'navigation.watchlist'.tr(),
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentBottomNavIndex == 3
                ? AppTheme.primaryRed
                : Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor!,
            size: 24,
          ),
          label: 'navigation.profile'.tr(),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _navigateToSearch,
      backgroundColor: AppTheme.primaryRed,
      child: CustomIconWidget(
        iconName: 'search',
        color: AppTheme.textPrimary,
        size: 28,
      ),
    );
  }
}
