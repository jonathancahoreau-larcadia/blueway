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
    expect(find.text('user'), findsOneWidget);
    expect(find.text('active'), findsOneWidget);
    expect(find.text('Non'), findsNWidgets(3));
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
