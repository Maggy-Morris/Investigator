import 'package:flutter/material.dart';

import 'package:Investigator/presentation/search/screens/search_screen.dart';
// import 'package:Investigator/presentation/dashboard/screens/dashboard_screen.dart';
import 'package:Investigator/presentation/login/view/login_page.dart';
import 'package:routemaster/routemaster.dart';

import 'authentication/authentication_repository.dart';
import 'core/widgets/no_animation_page.dart';
import 'presentation/all_employees/screens/all_employees.dart';
// import 'presentation/choose_your_company/choose_your_company_screen.dart';
import 'presentation/investigator/screens/investigator_screen.dart';

checkAuthority() {
  String userPermission =
      AuthenticationRepository.instance.currentUser.token ?? "";

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
    // '/': (route) => const NoAnimationPage(child: ChooseYourCompany()),
    // '/home': (route) => const NoAnimationPage(child: DashboardScreen()),
    '/': (route) => const NoAnimationPage(
          child: AllEmployeesScreen(),
        ),
    // '/cameraDetails': (route) => NoAnimationPage(
    //         child: CameraDetails(
    //       cameraName: route.queryParameters["name"] ?? "",
    //     )),
    '/investigator': (route) => const NoAnimationPage(child: AddCameraScreen()),
    '/search': (route) => const NoAnimationPage(child: Search()),
  };
  return adminRoutes;
}

getLoginRoute() {
  Map<String, RouteSettings Function(RouteData)> loginRoute = {
    '/': (route) => const NoAnimationPage(child: LoginPage()),
    // '/': (route) =>
    //     const NoAnimationPage(child: ChooseYourCompany()),
  };
  return loginRoute;
}
