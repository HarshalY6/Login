import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'logic.dart';

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
  late String mob;
  late String otp;

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
              otpverify(otp);
            },
            child: const Text('Verify'),
          )
        ])));
  }
}
