import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:chatapp/common/utils/colors.dart';
import 'package:chatapp/common/widgets/custom_button.dart';
import 'package:chatapp/config/router_config.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          SizedBox(
            width: size.width,
            child: const Center(
              child: Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height / 9),
          SizedBox(height: size.height / 9),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            width: size.width * 0.85,
            child: CustomButton(
              text: 'CONTINUE',
              onPressed: () => context.pushReplacementNamed(RouterConfiguration.loginScreen),
            ),
          ),
        ],
      ),
    );
  }
}
