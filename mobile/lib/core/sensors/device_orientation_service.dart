import 'package:precise_compass/precise_compass.dart';

class DeviceOrientationService {
  Stream<CompassReading> get readings {
    return PreciseCompass.headingStream(
      config: const CompassConfig(
        reference: HeadingReference.trueNorth,
        rate: SensorRate.normal,
      ),
    );
  }
}
