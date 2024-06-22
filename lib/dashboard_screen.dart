import 'dart:io';

import 'package:chatapp/config/router_config.dart';
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
    tabBarController = TabController(length: 2, vsync: this);
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
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text(
                    'Profile',
                  ),
                  onTap: () => Future(
                    () => context.pushNamed(RouterConfiguration.userInfoScreen),
                  ),
                )
              ],
            ),
          ],
          bottom: TabBar(
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            controller: tabBarController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: const [Text('Chat'), Text('Calls')],
        ),
        floatingActionButton: index == 0
            ? FloatingActionButton(
                onPressed: () async {
                  if (tabBarController.index == 0) {
                    context.pushNamed(RouterConfiguration.selectContactScreen);
                  }
                },
                backgroundColor: tabColor,
                child: const Icon(
                  Icons.comment,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
