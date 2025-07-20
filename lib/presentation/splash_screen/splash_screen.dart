import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/cinematic_background_widget.dart';
import './widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String _loadingText = 'Initializing MovieMatch...';
  bool _hasNetworkConnection = true;
  bool _isFirstTime = true;
  bool _showRetryOption = false;

  // Mock movie data for initialization
  final List<Map<String, dynamic>> _trendingMovies = [
    {
      "id": 1,
      "title": "The Dark Knight",
      "poster":
          "https://images.unsplash.com/photo-1489599735734-79b4169c2a78?fm=jpg&q=60&w=3000",
      "rating": 9.0,
      "year": 2008,
      "genre": "Action, Crime, Drama",
      "runtime": "152 min",
    },
    {
      "id": 2,
      "title": "Inception",
      "poster":
          "https://images.pexels.com/photos/7991579/pexels-photo-7991579.jpeg",
      "rating": 8.8,
      "year": 2010,
      "genre": "Action, Sci-Fi, Thriller",
      "runtime": "148 min",
    },
    {
      "id": 3,
      "title": "Interstellar",
      "poster":
          "https://cdn.pixabay.com/photo/2016/11/29/13/14/attractive-1869761_1280.jpg",
      "rating": 8.6,
      "year": 2014,
      "genre": "Adventure, Drama, Sci-Fi",
      "runtime": "169 min",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _fadeController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Hide system status bar for immersive experience
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

      // Step 1: Check network connectivity
      await _checkNetworkConnectivity();

      // Step 2: Load user preferences
      await _loadUserPreferences();

      // Step 3: Initialize movie data
      await _initializeMovieData();

      // Step 4: Prepare navigation
      await _prepareNavigation();
    } catch (e) {
      _handleInitializationError(e);
    }
  }

  Future<void> _checkNetworkConnectivity() async {
    setState(() {
      _loadingText = 'Checking network connection...';
    });

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      _hasNetworkConnection = connectivityResult != ConnectivityResult.none;

      if (!_hasNetworkConnection) {
        setState(() {
          _loadingText = 'No internet connection detected';
        });
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      _hasNetworkConnection = false;
    }
  }

  Future<void> _loadUserPreferences() async {
    setState(() {
      _loadingText = 'Loading user preferences...';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      _isFirstTime = prefs.getBool('is_first_time') ?? true;

      // Load theme preference
      final isDarkTheme = prefs.getBool('is_dark_theme') ?? true;

      await Future.delayed(const Duration(milliseconds: 800));
    } catch (e) {
      // Handle preferences error silently
    }
  }

  Future<void> _initializeMovieData() async {
    setState(() {
      _loadingText = 'Loading movie database...';
    });

    try {
      if (_hasNetworkConnection) {
        // Simulate API call to fetch trending movies
        await _fetchTrendingMovies();
      } else {
        // Load cached movie data
        await _loadCachedMovieData();
      }

      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      // Handle movie data error
      setState(() {
        _loadingText = 'Using offline movie data...';
      });
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> _fetchTrendingMovies() async {
    // Simulate network delay and API response
    await Future.delayed(const Duration(milliseconds: 1500));

    // In real implementation, this would be an actual API call
    // For now, we use mock data to simulate successful fetch
    setState(() {
      _loadingText = 'Fetching latest movies...';
    });
  }

  Future<void> _loadCachedMovieData() async {
    setState(() {
      _loadingText = 'Loading cached movies...';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedMovies = prefs.getStringList('cached_movies') ?? [];

      if (cachedMovies.isEmpty) {
        // Store mock data as cached data
        final movieTitles =
            _trendingMovies.map((movie) => movie['title'] as String).toList();
        await prefs.setStringList('cached_movies', movieTitles);
      }
    } catch (e) {
      // Handle cache error silently
    }
  }

  Future<void> _prepareNavigation() async {
    setState(() {
      _loadingText = 'Preparing your experience...';
    });

    await Future.delayed(const Duration(milliseconds: 800));

    // Restore system UI before navigation
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (mounted) {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    if (_showRetryOption) {
      return; // Don't navigate if showing retry option
    }

    String nextRoute;

    if (!_hasNetworkConnection && _isFirstTime) {
      // First time with no network - show offline message but go to home
      nextRoute = '/home-screen';
    } else if (_isFirstTime) {
      // First time user - could go to onboarding, but for now go to home
      nextRoute = '/home-screen';
    } else {
      // Returning user - go directly to home
      nextRoute = '/home-screen';
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  void _handleInitializationError(dynamic error) {
    setState(() {
      _loadingText = 'Something went wrong';
      _showRetryOption = true;
    });
  }

  Future<void> _retryInitialization() async {
    setState(() {
      _showRetryOption = false;
      _loadingText = 'Retrying...';
    });

    await Future.delayed(const Duration(milliseconds: 500));
    await _initializeApp();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            const CinematicBackgroundWidget(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AnimatedLogoWidget(),
                  SizedBox(height: 4.h),
                  Text(
                    'splash.welcome'.tr(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'splash.discover'.tr(),
                    style: AppTheme.captionTextStyle(
                      isLight: false,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  const LoadingIndicatorWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: LoadingIndicatorWidget(
        loadingText: _loadingText,
      ),
    );
  }

  Widget _buildRetrySection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            size: 12.w,
            color: AppTheme.primaryRed,
          ),
          SizedBox(height: 2.h),
          Text(
            'Failed to initialize app',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: isDark ? AppTheme.textPrimary : AppTheme.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Please check your connection and try again',
            style: AppTheme.captionTextStyle(
              isLight: !isDark,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton.icon(
            onPressed: _retryInitialization,
            icon: CustomIconWidget(
              iconName: 'refresh',
              size: 5.w,
              color: AppTheme.textPrimary,
            ),
            label: Text(
              'Retry',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperSignature() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: (isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight)
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryRed.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'code',
            size: 4.w,
            color: AppTheme.primaryRed,
          ),
          SizedBox(width: 2.w),
          Text(
            'Developed by Bn0marDev',
            style: AppTheme.captionBoldTextStyle(
              isLight: !isDark,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
