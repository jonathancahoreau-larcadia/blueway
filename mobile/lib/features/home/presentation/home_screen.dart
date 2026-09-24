import 'package:flutter/material.dart';

import '../../map/presentation/map_screen.dart';
import '../../profile/domain/user_profile.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../reports/data/manual_report_service.dart';

class HomeScreen extends StatelessWidget {
  final UserProfile? profile;
  final Future<void> Function()? onSignOut;
  final ManualReportService? reportService;

  const HomeScreen({
    super.key,
    this.profile,
    this.onSignOut,
    this.reportService,
  });

  @override
  Widget build(BuildContext context) {
    return MapScreen(
      reportService: reportService,
      onOpenProfile: profile == null || onSignOut == null
          ? null
          : () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      ProfileScreen(profile: profile!, onSignOut: onSignOut!),
                ),
              );
            },
    );
  }
}
