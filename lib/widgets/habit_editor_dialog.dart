import 'package:flutter/material.dart';

class HabitEditorDialog extends StatefulWidget {
  final String? habitName;
  final String? initialValue; // Add the initialValue parameter

  const HabitEditorDialog({Key? key, this.habitName, this.initialValue}) : super(key: key);

  @override
  _HabitEditorDialogState createState() => _HabitEditorDialogState();
}

class _HabitEditorDialogState extends State<HabitEditorDialog> {
  late TextEditingController _habitNameController;

  @override
  void initState() {
    super.initState();
    _habitNameController = TextEditingController(text: widget.habitName ?? widget.initialValue); // Use widget.initialValue
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Habit Editor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _habitNameController,
            decoration: const InputDecoration(
              labelText: 'Habit Name',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final habitName = _habitNameController.text;
            Navigator.of(context).pop(habitName);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
