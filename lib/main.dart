import 'package:expense_tracker/signup_with_email_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:expense_tracker/login.dart';
import 'package:expense_tracker/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExpenseTracker());
}

class ExpenseTracker extends StatelessWidget {
  const ExpenseTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/': (context) => const FirebaseInitWrapper(),
        '/login': (context) => const LoginPage(title: 'Expense Tracker'),
        '/home': (context) => const HomePage(),
        '/sign_up_with_email': (context) => SignupWithEmailPage(),
      },
    );
  }
}

class FirebaseInitWrapper extends StatelessWidget {
  const FirebaseInitWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Firebase init error: ${snapshot.error}")),
          );
        } else {
          return const AuthGate(); // After Firebase initialization, navigate to AuthGate
        }
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        } else if (snapshot.hasData) {
          // 👤 User is signed in
          User? user = snapshot.data;

          // Check if user is valid and not deleted
          user?.reload().then((_) {
            if (user?.emailVerified == false) {
              // You can log out or redirect if necessary
              FirebaseAuth.instance.signOut();
            }
          }).catchError((error) {
            // Handle errors (e.g., account deleted)
            FirebaseAuth.instance.signOut();
          });

          return const HomePage(); // User is valid and signed in
        } else {
          // 👤 No user signed in (or user was deleted)
          return const LoginPage(title: 'Expense Tracker');
        }
      },
    );
  }
}