import 'package:blueway/features/camera/domain/capture_requirements.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('autorise exactement 50 mètres de précision', () {
    expect(isCaptureGpsAccuracySufficient(50), isTrue);
  });

  test('refuse une précision supérieure à 50 mètres', () {
    expect(isCaptureGpsAccuracySufficient(50.1), isFalse);
  });

  test('refuse une précision absente', () {
    expect(isCaptureGpsAccuracySufficient(null), isFalse);
  });
}
