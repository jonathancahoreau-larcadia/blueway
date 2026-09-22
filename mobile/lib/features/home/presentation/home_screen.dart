import 'package:flutter/material.dart';

import '../../reports/presentation/reports_screen.dart';
import '../../map/presentation/map_screen.dart';
import '../../camera/presentation/camera_screen.dart';
import '../../profile/domain/user_profile.dart';
import '../../profile/presentation/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserProfile? profile;
  final Future<void> Function()? onSignOut;

  const HomeScreen({super.key, this.profile, this.onSignOut});

  @override
  Widget build(BuildContext context) {
    final currentProfile = profile;
    final signOut = onSignOut;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BlueWay'),
        actions: [
          if (currentProfile != null && signOut != null)
            IconButton(
              tooltip: 'Mon profil',
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => ProfileScreen(
                      profile: currentProfile,
                      onSignOut: signOut,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenue sur BlueWay'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const MapScreen(),
                  ),
                );
              },
              child: const Text('Voir la carte'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const ReportsScreen(),
                  ),
                );
              },
              child: const Text('Voir les signalements'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const CameraScreen(),
                  ),
                );
              },
              child: const Text('Tester la caméra'),
            ),
          ],
        ),
      ),
    );
  }
}
