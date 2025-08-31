import 'package:commerce/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    required String id,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);

      // ✅ بدال ما تكتب Firestore مباشر، استخدم DatabaseMethods
      await DatabaseMethods().addUserDetails({
        'id': id,
        'name': name,
        'email': email,
        'image': "",
        'createdAt': FieldValue.serverTimestamp(),
      }, id);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Sign up failed";
    } catch (e) {
      throw "Unexpected error occurred";
    }
  }

  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Login failed";
    } catch (e) {
      throw "Unexpected error occurred";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteAccount(String id) async {
    try {
      await DatabaseMethods().deleteUser(id);
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      throw "Error deleting account: $e";
    }
  }
}
