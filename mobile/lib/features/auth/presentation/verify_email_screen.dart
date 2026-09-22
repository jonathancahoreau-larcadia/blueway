import 'package:flutter/material.dart';

import '../data/auth_service.dart';

class VerifyEmailScreen extends StatefulWidget {
  final AuthService authService;

  const VerifyEmailScreen({super.key, required this.authService});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isLoading = false;
  String? _message;

  Future<void> _checkVerification() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final isVerified = await widget.authService
          .reloadAndCheckEmailVerification();

      if (!mounted) return;

      if (!isVerified) {
        setState(() {
          _message = 'L’adresse e-mail n’est pas encore vérifiée.';
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _message = 'Impossible de vérifier l’adresse pour le moment.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendEmail() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await widget.authService.sendEmailVerification();

      if (!mounted) return;

      setState(() {
        _message = 'Un nouveau courriel de vérification a été envoyé.';
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _message = 'Impossible d’envoyer le courriel pour le moment.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    await widget.authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.authService.currentUser?.email;

    return Scaffold(
      appBar: AppBar(title: const Text('Vérification')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.mark_email_unread_outlined, size: 72),
              const SizedBox(height: 24),
              const Text(
                'Vérifiez votre adresse e-mail',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                email == null
                    ? 'Un lien de vérification vous a été envoyé.'
                    : 'Un lien de vérification a été envoyé à $email.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _checkVerification,
                child: const Text('J’ai vérifié mon adresse'),
              ),
              TextButton(
                onPressed: _isLoading ? null : _resendEmail,
                child: const Text('Renvoyer le courriel'),
              ),
              TextButton(
                onPressed: _isLoading ? null : _signOut,
                child: const Text('Se déconnecter'),
              ),
              if (_isLoading) ...[
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
              ],
              if (_message != null) ...[
                const SizedBox(height: 16),
                Text(_message!, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
