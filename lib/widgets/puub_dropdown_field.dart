import 'package:flutter/material.dart';

class PuubDropdownField extends StatefulWidget {
  final String selectedMenu;
  final List<String> menuItem;
  final Function onChanged;

  PuubDropdownField({
    this.selectedMenu,
    this.menuItem,
    this.onChanged,
  });
  @override
  _PuubDropdownFieldState createState() => _PuubDropdownFieldState();
}

class _PuubDropdownFieldState extends State<PuubDropdownField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(4),
          
        ),
        child: new DropdownButton<String>(
          isExpanded: true,
          underline: Container(),
          value: widget.selectedMenu,
          onChanged: widget.onChanged,
          hint: Text('Title'),
          items: widget.menuItem.map((String label) {
            return new DropdownMenuItem<String>(
              value: label,
              child: new Text(
                label,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
