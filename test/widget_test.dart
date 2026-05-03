import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:e_sports/features/auth/domain/services/auth_service_interface.dart';
import 'package:e_sports/features/auth/presentation/pages/login_page.dart';
import 'package:e_sports/core/helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  test('custom scheme deep links map to Get routes', () {
    expect(RouteHelper.routeFromUri(Uri.parse('esports://profile/1')), '/profile/1');
    expect(RouteHelper.routeFromUri(Uri.parse('esports:///news/2')), '/news/2');
  });

  testWidgets('login page does not overflow on narrow mobile', (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      Get.reset();
    });

    Get.put(AuthController(authServiceInterface: _FakeAuthService()));

    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));

    expect(tester.takeException(), isNull);
  });
}

class _FakeAuthService implements AuthServiceInterface {
  @override
  Future<AuthLoginResult> login(String? email, String password) async {
    return const AuthLoginResult(true, 'Login successful');
  }

  @override
  String getUserToken() {
    return 'token';
  }

  @override
  bool isLoggedIn() {
    return true;
  }

  @override
  Future<bool> clearSharedData() async {
    return true;
  }
}
