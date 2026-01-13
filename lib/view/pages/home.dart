import 'package:flutter/material.dart';
import 'package:medicine_reminder/view/pages/addmed.dart';
import 'package:medicine_reminder/view/widgets/datescrolller.dart';
import 'package:medicine_reminder/view/widgets/todaymed.dart';
import 'package:medicine_reminder/viewmodel/dates.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  String get _greeting {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final viewModelDate = DateViewModel();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 160, top: 75),
              child: Text(
                _greeting, //Change it later

                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DateScroller(
              dates: viewModelDate.dates,
              selectedDate: viewModelDate.selectedDate,
              onDateSelected: viewModelDate.selectDate,
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
            const Expanded(child: TodayMeds()),
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
