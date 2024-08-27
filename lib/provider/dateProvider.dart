import 'package:flutter/material.dart';

class Date {
  final String id;
  final String userId;
  final String date;

  Date(this.id, this.userId, this.date);

  // Factory constructor to create a Date object from JSON
  factory Date.fromJson(Map<String, dynamic> json) {
    return Date(
      json['_id'] as String,         // Ensure you cast to String
      json['userId'] as String,     // Ensure you cast to String
      json['date'] as String,       // Ensure you cast to String
    );
  }

}


class DateProvider with ChangeNotifier {
  Date? _date;

  Date? get date => _date;

  void setDate(Date date) {
    _date = date;
    notifyListeners();
  }

  void updateDate({
    String? id,
    String? userId,
    String? date,
  }) {
    if (_date != null) {
      _date = Date(
          id ?? _date!.id,
          userId ?? _date!.userId,
          date ?? _date!.date,
      );
      notifyListeners();
    }
  }

  void clearDate() {
    _date = null;
    notifyListeners();
  }
}