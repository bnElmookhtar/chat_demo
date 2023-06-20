import 'package:flutter/material.dart';
import 'package:goat/data/_request.dart';

class Session {
  static int? _userId;
  static String? _userName;
  static String? _userPhone;

  static get userId => _userId;
  static get userName => _userName;
  static get userPhone => _userPhone;

  static final ScrollController scrollController = ScrollController();

  static scroll() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      ),
    );
  }

  static login(String phone) async {
    final rows = await request({
      "q": "login",
      "phone": phone,
    });
    if (!rows[0].containsKey("m")) {
      _userId = rows[0]["id"];
      _userName = rows[0]["name"];
      _userPhone = rows[0]["phone"];
    }
    return rows;
  }

  static register(String name, String phone) async {
    final rows = await request({
      "q": "register",
      "name": name,
      "phone": phone,
    });
    if (!rows[0].containsKey("m")) {
      _userId = rows[0]["id"];
      _userName = rows[0]["name"];
      _userPhone = rows[0]["phone"];
    }
    return rows;
  }

  static updateName(String name) async {
    final rows = await request({
      "q": "update_name",
      "user_id": userId.toString(),
      "name": name,
    });
    if (!rows[0].containsKey("m")) {
      _userName = name;
    }
    return rows;
  }

  static updatePhone(String phone) async {
    final rows = await request({
      "q": "update_phone",
      "user_id": userId.toString(),
      "phone": phone,
    });
    if (!rows[0].containsKey("m")) {
      _userPhone = phone;
    }
    return rows;
  }
}
