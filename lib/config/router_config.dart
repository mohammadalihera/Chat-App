import 'package:chatapp/common/widgets/loader.dart';
import 'package:chatapp/dashboard_screen.dart';
import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:chatapp/features/auth/screens/user_information_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:chatapp/features/auth/screens/login_screen.dart';
import 'package:chatapp/features/auth/screens/otp_screen.dart';
import 'package:chatapp/features/landing/landing_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouterConfiguration.initialScreen,
    routes: <RouteBase>[
      GoRoute(
        name: RouterConfiguration.initialScreen,
        path: RouterConfiguration.initialScreen,
        builder: (BuildContext context, GoRouterState state) {
          Widget initialScreen = const LandingScreen();
          ref.watch(userDataAuthProvider).when(data: (user) {
            if (user == null) {
              initialScreen = const LandingScreen();
            }
            initialScreen = const DashboardScreen();
          }, error: (err, trace) {
            initialScreen = const LandingScreen();
          }, loading: () {
            initialScreen = const Loader();
          });
          return initialScreen;
        },
        routes: <RouteBase>[
          GoRoute(
            name: RouterConfiguration.loginScreen,
            path: RouterConfiguration.loginScreen,
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            },
          ),
          GoRoute(
            name: RouterConfiguration.otpScreen,
            path: RouterConfiguration.otpScreen,
            builder: (BuildContext context, GoRouterState state) {
              final verificationId = state.extra as String;
              return OTPScreen(
                verificationId: verificationId,
              );
            },
          ),
          GoRoute(
            name: RouterConfiguration.userInfoScreen,
            path: RouterConfiguration.userInfoScreen,
            builder: (BuildContext context, GoRouterState state) {
              return const UserInformationScreen();
            },
          ),
          GoRoute(
            name: RouterConfiguration.dashboardScreen,
            path: RouterConfiguration.dashboardScreen,
            builder: (BuildContext context, GoRouterState state) {
              return const DashboardScreen();
            },
          ),
          GoRoute(
            name: RouterConfiguration.loader,
            path: RouterConfiguration.loader,
            builder: (BuildContext context, GoRouterState state) {
              return const Loader();
            },
          ),
        ],
      ),
    ],
  );
});

class RouterConfiguration {
  static final GoRouter router = GoRouter(
    initialLocation: initialScreen,
    routes: <RouteBase>[],
  );

  static String initialScreen = '/';
  static String loginScreen = 'login';
  static String otpScreen = 'otp';
  static String userInfoScreen = 'user_info';
  static String dashboardScreen = 'dashboard';
  static String loader = 'loader';
}
