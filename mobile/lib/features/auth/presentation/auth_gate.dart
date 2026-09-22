import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../profile/data/profile_service.dart';
import '../../profile/presentation/profile_gate.dart';
import '../data/auth_service.dart';
import 'login_screen.dart';
import 'verify_email_screen.dart';

class AuthGate extends StatelessWidget {
  final AuthService authService;
  final ProfileService profileService;

  const AuthGate({
    super.key,
    required this.authService,
    required this.profileService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.userChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Impossible de vérifier votre session.')),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return LoginScreen(authService: authService);
        }

        if (!user.emailVerified) {
          return VerifyEmailScreen(authService: authService);
        }

        return ProfileGate(
          authService: authService,
          profileService: profileService,
        );
      },
    );
  }
}
