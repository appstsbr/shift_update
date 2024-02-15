import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shift_flutter/src/my_app.dart';
import 'package:shift_flutter/src/services/http_override.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}
