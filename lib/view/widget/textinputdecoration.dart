import 'package:chat_app/shared/constants.dart';
import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle:TextStyle(color: CustomColors.primaryTextColor,fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: CustomColors.primaryColor, width: 2)),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: CustomColors.inActiveColor, width: 2)),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: CustomColors.errorColor, width: 2)),

);

