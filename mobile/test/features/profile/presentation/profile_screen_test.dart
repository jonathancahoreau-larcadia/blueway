import 'package:blueway/features/profile/domain/user_profile.dart';
import 'package:blueway/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final profile = UserProfile(
    id: 'user-123',
    username: 'John',
    dateOfBirth: null,
    nationality: null,
    role: 'user',
    status: 'active',
    showUserName: false,
    showBoatInfo: false,
    notificationsEnabled: false,
    createdAt: DateTime.utc(2026, 9, 22),
    updatedAt: DateTime.utc(2026, 9, 22),
  );

  testWidgets('affiche le profil et les préférences par défaut', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 1200));

    addTearDown(() {
      return tester.binding.setSurfaceSize(null);
    });
    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(profile: profile, onSignOut: () async {}),
      ),
    );

    expect(find.text('John'), findsOneWidget);
    expect(find.text('Utilisateur'), findsOneWidget);
    expect(find.text('Actif'), findsOneWidget);
    expect(find.text('Non'), findsNWidgets(3));
  });

  testWidgets('reste lisible et défilable sur un petit écran', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(profile: profile, onSignOut: () async {}),
      ),
    );

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Se déconnecter'),
      250,
      scrollable: find.byType(Scrollable),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Se déconnecter'), findsOneWidget);
  });

  testWidgets('permet de se déconnecter', (tester) async {
    var signedOut = false;

    addTearDown(() {
      return tester.binding.setSurfaceSize(null);
    });
    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(profile: profile, onSignOut: () async {}),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          profile: profile,
          onSignOut: () async {
            signedOut = true;
          },
        ),
      ),
    );

    final signOutButton = find.text('Se déconnecter');

    await tester.scrollUntilVisible(
      signOutButton,
      300,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(signOutButton);
    await tester.pump();

    expect(signedOut, isTrue);
  });
}
