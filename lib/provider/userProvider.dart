import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String password;
  final String birthday;
  final String name;
  final String imgAvt;

  User(this.id, this.email, this.password, this.birthday, this.name, this.imgAvt);
}


class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void updateUser({
    String? id,
    String? email,
    String? password,
    String? birthday,
    String? name,
    String? imgAvt,
  }) {
    if (_user != null) {
      _user = User(
        id ?? _user!.id,
        email ?? _user!.email,
        password ?? _user!.password,
        birthday ?? _user!.birthday,
        name ?? _user!.name,
        imgAvt ?? _user!.imgAvt
      );
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}