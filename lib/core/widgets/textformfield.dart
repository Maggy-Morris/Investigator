import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final InputBorder? border;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final bool obscureText;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isDense;
  final Widget? prefixIcon;
  final TextStyle? prefixStyle;
  final bool enabled;
  final void Function()? onTap;
  final InputBorder? errorBorder;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final int? maxLines;
  final String? prefixText;
  final TextStyle? style;
  final int? maxLength;
  final AutovalidateMode? autovalidateMode;
  final Color? fillColor;
  final bool? filled;
  const CustomTextField({
    Key? key,
    this.controller,
    this.border,
    this.hintText,
    this.contentPadding,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.isDense,
    this.prefixIcon,
    this.prefixStyle,
    this.enabled = true,
    this.onTap,
    this.enabledBorder,
    this.errorBorder,
    this.disabledBorder,
    this.focusedBorder,
    this.maxLines = 1,
    this.prefixText,
    this.style,
    this.maxLength,
    this.autovalidateMode,
    this.fillColor,
    this.filled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autovalidateMode,
      maxLength: maxLength,
      style: style,
      enabled: enabled,
      onTap: onTap,
      // readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: filled,
        prefixText: prefixText,
        errorBorder: errorBorder,
        enabledBorder: enabledBorder?.copyWith(
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: focusedBorder?.copyWith(
            borderSide: const BorderSide(style: BorderStyle.none),
        ),
        disabledBorder: disabledBorder,
        prefixIcon: prefixIcon,
        isDense: isDense,
        border: border,
        hintText: hintText,
        contentPadding: contentPadding,
        suffixIcon: suffixIcon,
        prefixStyle: prefixStyle,
      ),
    );
  }
}
