import 'package:flutter/material.dart';
import 'package:medicine_reminder/model/med_item.dart';
import 'package:intl/intl.dart';

class MedicationTile extends StatefulWidget {
  final MedItem item;
  final bool taken;
  final bool missed;
  final bool withinGrace;
  final VoidCallback onTap;
  final VoidCallback onCancelToday;
  final VoidCallback onDelete;

  const MedicationTile({
    super.key,
    required this.item,
    required this.taken,
    required this.missed,
    required this.withinGrace,
    required this.onTap,
    required this.onCancelToday,
    required this.onDelete,
  });

  @override
  State<MedicationTile> createState() => _MedicationTileState();
}

class _MedicationTileState extends State<MedicationTile> {
  bool actionMode = false;

  void _enterActionMode() {
    setState(() => actionMode = true);
  }

  void _exitActionMode() {
    setState(() => actionMode = false);
  }

  Color _backgroundColor() {
    if (widget.taken) return Colors.green.withOpacity(0.1);
    if (widget.missed) return Colors.red.withOpacity(0.1);
    if (widget.withinGrace) return Colors.orange.withOpacity(0.1);
    return Colors.white;
  }

  Color _iconColor() {
    if (widget.taken) return Colors.green;
    if (widget.missed) return Colors.red;
    if (widget.withinGrace) return Colors.orange;
    return Colors.grey;
  }

  IconData _icon() {
    return widget.taken ? Icons.check_circle : Icons.radio_button_unchecked;
  }

  TextDecoration? _titleDecoration() {
    return widget.taken ? TextDecoration.lineThrough : null;
  }

  Widget _normalView() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 72),
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 3,
          ),

          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('hh:mm').format(widget.item.scheduledTime),
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                DateFormat('a').format(widget.item.scheduledTime).toLowerCase(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 0, 147, 113),
                ),
              ),
            ],
          ),

          title: Text(
            widget.item.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: _titleDecoration(),
            ),
          ),

          subtitle: Text(widget.item.addInfo),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.item.dosage}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.item.type.name.toUpperCase(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(width: 15),

              if (widget.withinGrace && !widget.taken)
                IconButton(
                  icon: const Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.orange,
                    size: 30,
                  ),
                  onPressed: widget.onTap,
                )
              else if (widget.taken)
                const Icon(Icons.check_circle, color: Colors.green, size: 30)
              else if (widget.missed)
                const Icon(Icons.cancel, color: Colors.red, size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.item.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  widget.onCancelToday();
                  _exitActionMode();
                },
                icon: const Icon(Icons.cancel, color: Colors.orange),
                label: const Text(
                  "Cancel today",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _enterActionMode,
      onTap: actionMode ? _exitActionMode : widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: BorderRadius.circular(15),
        ),
        child: actionMode ? _actionView() : _normalView(),
      ),
    );
  }
}
