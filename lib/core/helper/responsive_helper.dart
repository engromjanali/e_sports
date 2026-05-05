import 'package:e_sports/core/extensions/screen_matres_extensions.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ResponsiveHelper {
  const ResponsiveHelper._();

  static const double _smallMobile = 420;
  static const double _mobile = 650;
  static const double _smallTab = 850;
  static const double _tab = Dimensions.webMaxWidth - 100;

  static bool isMobilePhone() {
    if (!kIsWeb) {
      return true;
    }else {
      return false;
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMobile(BuildContext context) {
    final screenWidth = context.screenWidth;
    if (screenWidth <= _mobile) {
      return true;
    } else {
      return false;
    }
  }

  static bool isSmallMobile(BuildContext context) {
    final screenWidth = context.screenWidth;
    if (screenWidth <= _smallMobile) {
      return true;
    } else {
      return false;
    }
  }

  static bool isBigMobile(BuildContext context) {
    final screenWidth = context.screenWidth;
    if (screenWidth > _smallMobile && screenWidth <= _mobile) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTab(BuildContext context) {
    final screenWidth = context.screenWidth;
    if (screenWidth <= _tab && screenWidth > _mobile) {
      return true;
    } else {
      return false;
    }
  }

  static bool isSmallTab(BuildContext context) {
    final screenWidth = context.screenWidth;
    if (screenWidth <= _smallTab && screenWidth > _mobile) {
      return true;
    } else {
      return false;
    }
  }

  static bool isBigTab(BuildContext context) {
    final screenWidth = context.screenWidth;
    if (screenWidth <= _tab && screenWidth > _smallTab) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDesktop(BuildContext context) {
    final screenWidth = context.screenWidth;
    if (screenWidth > _tab) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDesktopWidth(double screenWidth) {
    if (screenWidth > _tab) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTabWidth(double screenWidth) {
    if (screenWidth <= _tab && screenWidth > 600) {
      return true;
    } else {
      return false;
    }
  }
}
