import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final AuthService authService;

  const RegisterScreen({super.key, required this.authService});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmation = _confirmationController.text;

    if (email.isEmpty || password.isEmpty || confirmation.isEmpty) {
      setState(() {
        _errorMessage = 'Tous les champs sont obligatoires.';
      });
      return;
    }

    if (password != confirmation) {
      setState(() {
        _errorMessage = 'Les mots de passe ne correspondent pas.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.authService.signUp(email: email, password: password);

      await widget.authService.sendEmailVerification();

      if (!mounted) return;

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = _messageForFirebaseError(error.code);
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Impossible de créer le compte pour le moment.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _messageForFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Un compte utilise déjà cette adresse e-mail.';
      case 'invalid-email':
        return 'L’adresse e-mail est invalide.';
      case 'weak-password':
        return 'Le mot de passe n’est pas assez sécurisé.';
      case 'operation-not-allowed':
        return 'L’inscription par e-mail est indisponible.';
      case 'network-request-failed':
        return 'Connexion réseau indisponible.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard.';
      default:
        return 'Impossible de créer le compte pour le moment.';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Créer un compte BlueWay',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Adresse e-mail',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmationController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Créer mon compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
