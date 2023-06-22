import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class HabitReminderDialog extends StatefulWidget {
  final DateTime? initialValue;
  final String habitName; // New parameter for habit name

  const HabitReminderDialog({Key? key, this.initialValue, required this.habitName}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HabitReminderDialogState createState() => _HabitReminderDialogState();
}

class _HabitReminderDialogState extends State<HabitReminderDialog> {
  late TimeOfDay _selectedTime;
  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
    if (widget.initialValue != null) {
      _selectedTime = TimeOfDay.fromDateTime(widget.initialValue!);
    }

    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> _saveReminder() async {
    final selectedDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    await _scheduleNotification(selectedDateTime);
    // ignore: use_build_context_synchronously
    Navigator.pop(context, selectedDateTime);
  }

  Future<void> _scheduleNotification(DateTime selectedDateTime) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'habit_tracker_channel',
      'Habit Tracker',
      importance: Importance.high,
      priority: Priority.high,
    );
    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _notificationsPlugin.zonedSchedule(
      0,
      'Habit Reminder',
      'It\'s time to work on your habit: ${widget.habitName}!', // Use widget.habitName to access the habit name
      tz.TZDateTime.from(selectedDateTime, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Reminder'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Time'),
            trailing: Text(
              '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
            ),
            onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (pickedTime != null) {
                setState(() {
                  _selectedTime = pickedTime;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveReminder,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
