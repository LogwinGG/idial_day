import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String? Function(String?)? validator;
  final void Function(DateTime)? onChanged;
  final DateTime? firstDate ;
  final DateTime? lastDate ;
  const DateInputField(
      {Key? key,
      required this.controller,
      required this.title,
      this.firstDate,
      this.lastDate,
      this.onChanged,
      this.validator})
      : super(key: key);

  @override
  _DateInputFieldState createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextFormField(
            controller: widget.controller,
            style: TextStyle(color: Colors.white),
            validator: widget.validator,
            readOnly: true,
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              labelText: widget.title,
            ),
          ),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate ?? DateTime(1946),
      lastDate: widget.lastDate ?? DateTime(DateTime.now().year + 11),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller.value = TextEditingValue(text: DateFormat('dd.MM.yyyy').format(picked));
      });

      if (widget.onChanged != null) {
        widget.onChanged!(picked);
      }
    }
  }
}
