class Habit {
  int id;
  String name;
  bool isCompleted;
  DateTime? reminder; // Add the reminder property

  Habit({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.reminder, // Initialize the reminder property
  });

Map<String, dynamic> toMap() {
  return {
    'id': id,
    'name': name,
    'isCompleted': isCompleted ? 1 : 0,
    'reminder': reminder?.millisecondsSinceEpoch, // Convert DateTime to milliseconds
  };
}

factory Habit.fromMap(Map<String, dynamic> map) {
  return Habit(
    id: map['id'],
    name: map['name'],
    isCompleted: map['isCompleted'] == 1,
    reminder: map['reminder'] != null ? DateTime.fromMillisecondsSinceEpoch(map['reminder']) : null, // Convert milliseconds to DateTime
  );
}


}
