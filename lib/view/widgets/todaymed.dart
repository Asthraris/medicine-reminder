import 'package:flutter/material.dart';

//get medItem
import 'package:medicine_reminder/model/med_item.dart';
import 'package:medicine_reminder/view/widgets/medtile.dart';

class TodayMeds extends StatefulWidget {
  const TodayMeds({super.key});

  @override
  State<TodayMeds> createState() => _TodayMedsState();
}

class _TodayMedsState extends State<TodayMeds> {
  //static data for ui
  List<MedItem> _medications = [
    MedItem(
      id: 1,
      name: "Vitamin C",
      dosage: 500,
      type: DosageType.mg,
      addInfo: "After breakfast",
      scheduledTime: DateTime.now().copyWith(hour: 8, minute: 30),
    ),
    MedItem(
      id: 2,
      name: "Metformin",
      dosage: 1,
      type: DosageType.pcs,
      addInfo: "Before dinner",
      scheduledTime: DateTime.now().copyWith(hour: 20, minute: 0),
    ),
  ];

  void _handleToggle(int index) {
    setState(() {
      _medications[index] = _medications[index].copyWith(
        isTaken: !_medications[index].isTaken,
      );
    });
    // TODO: Add your Database Update logic here!
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // shrinkWrap: true, // Only use if NOT inside Expanded
      itemCount: _medications.length,
      padding: const EdgeInsets.only(bottom: 100), // Space for FAB
      itemBuilder: (context, index) {
        final med = _medications[index];

        return MedicationTile(
          item: med,
          onTap: () {
            // This calls the logic in your ViewModel
            // viewModel.toggleTakenStatus(med.id);
          },
        );
      },
    );
  }
}
