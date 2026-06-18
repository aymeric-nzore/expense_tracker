import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color colorText;
  final VoidCallback onTap;
  const MyButton({super.key , required this.text, required this.color, required this.colorText,
  required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, 4)
            )
          ],
          borderRadius: BorderRadius.circular(6)
        ),
        padding: EdgeInsets.all(12),
        
        child: Center(child: Text(text,style: GoogleFonts.poppins(
          color: colorText,
          fontWeight: FontWeight.bold,
          fontSize: 16
        ),)),
      ),
    );
  }
}