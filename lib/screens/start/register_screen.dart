import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  bool _termsAccepted = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; // The user canceled the sign-in
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      // Check if the widget is still mounted before navigating
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error during Google sign-in: $e")),
        );
      }
    }
  }

  Future<void> _registerAccount() async {
    if (!_termsAccepted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept the terms and conditions')),
        );
      }
      return;
    }

    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
      }
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(
            "${_firstNameController.text} ${_lastNameController.text}");
      }

      // Check if the widget is still mounted before navigating
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during registration: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Input fields
                    _buildTextField(
                        controller: _firstNameController,
                        labelText: "First Name"),
                    const SizedBox(height: 16.0),

                    _buildTextField(
                        controller: _lastNameController, labelText: "Last Name"),
                    const SizedBox(height: 16.0),

                    _buildTextField(
                        controller: _emailController,
                        labelText: "E-Mail",
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16.0),

                    _buildTextField(
                        controller: _phoneController,
                        labelText: "Phone",
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 16.0),

                    _buildTextField(
                        controller: _altPhoneController,
                        labelText: "Alternative Phone",
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 16.0),

                    _buildTextField(
                        controller: _passwordController,
                        labelText: "Password",
                        obscureText: true),
                    const SizedBox(height: 16.0),

                    // Terms and conditions checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          onChanged: (value) {
                            setState(() {
                              _termsAccepted = value!;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "Agree with Terms & Conditions",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // Sign Up Button
                    ElevatedButton(
                      onPressed: _registerAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text("Sign Up"),
                    ),
                    const SizedBox(height: 16.0),

                    // Google Sign-In Button
                    GestureDetector(
                      onTap: _signInWithGoogle,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          "assets/images/google_logo.png",
                          height: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Navigate to Login Page
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function for text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
