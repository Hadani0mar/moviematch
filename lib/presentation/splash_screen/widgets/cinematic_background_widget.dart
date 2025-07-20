import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CinematicBackgroundWidget extends StatefulWidget {
  final Widget child;

  const CinematicBackgroundWidget({
    super.key,
    required this.child,
  });

  @override
  State<CinematicBackgroundWidget> createState() =>
      _CinematicBackgroundWidgetState();
}

class _CinematicBackgroundWidgetState extends State<CinematicBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOut,
    ));

    _gradientController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      AppTheme.darkBackground,
                      AppTheme.primaryRed.withValues(
                          alpha: 0.1 + (_gradientAnimation.value * 0.1)),
                      AppTheme.darkBackground,
                    ]
                  : [
                      AppTheme.lightBackground,
                      AppTheme.primaryRed.withValues(
                          alpha: 0.05 + (_gradientAnimation.value * 0.05)),
                      AppTheme.lightBackground,
                    ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
