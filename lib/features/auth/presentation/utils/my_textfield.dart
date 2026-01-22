import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextfield extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final Icon icon;
  final IconButton? sicon;
  final bool isObscure;
  const MyTextfield({super.key, required this.text, required this.controller, required this.icon, this.sicon, required this.isObscure});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: isObscure,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6)
          ),
          fillColor: Colors.deepOrange,
          labelText: text,
          labelStyle: GoogleFonts.poppins(),
          prefixIcon: icon,
          suffixIcon: sicon
        ),
      ),
      
    );
  }
}
