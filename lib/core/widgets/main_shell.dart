import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import 'app_bottom_nav_bar.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  static int indexFromPath(String path) {
    if (path.startsWith(AppRoutes.seeAllEvents)) return 1;
    if (path.startsWith(AppRoutes.map)) return 2;
    if (path.startsWith(AppRoutes.profile)) return 3;
    return 0;
  }

  void _onTabTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.seeAllEvents);
        break;
      case 2:
        context.go(AppRoutes.map);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final currentIndex = indexFromPath(path);

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTabTap(context, index),
      ),
    );
  }
}
