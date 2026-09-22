import 'package:flutter/material.dart';

import '../../auth/data/auth_service.dart';
import '../../home/presentation/home_screen.dart';
import '../data/profile_service.dart';
import '../domain/user_profile.dart';
import 'profile_setup_screen.dart';

class ProfileGate extends StatefulWidget {
  final AuthService authService;
  final ProfileService profileService;

  const ProfileGate({
    super.key,
    required this.authService,
    required this.profileService,
  });

  @override
  State<ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<ProfileGate> {
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = widget.profileService.getCurrentProfile();
  }

  void _reloadProfile() {
    setState(() {
      _profileFuture = widget.profileService.getCurrentProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('BlueWay'),
              actions: [
                TextButton(
                  onPressed: widget.authService.signOut,
                  child: const Text('Déconnexion'),
                ),
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Impossible de récupérer votre profil.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _reloadProfile,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final profile = snapshot.data;

        if (profile == null) {
          return ProfileSetupScreen(
            profileService: widget.profileService,
            onProfileCreated: _reloadProfile,
            onSignOut: widget.authService.signOut,
          );
        }

        return const HomeScreen();
      },
    );
  }
}
