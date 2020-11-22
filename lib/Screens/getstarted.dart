import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vaidya"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              "Create Account!",
              textScaleFactor: 1.5,
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                  child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Password",
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController.value.text,
                          password: passwordController.value.text);
                    },
                    child: Text("Login"),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
