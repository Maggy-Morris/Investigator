import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:luminalens/authentication/auth_bloc/app_bloc.dart';
import 'package:luminalens/authentication/authentication_repository.dart';
import 'package:luminalens/bloc_observer.dart';
import 'package:luminalens/core/widgets/no_animation_page.dart';
import 'package:luminalens/presentation/add_camera/bloc/home_bloc.dart';
import 'package:luminalens/presentation/login/view/login_page.dart';
import 'package:luminalens/presentation/standard_layout/bloc/standard_layout_cubit.dart';
import 'package:luminalens/routes.dart';
import 'package:luminalens/theme.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:routemaster/routemaster.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  final AuthenticationRepository authenticationRepository =
      await AuthenticationRepository.getInstance();

  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
        Locale('es'),
        Locale('it'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      useOnlyLangCode: true,
      child: MyApp(
        authenticationRepository: authenticationRepository,
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (_) => StandardLayoutCubit(),
          ),
          BlocProvider(
            create: (_) => HomeBloc(),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  final RouteInformationProvider? routeInformationProvider;
  final bool siteBlockedWithoutLogin;

  AppView({
    super.key,
    this.siteBlockedWithoutLogin = true,
    this.routeInformationProvider,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: OverlaySupport.global(
            child: MaterialApp.router(
              // title: "Intelligence".tr(),
              title: "Luminalens",
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              builder: EasyLoading.init(),
              theme: theme,
              routeInformationParser: const RoutemasterParser(),
              routeInformationProvider: routeInformationProvider,
              routerDelegate: RoutemasterDelegate(
                observers: [MyObserver()],
                routesBuilder: (context) {
                  final state = AppBloc.get(context).state;
                  debugPrint("authenticated");

                  return siteBlockedWithoutLogin &&
                          state.status != AppStatus.authenticated
                      ? loggedOutRouteMap
                      : _buildRouteMap(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  final loggedOutRouteMap = RouteMap(
    // onUnknownRoute: (path) {
    //   return const Redirect("/");
    // },
    routes: {
      '/': (route) => const NoAnimationPage(child: LoginPage()),
    },
  );
}

class MyObserver extends RoutemasterObserver {
  // RoutemasterObserver extends NavigatorObserver and
  // receives all nested Navigator events
  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint('Popped a route');
  }

  // Routemaster-specific observer method
  @override
  void didChangeRoute(RouteData routeData, Page page) {
    List<String> routesList = AuthenticationRepository.sharedUser
            ?.getStringList(AuthenticationRepository.routesCacheKey) ??
        [];
    if (routesList.contains(routeData.path) == false &&
        routesList.contains(
                "${routeData.path}?${routeData.queryParameters["id"]}") ==
            false) {
      if (routeData.queryParameters["id"] != null) {
        routesList.add("${routeData.path}?${routeData.queryParameters["id"]}");
      } else {
        routesList.add(routeData.publicPath);
      }
    }

    AuthenticationRepository.sharedUser
        ?.setStringList(AuthenticationRepository.routesCacheKey, routesList);
    debugPrint('New route: ${routeData.path}');
  }
}

RouteMap _buildRouteMap(BuildContext context) {
  return RouteMap(
    onUnknownRoute: (path) {
      return NoAnimationPage(
        child: Scaffold(
          // title: 'Page not found',
          body: Center(
            child: Text(
              "Couldn't find page '$path'",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ),
      );
    },
    routes: checkAuthority(),
  );
}
