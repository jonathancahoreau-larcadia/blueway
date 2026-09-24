import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'app/app.dart';
import 'core/map/map_config.dart';
import 'core/api/api_service.dart';
import 'features/auth/data/auth_service.dart';
import 'features/auth/presentation/auth_gate.dart';
import 'features/profile/data/profile_service.dart';
import 'features/reports/data/manual_report_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  MapboxOptions.setAccessToken(MapConfig.accessToken);

  final authService = AuthService();
  final apiService = ApiService(client: http.Client());
  final profileService = ProfileService(
    apiService: apiService,
    getIdToken: authService.getIdToken,
  );
  final reportService = ManualReportService(
    apiService: apiService,
    getIdToken: authService.getIdToken,
  );

  runApp(
    MyApp(
      home: AuthGate(
        authService: authService,
        profileService: profileService,
        reportService: reportService,
      ),
    ),
  );
}
