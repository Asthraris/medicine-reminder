import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicine_reminder/model/med_item.dart';
import 'package:medicine_reminder/viewmodel/meds.dart';
import 'package:medicine_reminder/viewmodel/dates.dart';
import 'package:medicine_reminder/viewmodel/intakes.dart';
import 'package:medicine_reminder/view/widgets/medtile.dart';

class TodayMeds extends StatelessWidget {
  const TodayMeds({super.key});

  @override
  Widget build(BuildContext context) {
    final dateVM = context.watch<DateViewModel>();
    final medVM = context.watch<MedicationViewModel>();
    final intakeVM = context.watch<IntakeViewModel>();

    final selectedDate = dateVM.selectedDate;

    final List<MedItem> displayMeds = medVM.getSortedMedsForDate(selectedDate);

    if (displayMeds.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.health_and_safety,
              size: 64,
              color: Color.fromARGB(255, 53, 145, 0),
            ),
            SizedBox(height: 16),
            Text(
              "No medications scheduled for today",
              style: TextStyle(
                color: Color.fromARGB(255, 53, 145, 0),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: displayMeds.length,
      padding: const EdgeInsets.only(bottom: 100, top: 10),
      itemBuilder: (context, index) {
        final med = displayMeds[index];

        return Consumer2<MedicationViewModel, IntakeViewModel>(
          builder: (_, medVM, intakeVM, __) {
            final bool taken = intakeVM.isTaken(med.id, selectedDate);
            final bool missed = intakeVM.isMissed(med, selectedDate);
            final bool withinGrace = intakeVM.canTake(med, selectedDate);

            return MedicationTile(
              item: med,
              taken: taken,
              missed: missed,
              withinGrace: withinGrace,
              onTap: () => intakeVM.take(med, selectedDate),
              onCancelToday: () async {
                await intakeVM.cancelToday(med.id, selectedDate);
              },
              onDelete: () async {
                final medVM = context.read<MedicationViewModel>();
                final intakeVM = context.read<IntakeViewModel>();

                medVM.deleteMedicationWithCleanup(med, intakeVM);
              },
            );
          },
        );
      },
    );
  }
}
