import 'package:firebase_auth/firebase_auth.dart';

String verificationId = 'rrr';
FirebaseAuth _auth = FirebaseAuth.instance;
otpverify(String otp) async {
  PhoneAuthCredential verAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId, smsCode: otp);
  verification(verAuthCredential);
}

void verification(PhoneAuthCredential verAuthCredential) async {
  try {
    final authCredential = await _auth.signInWithCredential(verAuthCredential);

    if (authCredential?.user != null) {
      print("Verified");
    }
  } on FirebaseAuthException catch (e) {
    print("Wrong OTP");
  }
}

registerUser(String mob) async {
  await _auth.verifyPhoneNumber(
    phoneNumber: mob,
    timeout: Duration(seconds: 90),
    verificationCompleted: (PhoneAuthCredential credential) async {},
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }

      // Handle other errors
    },
    codeSent: (String verificationId, int? resendToken) async {
      verificationId = verificationId;
      // Update the UI - wait for the user to enter the SMS code
      String smsCode = 'xxxx';

      // Sign the user in (or link) with the credential
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}
