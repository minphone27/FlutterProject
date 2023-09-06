import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simp_3/pages/home.dart';
import 'package:simp_3/pages/login.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController(); // Add this controller

  String _email = '';
  String _password = '';
  String _confirmPassword = ''; // Add this variable
  String _error = '';

  // Firebase Authentication
  FirebaseAuth _auth = FirebaseAuth.instance;

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _signUpWithEmailAndPassword() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      // Successful sign-up, navigate to the home page or next screen.
      print('Signed up: $_email');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      // Navigate to your home page here.
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? 'An error occurred.');
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sign-up Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
          backgroundColor: Colors.green, // Set the dialog box background color
        );
      },
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    final passwordStrengthError = _validatePasswordStrength(value);
    if (passwordStrengthError != null) {
      return passwordStrengthError;
    }

    return null;
  }

  String? _validatePasswordStrength(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    // Define password complexity requirements
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    final hasDigits = RegExp(r'[0-9]').hasMatch(value);
    final hasSpecialCharacters =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    if (!hasUppercase ||
        !hasLowercase ||
        !hasDigits ||
        !hasSpecialCharacters ||
        value.length < 8) {
      return '''Password must be strong: at least 8 characters,
with uppercase, lowercase, digits, and special characters.''';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator:
                    _validatePassword, // Use the updated password validation
                onSaved: (value) {
                  _password = value!;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController, // Add the controller
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator:
                    _validateConfirmPassword, // Validate confirm password
                onSaved: (value) {
                  _confirmPassword = value!;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _signUpWithEmailAndPassword();
                  }
                },
                child: Text('Sign Up'),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
