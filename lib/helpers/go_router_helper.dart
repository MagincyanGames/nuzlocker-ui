import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoRouterHelper {
  /// Safely navigate back if possible, otherwise go to the provided fallback route
  static void safeBack(BuildContext context, String fallbackRoute) {
    final router = GoRouter.of(context);
    
    try {
      if (router.canPop()) {
        context.pop();
      } else {
        // If GoRouter can't pop, try Navigator
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        } else {
          // Last resort - go to fallback route
          context.push(fallbackRoute);
        }
      }
    } catch (e) {
      // Handle any errors by going to the fallback route
      debugPrint('Navigation error: $e');
      context.push(fallbackRoute);
    }
  }

  /// Navigate to a named route and clear history
  static void goAndRemoveHistory(BuildContext context, String route) {
    context.push(route);
  }
}