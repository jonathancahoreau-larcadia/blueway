import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> get userChanges {
    return _firebaseAuth.userChanges();
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> sendEmailVerification() async {
    final user = currentUser;

    if (user == null) {
      throw StateError('Aucun utilisateur connecté.');
    }

    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> reloadAndCheckEmailVerification() async {
    final user = currentUser;

    if (user == null) {
      return false;
    }

    await user.reload();

    final refreshedUser = currentUser;

    if (refreshedUser == null || !refreshedUser.emailVerified) {
      return false;
    }

    await refreshedUser.getIdToken(true);

    return true;
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Future<String> getIdToken() async {
    final user = currentUser;

    if (user == null) {
      throw StateError('Aucun utilisateur connecté.');
    }

    final token = await user.getIdToken();

    if (token == null || token.isEmpty) {
      throw StateError('Jeton Firebase indisponible.');
    }

    return token;
  }
}
