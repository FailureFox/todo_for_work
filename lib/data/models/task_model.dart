import 'package:flutter/cupertino.dart';

class TaskModel {
  final String text;
  final DateTime time;
  final bool isCompleted;
  final bool isAlert;
  final TaskCategory category;

  const TaskModel({
    required this.text,
    required this.time,
    required this.isAlert,
    required this.isCompleted,
    required this.category,
  });

  factory TaskModel.fromMap(Map map) {
    return TaskModel(
      text: map['text'],
      time: map['time'],
      isAlert: map['isAlert'],
      isCompleted: map['isCompleted'],
      category: categoryFromString[map['category']],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'time': time,
      'isAlert': isAlert,
      'isCompleted': isCompleted,
      'category': category.name,
    };
  }

  TaskModel copyWith({
    String? text,
    DateTime? time,
    bool? isCompleted,
    bool? isAlert,
    TaskCategory? category,
  }) {
    return TaskModel(
      text: text ?? this.text,
      time: time ?? this.time,
      isAlert: isAlert ?? this.isAlert,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
    );
  }

  static const Map categoryFromString = {
    'personal': TaskCategory.personal,
    'meeting': TaskCategory.meeting,
    'shopping': TaskCategory.shopping,
    'work': TaskCategory.work,
  };
}

class TaskColor {
  static const Map<TaskCategory, Color> taskCategoryColor = {
    TaskCategory.personal: Color(0xFFFFD506),
    TaskCategory.meeting: Color(0xFFD10263),
    TaskCategory.shopping: Color(0xFFEC6C0B),
    TaskCategory.work: Color(0xFF1ED102),
  };
}

enum TaskCategory { personal, meeting, shopping, work }
