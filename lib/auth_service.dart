import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // -----------------------------
  // Nonce Generator for Apple
  // -----------------------------
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // -----------------------------
  // SIGN IN WITH GOOGLE
  // -----------------------------
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // ---------- WEB ----------
      if (kIsWeb) {
        final provider = GoogleAuthProvider();

        // Optional scopes:
        // provider.addScope('email');

        return await _auth.signInWithPopup(provider);
      }

      // ---------- ANDROID / iOS ----------
      if (Platform.isAndroid || Platform.isIOS) {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (googleUser == null) {
          return null; // user cancelled
        }

        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, // accessToken removed (v7 change)
        );

        return await _auth.signInWithCredential(credential);
      }

      // ---------- OTHER PLATFORMS ----------
      return null;

    } catch (e, stack) {
      print("Google Sign-In error: $e");
      print(stack);
      return null;
    }
  }

  // -----------------------------
  // SIGN IN WITH APPLE
  // -----------------------------
  Future<UserCredential?> signInWithApple() async {
    try {
      // ---------- WEB ----------
      if (kIsWeb) {
        final provider = OAuthProvider("apple.com");
        provider.addScope("email");
        provider.addScope("name");

        return await _auth.signInWithPopup(provider);
      }

      // ---------- iOS NATIVE ----------
      if (Platform.isIOS) {
        final rawNonce = _generateNonce();
        final nonce = _sha256ofString(rawNonce);

        final appleIdCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleIdCredential.identityToken,
          rawNonce: rawNonce,
        );

        return await _auth.signInWithCredential(oauthCredential);
      }

      // ---------- APPLE NOT SUPPORTED ----------
      return null;

    } catch (e, stack) {
      print("Apple Sign-In error: $e");
      print(stack);
      return null;
    }
  }

  // -----------------------------
  // SIGN OUT
  // -----------------------------
  Future<void> signOut() async {
    try {
      await _auth.signOut();

      // Sign out Google if available
      await GoogleSignIn().signOut();

    } catch (e, stack) {
      print("Sign-Out error: $e");
      print(stack);
    }
  }
}
