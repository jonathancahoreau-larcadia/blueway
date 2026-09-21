import 'dart:math' as math;

double calculateCameraInclinationDegrees({
  required double pitchDegrees,
  required double rollDegrees,
}) {
  final pitchRadians = pitchDegrees * math.pi / 180;
  final rollRadians = rollDegrees * math.pi / 180;

  final verticalComponent = math.cos(pitchRadians) * math.cos(rollRadians);

  final safeVerticalComponent = verticalComponent.clamp(-1.0, 1.0).toDouble();

  return -math.asin(safeVerticalComponent) * 180 / math.pi;
}
