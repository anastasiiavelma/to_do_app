import 'package:flutter/material.dart';

class IntCheckbox extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;

  IntCheckbox({required this.value, required this.onChanged});

  @override
  _IntCheckboxState createState() => _IntCheckboxState();
}

class _IntCheckboxState extends State<IntCheckbox> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.value == 1 ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _isChecked,
      onChanged: (newValue) {
        setState(() {
          _isChecked = newValue!;
          widget.onChanged(_isChecked ? 2 : 1);
        });
      },
    );
  }
}
