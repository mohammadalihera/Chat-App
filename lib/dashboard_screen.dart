import 'dart:io';

import 'package:chatapp/config/router_config.dart';
import 'package:chatapp/features/chat/widgets/contacts_list.dart';
import 'package:chatapp/features/group/screens/create_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chatapp/common/utils/colors.dart';
import 'package:chatapp/common/utils/utils.dart';
import 'package:chatapp/features/auth/controller/auth_controller.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<DashboardScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  int index = 0;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 1, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.hidden:
    }
  }

  void signOut(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider).signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appBarColor,
            centerTitle: false,
            title: const Text(
              'Chat App',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text(
                      'Profile',
                    ),
                    onTap: () => Future(
                      () => context.pushNamed(RouterConfiguration.userProfileScreen),
                    ),
                  ),
                  PopupMenuItem(
                    child: const Text(
                      'Create Group',
                    ),
                    onTap: () => Future(
                      () => context.pushNamed(RouterConfiguration.createGroupScreen),
                    ),
                  ),
                  PopupMenuItem(
                    child: const Text(
                      'Logout',
                    ),
                    onTap: () => Future(
                      () => signOut(ref, context),
                    ),
                  )
                ],
              ),
            ],
          ),
          body: ContactsList(),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              context.pushNamed(RouterConfiguration.selectContactScreen);
            },
            backgroundColor: tabColor,
            child: const Icon(
              Icons.comment,
              color: Colors.white,
            ),
          )),
    );
  }
}
