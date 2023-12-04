import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasepractice/phone_authentication/verify_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In with Phone'),
      ),
      body: Column(
        children: [
          Form(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: phoneController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordController,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password_outlined),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              !loading
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        
                        
                        auth.verifyPhoneNumber(
                          phoneNumber: phoneController.text,
                          verificationCompleted: (_) {
                            setState(() {
                              loading = false;
                            });
                          },
                          verificationFailed: (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                            setState(() {
                              loading = false;
                            });
                          },
                          codeSent: (String verfication, int? token) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return VerifyCodeScreen(
                                    verificationId: verfication,
                                  );
                                },
                              ),
                            );
                            setState(() {
                              loading = false;
                            });
                          },
                          codeAutoRetrievalTimeout: (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      },
                      child: Text('Sign In'),
                    )
                  : CircularProgressIndicator()
            ],
          ))
        ],
      ),
    );
  }
}
