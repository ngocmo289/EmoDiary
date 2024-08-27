import 'package:flutter/material.dart';

class Diary {
  final String id;
  final String dateId;
  final String title;
  final String story;
  final String img;
  final String voice;
  final String time;
  final String address;
  bool favorite;
  final int rateEmotion;

  Diary(this.id, this.dateId, this.title, this.story, this.img,
      this.voice, this.time, this.address, this.favorite, this.rateEmotion);

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      json['_id'],
      json['dateId'],
      json['title'],
      json['story'],
      json['img'],
      json['voice'],
      json['time'],
      json['address'],
      _parseBoolean(json['favorite']),
      _parseInt(json['rateEmotion']),
    );
  }
  static bool _parseBoolean(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return false; // Default value if parsing fails
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? 0; // Default value if parsing fails
    }
    return 0; // Default value if parsing fails
  }
}


class DiaryProvider with ChangeNotifier {
  Diary? _diary;

  Diary? get diary => _diary;

  void setDiary(Diary diary) {
    _diary = diary;
    notifyListeners();
  }

  void updateDiary({
    String? id,
    String? dateId,
    String? title,
    String? story,
    String? img,
    String? voice,
    String? time,
    String? address,
    bool? favorite,
    int? rateEmotion,
  }) {
    if (_diary != null) {
      _diary = Diary(
        id ?? _diary!.id,
        dateId ?? _diary!.dateId,
        title ?? _diary!.title,
        story ?? _diary!.story,
        img ?? _diary!.img,
        voice ?? _diary!.voice,
        time ?? _diary!.time,
        address ?? _diary!.address,
        favorite ?? _diary!.favorite,
        rateEmotion ?? _diary!.rateEmotion,
      );
      notifyListeners();
    }
  }

  void clearDiary() {
    _diary = null;
    notifyListeners();
  }
}