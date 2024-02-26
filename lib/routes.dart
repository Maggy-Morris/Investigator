import 'package:flutter/material.dart';
import 'package:Investigator/presentation/add_camera/screens/add_camera_screen.dart';
import 'package:Investigator/presentation/all_cameras/screens/all_cameras.dart';
import 'package:Investigator/presentation/all_cameras/screens/camera_details.dart';
import 'package:Investigator/presentation/apply_model/screens/apply_model.dart';
import 'package:Investigator/presentation/dashboard/screens/dashboard_screen.dart';
import 'package:Investigator/presentation/login/view/login_page.dart';
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
    '/cameraDetails': (route) => NoAnimationPage(
            child: CameraDetails(
          cameraName: route.queryParameters["name"] ?? "",
        )),
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
