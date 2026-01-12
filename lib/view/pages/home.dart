import 'package:flutter/material.dart';
import 'package:medicine_reminder/view/pages/addmed.dart';
import 'package:medicine_reminder/view/widgets/datescrolller.dart';
import 'package:medicine_reminder/viewmodel/dates.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel_date = DateViewModel();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 120),
              child: Text(
                "hi user", //Change it later

                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DateScroller(
              dates: viewModel_date.dates,
              selectedDate: viewModel_date.selectedDate,
              onDateSelected: viewModel_date.selectDate,
            ),
            const SizedBox(height: 22),
            Text(
              "Todays Meds.",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMed()),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 4,
        highlightElevation: 8,
        label: const Text(
          "Add",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        icon: Icon(Icons.medication),
      ),
    );
  }
}
