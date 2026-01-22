import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnBoardItem extends StatelessWidget {
  final String image;
  final String title;
  final Color textColor;
  final String description;
  const OnBoardItem({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(image, height: 400),
              Text(
                textAlign: TextAlign.center,
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.grey,fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
