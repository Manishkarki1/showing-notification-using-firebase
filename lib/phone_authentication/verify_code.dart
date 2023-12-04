import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasepractice/notification/home_screen.dart';
import 'package:firebasepractice/phone_authentication/home.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;

  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final TextEditingController code = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: code,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: '6 - digits code',
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                final Credential = PhoneAuthProvider.credential(
                  
                    verificationId: widget.verificationId,
                    smsCode: code.text.toString());

                try {
                  await auth.signInWithCredential(Credential);
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return HomeScreenPhone();
                  }));
                  setState(() {
                    loading = false;
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                  setState(() {
                    loading = false;
                  });
                }
              },
              child: Text("Confirm"))
        ],
      ),
    );
  }
}
