import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/movie_categories_screen/movie_categories_screen.dart';
import '../presentation/search_screen/search_screen.dart';
import '../presentation/movie_detail_screen/movie_detail_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String profileScreen = '/profile-screen';
  static const String homeScreen = '/home-screen';
  static const String movieCategoriesScreen = '/movie-categories-screen';
  static const String searchScreen = '/search-screen';
  static const String movieDetailScreen = '/movie-detail-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    profileScreen: (context) => const ProfileScreen(),
    homeScreen: (context) => const HomeScreen(),
    movieCategoriesScreen: (context) => const MovieCategoriesScreen(),
    searchScreen: (context) => const SearchScreen(),
    movieDetailScreen: (context) => const MovieDetailScreen(),
    // TODO: Add your other routes here
  };
}
