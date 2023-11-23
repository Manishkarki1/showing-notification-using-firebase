import 'package:firebasepractice/mixins.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget with ValidationMixin {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formvalidate = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    Login vk = Login();
    return Scaffold(
      appBar: AppBar(title: Text('Login section')),
      body: Form(
        key: _formvalidate,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                decoration: InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 23)),
                    hintText: 'email'),
                validator: (value) {
                  if (!value!.contains('@')) {
                    return 'please enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                controller: password,
                decoration: InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 23)),
                    hintText: 'password'),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formvalidate.currentState!.validate()) {}
                },
                child: Text('Login'))
          ],
        ),
      ),
    );
  }
}
