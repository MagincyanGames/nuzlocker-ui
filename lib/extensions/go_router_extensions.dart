import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GoRouterExtensions on BuildContext {
  /// Custom implementation of popUntil for GoRouter
  /// Repeatedly pops the navigator until a route with the given name is found
  bool popUntilNamed(String routeName) {
    // Get the current router
    final router = GoRouter.of(this);
    
    // Store if we found the route
    var foundRoute = false;
    
    // Check if we can pop at all
    if (!router.canPop()) {
      return false;
    }
    
    // Get current location
    final currentLocation = router.routeInformationProvider.value.uri.toString();
    
    // Find the target route in our routes
    final targetLocation = '/$routeName';
    
    debugPrint('Current: $currentLocation, Target: $targetLocation');
    
    // If we're already at the target, nothing to do
    if (currentLocation == targetLocation) {
      return true;
    }
    
    // Try to pop until we can't or find our route
    while (router.canPop()) {
      router.pop();
      
      // Check if we're at the desired route after popping
      final newLocation = router.routeInformationProvider.value.uri.toString();
      debugPrint('Popped to: $newLocation');
      
      if (newLocation == targetLocation || newLocation.contains(targetLocation)) {
        foundRoute = true;
        break;
      }
      
      // Safety check to avoid infinite loops
      if (!router.canPop()) {
        break;
      }
    }
    
    // If we didn't find the route by popping, navigate to it directly
    if (!foundRoute) {
      router.go(targetLocation);
      return true;
    }
    
    return foundRoute;
  }
}