import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/cast_carousel_widget.dart';
import './widgets/movie_hero_section_widget.dart';
import './widgets/ratings_section_widget.dart';
import './widgets/related_movies_widget.dart';
import './widgets/synopsis_section_widget.dart';
import './widgets/trailer_section_widget.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late ScrollController _scrollController;
  bool _isAppBarVisible = false;
  bool _isInWatchlist = false;

  // Mock movie data
  final Map<String, dynamic> _movieData = {
    "id": 1,
    "title": "The Cinematic Journey",
    "synopsis":
        """A breathtaking adventure that takes viewers on an emotional rollercoaster through stunning landscapes and compelling characters. This masterpiece combines exceptional storytelling with groundbreaking cinematography to create an unforgettable experience. The film explores themes of love, loss, and redemption while delivering spectacular action sequences that will keep you on the edge of your seat. With outstanding performances from a stellar cast and a soundtrack that perfectly complements every scene, this movie sets a new standard for modern cinema.""",
    "overview":
        "A breathtaking adventure that takes viewers on an emotional rollercoaster through stunning landscapes and compelling characters.",
    "poster_url":
        "https://images.unsplash.com/photo-1489599511986-c2d6e6b5b6b8?w=400&h=600&fit=crop",
    "backdrop_url":
        "https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=800&h=450&fit=crop",
    "rating": 8.7,
    "imdb_rating": 8.9,
    "vote_count": 125430,
    "release_year": 2024,
    "runtime": 142,
    "genres": ["Action", "Adventure", "Drama"],
    "trailer_url": "https://example.com/trailer.mp4",
    "cast": [
      {
        "name": "Emma Stone",
        "character": "Sarah Mitchell",
        "profile_path":
            "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=200&h=300&fit=crop",
      },
      {
        "name": "Ryan Gosling",
        "character": "David Chen",
        "profile_path":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=300&fit=crop",
      },
      {
        "name": "Margot Robbie",
        "character": "Lisa Rodriguez",
        "profile_path":
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=300&fit=crop",
      },
      {
        "name": "Michael B. Jordan",
        "character": "Marcus Thompson",
        "profile_path":
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=300&fit=crop",
      },
      {
        "name": "Zendaya",
        "character": "Maya Patel",
        "profile_path":
            "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=300&fit=crop",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bool shouldShowAppBar = _scrollController.offset > 200;
    if (shouldShowAppBar != _isAppBarVisible) {
      setState(() {
        _isAppBarVisible = shouldShowAppBar;
      });
    }
  }

  void _handleWatchlistToggle() {
    HapticFeedback.lightImpact();
    setState(() {
      _isInWatchlist = !_isInWatchlist;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isInWatchlist ? 'Added to Watchlist' : 'Removed from Watchlist',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleWatchedToggle() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Marked as Watched'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleShare() {
    HapticFeedback.selectionClick();

    // Mock share functionality
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildShareBottomSheet(),
    );
  }

  Widget _buildShareBottomSheet() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            'Share Movie',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          // Share options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareOption('message', 'Messages', isDark),
              _buildShareOption('email', 'Email', isDark),
              _buildShareOption('link', 'Copy Link', isDark),
              _buildShareOption('more_horiz', 'More', isDark),
            ],
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildShareOption(String iconName, String label, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Shared via $label'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight,
                width: 1,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: isDark
                    ? AppTheme.textSecondary
                    : AppTheme.textMediumEmphasisLight,
                size: 24,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.captionTextStyle(
              isLight: !isDark,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: _isAppBarVisible
            ? (isDark ? AppTheme.darkBackground : AppTheme.lightBackground)
                .withValues(alpha: 0.95)
            : Colors.transparent,
        elevation: _isAppBarVisible ? 1 : 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.textPrimary,
                size: 24,
              ),
            ),
          ),
        ),
        title: _isAppBarVisible
            ? Text(
                _movieData['title'] ?? 'Movie Details',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
        actions: [
          GestureDetector(
            onTap: _handleShare,
            child: Container(
              margin: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.textPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero section
          SliverToBoxAdapter(
            child: MovieHeroSectionWidget(movieData: _movieData),
          ),

          // Action buttons
          SliverToBoxAdapter(
            child: ActionButtonsWidget(
              movieData: _movieData,
              onWatchlistToggle: _handleWatchlistToggle,
              onWatchedToggle: _handleWatchedToggle,
              onShare: _handleShare,
            ),
          ),

          // Synopsis section
          SliverToBoxAdapter(
            child: SynopsisSectionWidget(movieData: _movieData),
          ),

          // Cast carousel
          SliverToBoxAdapter(
            child: CastCarouselWidget(movieData: _movieData),
          ),

          // Ratings section
          SliverToBoxAdapter(
            child: RatingsSectionWidget(movieData: _movieData),
          ),

          // Trailer section
          SliverToBoxAdapter(
            child: TrailerSectionWidget(movieData: _movieData),
          ),

          // Related movies
          SliverToBoxAdapter(
            child: RelatedMoviesWidget(movieData: _movieData),
          ),

          // Bottom spacing
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
        ],
      ),

      // Floating action button for quick watchlist toggle
      floatingActionButton: FloatingActionButton(
        onPressed: _handleWatchlistToggle,
        backgroundColor:
            _isInWatchlist ? AppTheme.accentGold : AppTheme.primaryRed,
        child: CustomIconWidget(
          iconName: _isInWatchlist ? 'bookmark' : 'bookmark_border',
          color: _isInWatchlist ? AppTheme.textDark : AppTheme.textPrimary,
          size: 24,
        ),
      ),
    );
  }
}
