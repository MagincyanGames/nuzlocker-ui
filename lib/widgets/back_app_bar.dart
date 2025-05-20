import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final String fallbackRoute;

  const BackAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.fallbackRoute = '/',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Improved back navigation
          final router = GoRouter.of(context);

          // Check if we can pop in the router's history
          if (router.canPop()) {
            context.pop();
          } else {
            // If we can't pop in router history, try using the navigator directly
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              // Last resort - go to fallback route
              context.go(fallbackRoute);
            }
          }
        },
      ),
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
