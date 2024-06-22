import 'package:chatapp/dashboard_screen.dart';
import 'package:chatapp/features/auth/screens/user_information_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:chatapp/features/auth/screens/login_screen.dart';
import 'package:chatapp/features/auth/screens/otp_screen.dart';
import 'package:chatapp/features/landing/landing_screen.dart';

class RouterConfiguration {
  static final GoRouter router = GoRouter(
    initialLocation: landingScreen,
    routes: <RouteBase>[
      GoRoute(
        name: landingScreen,
        path: landingScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const LandingScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            name: loginScreen,
            path: loginScreen,
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            },
          ),
          GoRoute(
            name: otpScreen,
            path: otpScreen,
            builder: (BuildContext context, GoRouterState state) {
              final verificationId = state.extra as String;
              return OTPScreen(
                verificationId: verificationId,
              );
            },
          ),
          GoRoute(
            name: userInfoScreen,
            path: userInfoScreen,
            builder: (BuildContext context, GoRouterState state) {
              return const UserInformationScreen();
            },
          ),
          GoRoute(
            name: dashboardScreen,
            path: dashboardScreen,
            builder: (BuildContext context, GoRouterState state) {
              return const DashboardScreen();
            },
          ),
        ],
      ),
    ],
  );

  static String landingScreen = '/';
  static String loginScreen = 'login';
  static String otpScreen = 'otp';
  static String userInfoScreen = 'user_info';
  static String dashboardScreen = 'dashboard';
}
