import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupWithEmailPage extends StatelessWidget {
  const SignupWithEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> signUpWithEmail() async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

        // Send email verification
        if (!userCredential.user!.emailVerified) {
          await userCredential.user!.sendEmailVerification();
          // _showSnackBar("Verification email sent! Please check your inbox.");
        }

        // Optional: Don't let them in until they verify
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        // _showSnackBar("Sign-up error: $e");
        print("Sign-up error: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up with Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signUpWithEmail,
              child: const Text("Sign up with Email"),
            ),
          ],
        ),
      ),
    );
  }
}
