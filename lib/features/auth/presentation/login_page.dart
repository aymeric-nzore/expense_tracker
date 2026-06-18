import 'package:expense_tracker_app/features/auth/presentation/register_page.dart';
import 'package:expense_tracker_app/features/auth/presentation/utils/my_button.dart';
import 'package:expense_tracker_app/features/auth/presentation/utils/my_icon_tile.dart';
import 'package:expense_tracker_app/features/auth/presentation/utils/my_textfield.dart';
import 'package:expense_tracker_app/features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool isObscurepassword = true;

  Future signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Loader
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(color: Colors.deepOrangeAccent),
        ),
      );

      // Connexion Firebase
      await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Close loader
      Navigator.of(context).pop();

      // Revenir à la racine pour laisser AuthGate rediriger
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // enlever le loader

      // Affichage d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Login failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: bottomInset + 18),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - bottomInset,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login here",
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Welcome back You've been missed!",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            MyTextfield(
                              text: "Email",
                              controller: _emailController,
                              icon: Icon(Icons.email),
                              isObscure: false,
                            ),
                            MyTextfield(
                              text: "Password",
                              controller: _passwordController,
                              icon: Icon(Icons.lock),
                              sicon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscurepassword = !isObscurepassword;
                                  });
                                },
                                icon: isObscurepassword
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              ),
                              isObscure: isObscurepassword,
                            ),
                            SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                child: Text(
                                  "Forgot your Password ?",
                                  style: GoogleFonts.poppins(
                                    color: Colors.deepOrangeAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            MyButton(
                              text: "Login",
                              color: Colors.deepOrangeAccent,
                              colorText: Colors.white,
                              onTap: signIn,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(color: Colors.grey, thickness: 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "Or continue with",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: Colors.grey, thickness: 1),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyIconTile(name: "google.png"),
                          SizedBox(width: 25),
                          MyIconTile(name: "facebook.png"),
                        ],
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        ),
                        child: Text(
                          "Don't have account ? Create account",
                          style: GoogleFonts.poppins(
                            color: Colors.deepOrangeAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
