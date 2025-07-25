import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_helio/comum/configs/aplicativo.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(Aplicativo());
}
