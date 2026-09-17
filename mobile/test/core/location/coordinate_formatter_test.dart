import 'package:flutter_test/flutter_test.dart';
import 'package:blueway/core/location/coordinate_formatter.dart';

void main() {
  test('convertit une latitude nord', () {
    expect(formatDms(48.8566, isLatitude: true), '48° 51′ 24″ N');
  });

  test('convertit une longitude ouest', () {
    expect(formatDms(-4.49, isLatitude: false), '4° 29′ 24″ W');
  });

  test('convertit une latitude sud', () {
    expect(formatDms(-33.8688, isLatitude: true), '33° 52′ 8″ S');
  });

  test('reporte l’arrondi sur le degré suivant', () {
    expect(formatDms(12.999999, isLatitude: false), '13° 0′ 0″ E');
  });
}
