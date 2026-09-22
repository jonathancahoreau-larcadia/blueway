import 'package:flutter/material.dart';

import '../domain/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  final UserProfile profile;
  final Future<void> Function() onSignOut;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onSignOut,
  });

  String _yesOrNo(bool value) {
    return value ? 'Oui' : 'Non';
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Non renseignée';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Future<void> _signOut(BuildContext context) async {
    await onSignOut();

    if (!context.mounted) return;

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              profile.username.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.username,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ListTile(title: const Text('Rôle'), subtitle: Text(profile.role)),
          ListTile(title: const Text('Statut'), subtitle: Text(profile.status)),
          ListTile(
            title: const Text('Date de naissance'),
            subtitle: Text(_formatDate(profile.dateOfBirth)),
          ),
          ListTile(
            title: const Text('Nationalité'),
            subtitle: Text(profile.nationality ?? 'Non renseignée'),
          ),
          const Divider(),
          ListTile(
            title: const Text('Afficher le nom d’utilisateur'),
            trailing: Text(_yesOrNo(profile.showUserName)),
          ),
          ListTile(
            title: const Text('Afficher les informations du bateau'),
            trailing: Text(_yesOrNo(profile.showBoatInfo)),
          ),
          ListTile(
            title: const Text('Notifications activées'),
            trailing: Text(_yesOrNo(profile.notificationsEnabled)),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
            label: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}
