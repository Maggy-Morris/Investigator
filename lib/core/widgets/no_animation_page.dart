import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class NoAnimationPage<T> extends TransitionPage<T> {
  const NoAnimationPage({required Widget child})
      : super(
    child: child,
    pushTransition: PageTransition.none,
    popTransition: PageTransition.none,
  );
}