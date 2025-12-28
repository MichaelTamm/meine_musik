import 'package:flutter_test/flutter_test.dart';
import 'package:meine_musik/utils.dart';

void main() {
  test('expandIndexed', () {
    expect([1, 2].expandIndexed((i, index) => ['$i@$index']), ['1@0', '2@1']);
  });
}
