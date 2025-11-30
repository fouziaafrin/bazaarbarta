import 'package:firebase_auth/firebase_auth.dart';

typedef CodeSentCallback = void Function(String verificationId, int? resendToken);
typedef VerificationFailedCallback = void Function(FirebaseAuthException e);

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Send verification SMS to [phone] (full E.164 or local number with +88 prefix for Bangladesh).
  /// Pass callbacks to handle UI flow.
  static Future<void> sendOtp({
    required String phone,
    required CodeSentCallback onCodeSent,
    required VerificationFailedCallback onVerificationFailed,
    required void Function() onAutoVerified, // called when instant verification occurs
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Android may auto-verify with instant response
        try {
          await _auth.signInWithCredential(credential);
          onAutoVerified();
        } catch (e) {
          // ignore sign-in error here — caller can show message if needed
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e);
      },
      codeSent: (verificationId, resendToken) {
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // no-op; UI should allow manual OTP entry
      },
    );
  }

  /// Verify [smsCode] against [verificationId]
  static Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(credential);
  }

  static User? currentUser() => _auth.currentUser;
  static Future<void> signOut() => _auth.signOut();
}
