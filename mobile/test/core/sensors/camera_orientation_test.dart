import 'package:blueway/core/sensors/camera_orientation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('retourne -90 degrés quand la caméra vise le sol', () {
    final inclination = calculateCameraInclinationDegrees(
      pitchDegrees: 0,
      rollDegrees: 0,
    );

    expect(inclination, closeTo(-90, 0.01));
  });

  test('retourne 90 degrés quand la caméra vise le ciel', () {
    final inclination = calculateCameraInclinationDegrees(
      pitchDegrees: 0,
      rollDegrees: 180,
    );

    expect(inclination, closeTo(90, 0.01));
  });

  test('retourne 0 degré quand la caméra vise l’horizon', () {
    final inclination = calculateCameraInclinationDegrees(
      pitchDegrees: 90,
      rollDegrees: 0,
    );

    expect(inclination, closeTo(0, 0.01));
  });
}
