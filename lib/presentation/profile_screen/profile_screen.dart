import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/user_avatar_widget.dart';
import './widgets/user_stats_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkTheme = true;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  String _selectedLanguage = 'English';
  int _currentIndex = 4; // Profile tab active

  // Mock user data
  final Map<String, dynamic> _userData = {
    "username": "Ahmed Hassan",
    "email": "ahmed.hassan@email.com",
    "avatar":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
    "moviesWatched": 127,
    "watchlistCount": 23,
    "favoriteGenres": ["Action", "Sci-Fi", "Thriller", "Drama"],
  };

  final List<Map<String, dynamic>> _recentlyWatched = [
    {
      "id": 1,
      "title": "Dune: Part Two",
      "poster":
          "https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=300&h=450&fit=crop",
    },
    {
      "id": 2,
      "title": "Oppenheimer",
      "poster":
          "https://images.unsplash.com/photo-1489599735734-79b4f9ab7b34?w=300&h=450&fit=crop",
    },
    {
      "id": 3,
      "title": "The Batman",
      "poster":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=450&fit=crop",
    },
    {
      "id": 4,
      "title": "Top Gun: Maverick",
      "poster":
          "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=300&h=450&fit=crop",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
        child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
                child: CustomScrollView(slivers: [
              SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  pinned: true,
                  expandedHeight: 20.h,
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                          iconName: 'arrow_back',
                          color: _isDarkMode
                              ? AppTheme.textPrimary
                              : AppTheme.textDark,
                          size: 24)),
                  title: Text('profile.title'.tr(),
                      style: Theme.of(context).textTheme.titleMedium),
                  actions: [
                    IconButton(
                        onPressed: () {
                          // Navigate to settings
                        },
                        icon: CustomIconWidget(
                            iconName: 'settings',
                            color: _isDarkMode
                                ? AppTheme.textPrimary
                                : AppTheme.textDark,
                            size: 24)),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                          padding:
                              EdgeInsets.only(top: 8.h, left: 4.w, right: 4.w),
                          child: UserAvatarWidget(
                              avatarUrl: _userProfile['avatar_url'])))),
              SliverToBoxAdapter(child: _buildUserStatsSection()),
              SliverToBoxAdapter(child: _buildQuickActionsSection()),
              SliverToBoxAdapter(child: _buildSettingsSection()),
            ]))));
  }

  Widget _buildUserStatsSection() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: UserStatsWidget(moviesWatched: _userStats['movies_watched']));
  }

  Widget _buildQuickActionsSection() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: QuickActionsWidget());
  }

  Widget _buildSettingsSection() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child:
            SettingsSectionWidget(notificationsEnabled: _notificationsEnabled));
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-screen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search-screen');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/movie-categories-screen');
        break;
      case 3:
        // Navigate to watchlist (would be implemented in home screen)
        Navigator.pushReplacementNamed(context, '/home-screen');
        break;
      case 4:
        // Already on profile screen
        break;
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
    // In a real app, this would update the app's theme
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Theme switched to ${_isDarkTheme ? 'Dark' : 'Light'} mode'),
        duration: const Duration(seconds: 2)));
  }

  void _onLanguagePressed() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Select Language'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                  title: const Text('English'),
                  leading: Radio<String>(
                      value: 'English',
                      groupValue: _selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                        Navigator.pop(context);
                      })),
              ListTile(
                  title: const Text('العربية'),
                  leading: Radio<String>(
                      value: 'العربية',
                      groupValue: _selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                        Navigator.pop(context);
                      })),
            ])));
  }

  void _onNotificationToggle(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Notifications ${value ? 'enabled' : 'disabled'}'),
        duration: const Duration(seconds: 2)));
  }

  void _onBiometricToggle(bool value) {
    setState(() {
      _biometricEnabled = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Biometric authentication ${value ? 'enabled' : 'disabled'}'),
        duration: const Duration(seconds: 2)));
  }

  void _onEditProfilePressed() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Edit Profile feature coming soon'),
        duration: Duration(seconds: 2)));
  }

  void _onEditAvatarPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: AppTheme.primaryRed,
                      size: 6.w),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Camera feature coming soon'),
                        duration: Duration(seconds: 2)));
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'photo_library',
                      color: AppTheme.primaryRed,
                      size: 6.w),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Gallery feature coming soon'),
                        duration: Duration(seconds: 2)));
                  }),
            ])));
  }

  void _onChangePasswordPressed() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Change Password feature coming soon'),
        duration: Duration(seconds: 2)));
  }

  void _onDataUsagePressed() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Data Usage'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cache Size: 245 MB'),
                      SizedBox(height: 2.h),
                      Text('Downloaded Movies: 3.2 GB'),
                      SizedBox(height: 2.h),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Cache cleared successfully'),
                                    duration: Duration(seconds: 2)));
                          },
                          child: const Text('Clear Cache')),
                    ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close')),
                ]));
  }

  void _onAboutPressed() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('About MovieMatch'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Version: 1.0.0'),
                      SizedBox(height: 1.h),
                      Text('Developer: Bn0marDev'),
                      SizedBox(height: 1.h),
                      Text('A Netflix-inspired movie discovery app'),
                      SizedBox(height: 2.h),
                      Text('© 2025 Bn0marDev. All rights reserved.'),
                    ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close')),
                ]));
  }

  void _onPrivacyPressed() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Privacy Policy feature coming soon'),
        duration: Duration(seconds: 2)));
  }

  void _onSettingsPressed() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Advanced Settings feature coming soon'),
        duration: Duration(seconds: 2)));
  }

  void _onViewHistoryPressed() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Viewing History feature coming soon'),
        duration: Duration(seconds: 2)));
  }

  void _onSignOutPressed() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Sign Out'),
                content: const Text('Are you sure you want to sign out?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, '/splash-screen');
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Sign Out')),
                ]));
  }
}
