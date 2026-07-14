import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

abstract class FirebaseAuthRemoteDataSource {
  Future<UserCredential> signInWithEmailAndPassword(String email, String password);
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password, String fullName);
  Future<UserCredential?> signInWithGoogle();
  Future<UserCredential?> signInWithFacebook();
  Future<void> forgotPassword(String email);
  Future<void> signOut();
  bool checkUserLoggedIn();
}

class FirebaseAuthRemoteDataSourceImpl implements FirebaseAuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FacebookAuth facebookAuth;

  FirebaseAuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.facebookAuth,
  });

  @override
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password, String fullName) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user;
    if (user != null && fullName.trim().isNotEmpty) {
      await user.updateDisplayName(fullName.trim());
      await user.reload();
    }
    return credential;
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final authz = await googleUser.authorizationClient.authorizationForScopes([
        'email',
        'profile',
      ]);

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authz?.accessToken,
        idToken: googleAuth.idToken,
      );

      return await firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserCredential?> signInWithFacebook() async {
    final LoginResult result = await facebookAuth.login();

    if (result.status == LoginStatus.success) {
      final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
      return await firebaseAuth.signInWithCredential(credential);
    }
    return null;
  }

  @override
  Future<void> forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await facebookAuth.logOut();
    await firebaseAuth.signOut();
  }

  @override
  bool checkUserLoggedIn() {
    return firebaseAuth.currentUser != null;
  }
}
