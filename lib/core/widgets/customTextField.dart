import 'package:flutter/material.dart';

TextFormField buildTextFormField({
  required String labelText,
  required Function(String) onChanged,

}) {
  return TextFormField(
    decoration: InputDecoration(
      
      labelText: labelText,
    ),
    onChanged: onChanged,
    validator: (value) {
      if (value == null) {
        return '$labelText is required'; // Display error message when field is empty
      }
      return null; // Return null if there's no error
    },
  );
}
