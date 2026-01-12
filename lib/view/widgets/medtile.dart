import 'package:flutter/material.dart';
import 'package:medicine_reminder/model/med_item.dart';
import 'package:intl/intl.dart';

class MedicationTile extends StatelessWidget {
  final MedItem item;
  final bool taken;
  final bool missed;
  final bool withinGrace;
  final VoidCallback onTap;

  const MedicationTile({
    super.key,
    required this.item,
    required this.taken,
    required this.missed,
    required this.withinGrace,
    required this.onTap,
  });

  Color _backgroundColor() {
    if (taken) return Colors.green.withOpacity(0.1);
    if (missed) return Colors.red.withOpacity(0.1);
    if (withinGrace) return Colors.orange.withOpacity(0.1);
    return Colors.white;
  }

  Color _iconColor() {
    if (taken) return Colors.green;
    if (missed) return Colors.red;
    if (withinGrace) return Colors.orange;
    return Colors.grey;
  }

  IconData _icon() {
    return taken ? Icons.check_circle : Icons.radio_button_unchecked;
  }

  TextDecoration? _titleDecoration() {
    return taken ? TextDecoration.lineThrough : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor(),
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
            decoration: _titleDecoration(),
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
              icon: Icon(_icon(), color: _iconColor(), size: 30),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
