import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registration for Farmer and Buyer
  Future<String?> register(String email, String password, String name, String role) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await FirestoreService().addUser(cred.user!.uid, email, name, role);
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }


    /// Sends a password reset email to the given address
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message; // return error message
    } catch (e) {
      return e.toString();
    }
  }

  // Login for all roles
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}

