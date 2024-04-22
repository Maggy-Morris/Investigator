import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField buildTextFormField({
  required String labelText,
  String? hintText,
  required Function(String) onChanged,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
}) {
  return TextFormField(
    cursorColor: Colors.white,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white),
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Colors.white,
      ),
    ),
    onChanged: onChanged,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '$labelText is required'; // Display error message when field is empty
      }
      return null; // Return null if there's no error
    },
  );
}
