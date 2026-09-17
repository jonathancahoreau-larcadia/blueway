import 'package:flutter/material.dart';

import '../../reports/presentation/reports_screen.dart';
import '../../map/presentation/map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BlueWay')),
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
          ],
        ),
      ),
    );
  }
}
