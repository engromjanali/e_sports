import 'package:flutter/material.dart';

extension WidgetOpacity on Widget {
  Widget withOpacity(double opacity) => Opacity(opacity: opacity, child: this);
}
