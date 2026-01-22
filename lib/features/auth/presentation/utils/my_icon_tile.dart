import 'package:flutter/material.dart';

class MyIconTile extends StatelessWidget {
  final String name;
  const MyIconTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16)
        ),
        height: 72,
        child: Image.asset("assets/images/$name" , height: 40,),
      ),
    );
  }
}