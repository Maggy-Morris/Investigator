import 'package:flutter/material.dart';
import 'package:luminalens/presentation/add_camera/screens/add_camera_screen.dart';
import 'package:luminalens/presentation/all_cameras/screens/all_cameras.dart';
import 'package:luminalens/presentation/all_cameras/screens/camera_details.dart';
import 'package:luminalens/presentation/apply_model/screens/apply_model.dart';
import 'package:luminalens/presentation/dashboard/screens/dashboard_screen.dart';
import 'package:luminalens/presentation/login/view/login_page.dart';
import 'package:routemaster/routemaster.dart';

import 'authentication/authentication_repository.dart';
import 'core/widgets/no_animation_page.dart';

checkAuthority() {
  String userPermission =
      AuthenticationRepository.instance.currentUser.authentication ?? "";
  if ((userPermission.isNotEmpty)) {
    return getRoutesAdmin();
  } else {
    return getRoutesAdmin();
  }
}

/// get routes
///
getRoutesAdmin() {
  Map<String, RouteSettings Function(RouteData)> adminRoutes = {
    '/': (route) => const NoAnimationPage(child: DashboardScreen()),
    '/allCameras': (route) => const NoAnimationPage(child: AllCamerasScreen()),
    '/cameraDetails': (route) => NoAnimationPage(child: CameraDetails(cameraName: route.queryParameters["name"] ?? "",)),
    '/addCamera': (route) => const NoAnimationPage(child: AddCameraScreen()),
    '/applyModel': (route) => const NoAnimationPage(child: ApplyModelScreen()),
  };
  return adminRoutes;
}

getLoginRoute() {
  Map<String, RouteSettings Function(RouteData)> loginRoute = {
    '/': (route) => const NoAnimationPage(child: LoginPage()),
  };
  return loginRoute;
}
