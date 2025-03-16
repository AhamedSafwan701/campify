import 'package:flutter/material.dart';

class CustomAlertbox extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final Color? backgroundColor;
  final double borderRadius;
  const CustomAlertbox({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.backgroundColor,
    this.borderRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: SingleChildScrollView(child: content),
      actions: actions,
    );
  }
}
