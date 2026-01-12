import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/app_theme.dart';
import 'package:medicine_reminder/view/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:medicine_reminder/viewmodel/dates.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DateViewModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medicine Reminder',
      theme: AppTheme.mainTheme,
      home: MyHome(),
    );
  }
}
