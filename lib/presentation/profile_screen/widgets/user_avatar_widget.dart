import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserAvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback? onEditPressed;

  const UserAvatarWidget({
    super.key,
    this.avatarUrl,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryRed,
              width: 3,
            ),
          ),
          child: ClipOval(
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? CustomImageWidget(
                    imageUrl: avatarUrl!,
                    width: 25.w,
                    height: 25.w,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color:
                        isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: isDark
                          ? AppTheme.textSecondary
                          : AppTheme.textMediumEmphasisLight,
                      size: 12.w,
                    ),
                  ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onEditPressed,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryRed,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppTheme.darkBackground
                      : AppTheme.lightBackground,
                  width: 2,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.textPrimary,
                size: 4.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
