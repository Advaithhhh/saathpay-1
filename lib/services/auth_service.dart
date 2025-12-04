import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google User Credentials
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Create/Update owner document
      await _saveOwnerData(userCredential.user);

      return userCredential;
    } catch (e) {
      debugPrint("Error signing in with Google: $e");
      rethrow;
    }
  }

  // Save owner data to Firestore
  Future<void> _saveOwnerData(User? user) async {
    if (user == null) return;

    final userRef = _firestore.collection('owners').doc(user.uid);

    // Check if user exists to avoid overwriting existing data (like gym name if set)
    final docSnapshot = await userRef.get();

    if (!docSnapshot.exists) {
      await userRef.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'gymName': 'My Gym', // Default
        'gymLogo': null,
      });
    } else {
      // Update last login
      await userRef.update({
        'lastLogin': FieldValue.serverTimestamp(),
        // Update basic info if changed in Google
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
      });
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
