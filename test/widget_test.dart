import 'package:e_sports/core/helper/route_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('custom scheme deep links map to Get routes', () {
    expect(RouteHelper.routeFromUri(Uri.parse('esports://profile/1')), '/profile/1');
    expect(RouteHelper.routeFromUri(Uri.parse('esports:///news/2')), '/news/2');
  });
}
