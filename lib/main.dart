import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String mob = 'uty';
  String otp = 'lkj';
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String verificationId;

  void verification(PhoneAuthCredential verAuthCredential) async {
    try {
      final authCredential =
          await _auth.signInWithCredential(verAuthCredential);

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
        this.verificationId = verificationId;
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = 'xxxx';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[300],
          title: Text(
            'Login Page',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              height: 40,
              width: 300,
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Enter Mobile Number',
                ),
                onSubmitted: (value) => {
                  mob = value,
                  registerUser(mob),
                },
              )),
          SizedBox(
            height: 20.0,
          ),
          Container(
              height: 40,
              width: 300,
              child: TextField(
                  onSubmitted: (value) async {
                    otp = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: 'Enter OTP For Verification'))),
          SizedBox(
            height: 30.0,
          ),
          ElevatedButton(
            onPressed: () {
              PhoneAuthCredential verAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId, smsCode: otp);
              verification(verAuthCredential);
            },
            child: const Text('Verify'),
          )
        ])));
  }
}
