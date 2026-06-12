import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final dynamic prefixIcon;
  final bool obscureText;
  final dynamic endIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.endIcon,
    required this.validator,
    this.onChanged,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              widget.prefixIcon is IconData
                  ? Icon(widget.prefixIcon)
                  : FaIcon(widget.prefixIcon, size: 20),
        ),
        suffixIcon:
            widget.obscureText
                ? IconButton(
                  icon: FaIcon(
                    _isObscured
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
                : widget.endIcon != null
                ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:
                      widget.endIcon is IconData
                          ? Icon(widget.endIcon)
                          : FaIcon(widget.endIcon, size: 20),
                )
                : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
    );
  }
}
