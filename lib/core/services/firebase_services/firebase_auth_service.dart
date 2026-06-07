import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../data/exceptions/app_exceptions.dart';

@lazySingleton
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService(this._firebaseAuth, this._googleSignIn);

  Future<AuthCredential> _getGoogleCredential() async {
    await _googleSignIn.initialize(
      clientId:
          '590958385902-0voakf6dc6hk0p4kk7ktmrmak1i3sbk9.apps.googleusercontent.com',
    );

    final GoogleSignInAccount googleAccount = await _googleSignIn
        .authenticate();

    final GoogleSignInAuthentication googleAuth = googleAccount.authentication;

    return GoogleAuthProvider.credential(idToken: googleAuth.idToken);
  }

  Future<UserCredential> signInWithGoogle() async {
    final credential = await _getGoogleCredential();

    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> reAuthenticate({required String password}) async {
    final user = _firebaseAuth.currentUser;

    final credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: password,
    );

    return await user.reauthenticateWithCredential(credential);
  }

  Future<void> deleteAccount() async {
    await _firebaseAuth.currentUser!.delete();
  }

  Future<UserCredential> reAuthenticateWithGoogle() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw UnauthorizedException(message: 'User not authenticated');
    }

    final credential = await _getGoogleCredential();

    return await user.reauthenticateWithCredential(credential);
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
