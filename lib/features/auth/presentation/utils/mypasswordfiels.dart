import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedPasswordField extends StatefulWidget {
  final TextEditingController controller;

  const AnimatedPasswordField({super.key, required this.controller});

  @override
  State<AnimatedPasswordField> createState() => _AnimatedPasswordFieldState();
}

class _AnimatedPasswordFieldState extends State<AnimatedPasswordField>
    with SingleTickerProviderStateMixin {
  bool isObscure = true;
  int strengthLevel = 0;
  String strengthText = "";

  // Vérifie la force du mot de passe
  void checkPassword(String password) {
    int level = 0;
    if (password.length >= 6) level++;
    if (RegExp(r'[A-Z]').hasMatch(password)) level++;
    if (RegExp(r'[0-9]').hasMatch(password)) level++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) level++;

    String text;
    switch (level) {
      case 0:
      case 1:
        text = "Weak";
        break;
      case 2:
        text = "Medium";
        break;
      case 3:
        text = "Strong";
        break;
      case 4:
        text = "Very Strong";
        break;
      default:
        text = "";
    }

    setState(() {
      strengthLevel = level;
      strengthText = text;
    });
  }

  Color getColor() {
    switch (strengthLevel) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow[700]!;
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            obscureText: isObscure,
            onChanged: checkPassword,
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: GoogleFonts.poppins(),
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              ),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  height: 5,
                  decoration: BoxDecoration(
                    color: index < strengthLevel
                        ? getColor()
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 6),
          Text(
            strengthText,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: getColor(),
            ),
          ),
        ],
      ),
    );
  }
}
