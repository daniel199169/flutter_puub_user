import 'package:flutter/material.dart';

class PuubTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isSecret;
  final String labelText;
  final Function validator;
  final Function onSaved;
  PuubTextField({
    this.controller,
    this.isSecret,
    this.labelText,
    this.validator,
    this.onSaved,
  });
  @override
  _PuubTextFieldState createState() => _PuubTextFieldState();
}

class _PuubTextFieldState extends State<PuubTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        autofocus: false,
        controller: widget.controller,
        validator: widget.validator,
        onSaved: widget.onSaved,
        obscureText: widget.isSecret,
        decoration: InputDecoration(
          labelText: widget.labelText,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 12.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            /*borderSide: BorderSide(
              width: 0,
            ),*/
          ),
        ),
      ),
    );
  }
}
