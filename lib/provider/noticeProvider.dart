import 'package:flutter/material.dart';

class Notice {
  final String id;
  final List<String> dateId;
  final String userId;
  final String title;
  final String des;
  final String date;
  final String time;
  final String key;

  Notice(
      this.id,
      this.dateId,
      this.userId,
      this.title,
      this.des,
      this.date,
      this.time, {
        this.key = "",  // Set default value for key
      });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      json['_id'],
      (json['dateId'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],  // Ensure it's an iterable and convert to List<String>
      json['userId'],
      json['title'],
      json['des'],
      json['date'],
      json['time'],
      key: json['key'] ?? "",  // Set default value for key in factory
    );
  }
}

class NoticeProvider with ChangeNotifier {
  Notice? _notice;

  Notice? get notice => _notice;

  void setNotice(Notice notice) {
    _notice = notice;
    notifyListeners();
  }

  void updateNotice({
    String? id,
    List<String>? dateId,
    String? userId,
    String? title,
    String? date,
    String? time,
    String? des,
    String? key,
  }) {
    if (_notice != null) {
      _notice = Notice(
        id ?? _notice!.id,
        dateId ?? _notice!.dateId,
        userId ?? _notice!.userId,
        title ?? _notice!.title,
        des ?? _notice!.des,
        date ?? _notice!.date,
        time ?? _notice!.time,
        key: key ?? _notice!.key,  // Keep the existing key if not provided
      );
      notifyListeners();
    }
  }

  void clearNotice() {
    _notice = null;
    notifyListeners();
  }
}
