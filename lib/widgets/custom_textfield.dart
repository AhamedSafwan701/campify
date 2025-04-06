import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration;
  const CustomTextfield({
    super.key,
    this.hint,
    this.controller,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final defaultDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      hintText: hint,
    );
    final effectiveDecoration =
        decoration != null
            ? decoration!.copyWith(
              hintText: hint ?? decoration!.hintText,
              border: decoration!.border ?? defaultDecoration.border,
            )
            : defaultDecoration;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: hint,
      ),
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}
