import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField buildTextFormField({
  required String labelText,
  required Function(String) onChanged,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
}) {
  return TextFormField(
    cursorColor: Colors.white,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
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
