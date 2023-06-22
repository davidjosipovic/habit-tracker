import 'package:flutter/material.dart';
import '../data/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;
  final VoidCallback onSetReminder;
  final VoidCallback onCancelReminder;

  const HabitTile({
    required this.habit,
    required this.onTap,
    required this.onLongPress,
    required this.onDelete,
    required this.onSetReminder,
    required this.onCancelReminder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      leading: CircleAvatar(
        backgroundColor: habit.isCompleted ? Colors.green : Colors.grey,
        child: Icon(
          habit.isCompleted ? Icons.check : Icons.pending,
          color: Colors.white,
        ),
      ),
      title: Text(
        habit.name,
        style: TextStyle(
          decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.alarm),
            onPressed: onSetReminder, // Add onSetReminder callback
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
