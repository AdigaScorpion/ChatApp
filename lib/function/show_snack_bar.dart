import 'package:chat_app/shared/constants.dart';
import 'package:flutter/material.dart';

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(fontSize: 14)),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
          label: "ok",
          onPressed: () {},
          textColor: CustomColors.primaryBackgroundColor)));
}
