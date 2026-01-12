import 'package:flutter/material.dart';
import 'package:medicine_reminder/model/med_intake.dart';
import 'package:medicine_reminder/model/med_item.dart';
import 'package:medicine_reminder/model/date_item.dart';
import 'package:provider/provider.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:medicine_reminder/core/app_theme.dart';
import 'package:medicine_reminder/view/pages/home.dart';

import 'package:medicine_reminder/viewmodel/dates.dart';
import 'package:medicine_reminder/viewmodel/meds.dart';
import 'package:medicine_reminder/viewmodel/intakes.dart';

void main() async {
  //this init the app before leting flutter touch anything with db , required wile using db
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(MedItemAdapter());
  Hive.registerAdapter(DosageTypeAdapter());

  Hive.registerAdapter(DateItemAdapter());
  Hive.registerAdapter(DayFulfillmentAdapter());

  Hive.registerAdapter(MedIntakeAdapter());

  await Hive.openBox<MedItem>('medication_box');
  await Hive.openBox<DateItem>('history_box');
  await Hive.openBox<MedIntake>('intake_box');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicationViewModel()),
        ChangeNotifierProvider(create: (_) => DateViewModel()),
        ChangeNotifierProvider(create: (_) => IntakeViewModel()),
      ],
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
