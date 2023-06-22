import 'package:flutter/material.dart';
import '../data/habit.dart';
import '../data/database_helper.dart';
import '../widgets/habit_tile.dart';
import '../widgets/habit_editor_dialog.dart';
import '../widgets/habit_reminder_dialog.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HabitListScreenState createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  late DatabaseHelper _databaseHelper;
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
    _refreshHabitList();
  }

  Future<void> _refreshHabitList() async {
    final List<Habit> habitList = await _databaseHelper.getHabits();
    setState(() {
      _habits = habitList;
    });
  }

  Future<void> _addHabit() async {
    final habitName = await showDialog<String>(
      context: context,
      builder: (context) => const HabitEditorDialog(),
    );

    if (habitName != null && habitName.isNotEmpty) {
      final newHabit = Habit(
        id: DateTime.now().microsecondsSinceEpoch,
        name: habitName,
        reminder: null,
      );

      setState(() {
        _habits.add(newHabit);
      });

      await _databaseHelper.insertHabit(newHabit);
    }
  }

  Future<void> _setReminder(Habit habit) async {
    final selectedDateTime = await showDialog<DateTime>(
      context: context,
      builder: (context) => HabitReminderDialog(initialValue: habit.reminder, habitName: habit.name),
    );

    if (selectedDateTime != null) {
      habit.reminder = selectedDateTime;
      await _databaseHelper.updateHabit(habit);
      _refreshHabitList();
    }
  }

  Future<void> _cancelReminder(Habit habit) async {
    habit.reminder = null;
    await _databaseHelper.updateHabit(habit);
    _refreshHabitList();
  }

  Future<void> _toggleHabitCompletion(Habit habit) async {
    habit.isCompleted = !habit.isCompleted;
    await _databaseHelper.updateHabit(habit);
    _refreshHabitList();
  }

  Future<void> _editHabit(Habit habit) async {
    final editedHabitName = await showDialog<String>(
      context: context,
      builder: (context) => HabitEditorDialog(initialValue: habit.name),
    );

    if (editedHabitName != null && editedHabitName.isNotEmpty) {
      habit.name = editedHabitName;
      await _databaseHelper.updateHabit(habit);
      _refreshHabitList();
    }
  }

  Future<void> _deleteHabit(Habit habit) async {
    await _databaseHelper.deleteHabit(habit.id);
    setState(() {
      _habits.remove(habit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          final habit = _habits[index];
          return HabitTile(
            habit: habit,
            onTap: () => _toggleHabitCompletion(habit),
            onLongPress: () => _editHabit(habit),
            onDelete: () => _deleteHabit(habit),
            onSetReminder: () => _setReminder(habit),
            onCancelReminder: () => _cancelReminder(habit),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}
