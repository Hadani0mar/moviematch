import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class SettingsSectionWidget extends StatelessWidget {
  final bool isDarkTheme;
  final String selectedLanguage;
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onLanguagePressed;
  final ValueChanged<bool>? onNotificationToggle;
  final ValueChanged<bool>? onBiometricToggle;
  final VoidCallback? onEditProfilePressed;
  final VoidCallback? onChangePasswordPressed;
  final VoidCallback? onDataUsagePressed;
  final VoidCallback? onAboutPressed;
  final VoidCallback? onPrivacyPressed;
  final VoidCallback? onSignOutPressed;

  const SettingsSectionWidget({
    super.key,
    required this.isDarkTheme,
    required this.selectedLanguage,
    required this.notificationsEnabled,
    required this.biometricEnabled,
    this.onThemeToggle,
    this.onLanguagePressed,
    this.onNotificationToggle,
    this.onBiometricToggle,
    this.onEditProfilePressed,
    this.onChangePasswordPressed,
    this.onDataUsagePressed,
    this.onAboutPressed,
    this.onPrivacyPressed,
    this.onSignOutPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: Theme.of(context)
                    .dividerColor
                    .withAlpha(77), // alpha: 0.3 * 255 ≈ 77
                width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('profile.settings'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          _buildSettingsTile(
              title: 'profile.dark_mode'.tr(),
              subtitle: widget.isDarkMode ? 'مُفعل' : 'مُعطل',
              icon: 'dark_mode'),
          _buildDivider(),
          _buildSettingsTile(
              title: 'profile.notifications'.tr(),
              subtitle: widget.notificationsEnabled ? 'مُفعل' : 'مُعطل',
              icon: 'notifications'),
          _buildDivider(),
          _buildSettingsTile(
              title: 'profile.language'.tr(),
              subtitle: 'العربية',
              icon: 'language',
              onTap: widget.onLanguageChanged),
          _buildDivider(),
          _buildSettingsTile(
              title: 'profile.privacy'.tr(),
              icon: 'privacy_tip',
              onTap: widget.onPrivacyTap),
          _buildDivider(),
          _buildSettingsTile(
              title: 'profile.help'.tr(),
              icon: 'help',
              onTap: widget.onHelpTap),
          _buildDivider(),
          _buildSettingsTile(
              title: 'profile.about'.tr(),
              icon: 'info',
              onTap: widget.onAboutTap),
          _buildDivider(),
          _buildSettingsTile(
              title: 'profile.logout'.tr(),
              icon: 'logout',
              iconColor: Colors.red,
              onTap: widget.onLogoutTap),
        ]));
  }

  Widget _buildSettingsTile({
    required String title,
    required String icon,
    String? subtitle,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
        onTap: onTap,
        leading: CustomIconWidget(
            iconName: icon,
            color: iconColor ??
                (isDark
                    ? AppTheme.textSecondary
                    : AppTheme.textMediumEmphasisLight),
            size: 5.w),
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: subtitle != null
            ? Text(subtitle, style: Theme.of(context).textTheme.bodySmall)
            : null,
        trailing: (onTap != null &&
                (icon != 'logout')) // For switches, handle separately
            ? CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: isDark
                    ? AppTheme.textSecondary
                    : AppTheme.textMediumEmphasisLight,
                size: 4.w)
            : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h));
  }

  Widget _buildDivider() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
        height: 1,
        color: isDark ? AppTheme.dividerDark : AppTheme.dividerLight);
  }

  Widget _buildSignOutButton(BuildContext context, bool isDark) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: onSignOutPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.red,
                elevation: 0,
                side: const BorderSide(color: Colors.red, width: 1),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomIconWidget(
                  iconName: 'logout', color: Colors.red, size: 5.w),
              SizedBox(width: 2.w),
              Text('profile.logout'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.red)),
            ])));
  }
}
