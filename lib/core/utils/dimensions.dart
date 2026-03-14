import 'package:get/get.dart';

class Dimensions {
  static double get fontSizeOverSmall => Get.width >= 1300 ? 10 : 8;
  static double get fontSizeExtraSmall => Get.width >= 1300 ? 12 : 10; // Check if 40 is a typo here!
  static double get fontSizeSmall => Get.width >= 1300 ? 14 : 12;
  static double get fontSizeDefault => Get.width >= 1300 ? 16 : 14;
  static double get fontSizeLarge => Get.width >= 1300 ? 18 : 16;
  static double get fontSizeExtraLarge => Get.width >= 1300 ? 20 : 18;
  static double get fontSizeOverLarge => Get.width >= 1300 ? 26 : 24;

  static const double paddingSizeExtraSmall = 5.0;
  static const double paddingSizeSmall = 10.0;
  static const double paddingSizeDefault = 15.0;
  static const double paddingSizeLarge = 20.0;
  static const double paddingSizeExtraLarge = 25.0;
  static const double paddingSizeExtremeLarge = 30.0;
  static const double paddingSizeExtraOverLarge = 35.0;

  static const double radiusSmall = 5.0;
  static const double radiusMedium = 8.0;
  static const double radiusDefault = 10.0;
  static const double radiusLarge = 15.0;
  static const double radiusExtraLarge = 20.0;

  static const double webMaxWidth = 1200;
  static const int messageInputLength = 1000;

  static const double pickMapIconSize = 100.0;
}
