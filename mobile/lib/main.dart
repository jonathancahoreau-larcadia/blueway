import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'core/map/map_config.dart';
import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(MapConfig.accessToken);

  runApp(const MyApp());
}
