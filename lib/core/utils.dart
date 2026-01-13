import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:provider/provider.dart';
import 'package:medicine_reminder/viewmodel/meds.dart';
import 'package:medicine_reminder/viewmodel/dates.dart';
import 'package:medicine_reminder/viewmodel/intakes.dart';

import 'package:medicine_reminder/model/date_item.dart';
import 'package:medicine_reminder/model/med_intake.dart';
import 'package:medicine_reminder/model/med_item.dart';

class AppUtilities {
  static Future<void> performFactoryReset(BuildContext context) async {
    bool confirm = await _showConfirmDialog(context);
    if (!confirm || !context.mounted) return;

    try {
      // Clear and Flush Hive
      final medBox = Hive.box<MedItem>('medication_box');
      final intakeBox = Hive.box<MedIntake>('intake_box');
      final historyBox = Hive.box<DateItem>('history_box');

      await medBox.clear();
      await intakeBox.clear();
      await historyBox.clear();

      // Verification check in console
      debugPrint("MedBox count after clear: ${medBox.length}");

      if (!context.mounted) return;

      // IMPORTANT: Refresh ViewModels
      Provider.of<MedicationViewModel>(
        context,
        listen: false,
      ).refreshAfterReset();
      Provider.of<IntakeViewModel>(context, listen: false).notifyListeners();
      Provider.of<DateViewModel>(context, listen: false).refreshAfterReset();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All data cleared successfully")),
      );
    } catch (e) {
      debugPrint("Reset Error: $e");
    }
  }

  static Future<bool> _showConfirmDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Factory Reset"),
            content: const Text(
              "This will delete all medications and history.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Reset", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }
}
