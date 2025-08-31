import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.label,
    this.onChanged,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.icon,
    this.controller,
    this.useBorder = false,
    this.backgroundColor,
  });

  final String? hintText;
  final Widget? label;
  final bool obscureText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final IconData? icon;
  final TextEditingController? controller;
  final bool useBorder;
  final Color? backgroundColor;
  // final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: backgroundColor ?? Color(0xfff4f5f9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        // maxLines: maxLines,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        obscureText: obscureText,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          label: label,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintStyle: const TextStyle(color: Colors.black54),
          enabledBorder: useBorder ? border(Colors.grey) : InputBorder.none,
          focusedBorder: useBorder ? border(Colors.blue) : InputBorder.none,
          errorBorder: useBorder ? border(Colors.red) : InputBorder.none,
          focusedErrorBorder:
              useBorder ? border(Colors.redAccent) : InputBorder.none,
          border: useBorder ? border(Colors.black) : InputBorder.none,
        ),
      ),
    );
  }

  OutlineInputBorder border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2),
    );
  }
}

