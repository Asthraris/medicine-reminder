import 'package:flutter/material.dart';
import 'package:medicine_reminder/model/med_item.dart';
import 'package:intl/intl.dart';

class MedicationTile extends StatelessWidget {
  final MedItem item;
  final VoidCallback onTap;

  const MedicationTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: item.isTaken
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('hh:mm').format(item.scheduledTime),
              style: const TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              DateFormat('a').format(item.scheduledTime).toLowerCase(),
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 0, 147, 113),
              ),
            ),
          ],
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            decoration: item.isTaken ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(item.addInfo),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${item.dosage}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.type.name.toUpperCase(),
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
            const SizedBox(width: 15),
            IconButton(
              icon: Icon(
                item.isTaken
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: item.isTaken ? Colors.green : Colors.grey,
                size: 30,
              ),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
