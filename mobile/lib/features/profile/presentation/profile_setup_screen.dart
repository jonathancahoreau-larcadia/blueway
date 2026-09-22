import 'package:flutter/material.dart';

import '../../../core/api/api_exception.dart';
import '../data/profile_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  final ProfileService profileService;
  final VoidCallback onProfileCreated;
  final Future<void> Function() onSignOut;

  const ProfileSetupScreen({
    super.key,
    required this.profileService,
    required this.onProfileCreated,
    required this.onSignOut,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _createProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.profileService.createProfile(
        username: _usernameController.text,
      );

      if (!mounted) return;

      widget.onProfileCreated();
    } on ApiException catch (error) {
      if (!mounted) return;

      setState(() {
        if (error.statusCode == 409) {
          _errorMessage = 'Ce nom d’utilisateur est déjà utilisé.';
        } else if (error.statusCode == 403) {
          _errorMessage = 'Votre adresse e-mail doit être vérifiée.';
        } else {
          _errorMessage = 'Impossible de créer votre profil.';
        }
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage =
            'Impossible de contacter le serveur. Réessayez plus tard.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Votre profil'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : widget.onSignOut,
            child: const Text('Déconnexion'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Choisissez votre nom d’utilisateur',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ce nom sera associé à votre profil BlueWay.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _usernameController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Nom d’utilisateur',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final username = value?.trim() ?? '';

                    if (username.isEmpty) {
                      return 'Choisissez un nom d’utilisateur.';
                    }

                    if (username.length > 100) {
                      return 'Le nom ne peut pas dépasser 100 caractères.';
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) {
                    if (!_isLoading) {
                      _createProfile();
                    }
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _isLoading ? null : _createProfile,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Créer mon profil'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
