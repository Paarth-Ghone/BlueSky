import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = ''; // Added variable to hold error message

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      // Perform signup logic with email and password
                      // ...
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/homepage');
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        if (e.code == 'weak-password') {
                          errorMessage = 'Weak password. Please choose a stronger password.';
                        } else if (e.code == 'email-already-in-use') {
                          errorMessage = 'Email address is already in use. Please choose a different email.';
                        } else if (e.code == 'invalid-email') {
                          errorMessage = 'Invalid email address.';
                        } else {
                          errorMessage = 'Error signing up. Please try again.';
                        }
                      });
                    } catch (_) {
                      setState(() {
                        errorMessage = 'Error signing up. Please try again.';
                      });
                    }
                  }
                },
                child: const Text('Sign Up'),
              ),
              if (errorMessage.isNotEmpty) // Show error message if not empty
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
