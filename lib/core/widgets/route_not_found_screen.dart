import 'package:e_sports/core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class RouteNotFoundScreen extends StatelessWidget {
  const RouteNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Padding(
          padding: Dimensions.screenAll,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Link not found',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: Dimensions.sizeHeading,
                  fontWeight: Dimensions.black,
                ),
              ),
              SizedBox(height: Dimensions.md),
              TextButton(
                onPressed: () => Get.offAllNamed(RouteHelper.home),
                child: const Text('Go to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
