import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_reminder/core/utils.dart';
import 'package:medicine_reminder/model/med_item.dart';

import 'package:provider/provider.dart';
import 'package:medicine_reminder/viewmodel/meds.dart';
// Assuming your DosageType enum is available
// enum DosageType { mg, gm, kg, ml, pcs }

class AddMed extends StatefulWidget {
  const AddMed({super.key});
  @override
  State<AddMed> createState() => _AddMedState();
}

class _AddMedState extends State<AddMed> {
  // 1. Controllers for text input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();

  // 2. Form State variables
  // DosageType _selectedType = DosageType.mg;
  DosageType _selectedUnit = DosageType.pcs;
  DateTime _selectedTime = DateTime.now();

  bool _isRecurring = false;

  // 3. Weekday Selection (1 = Mon, 7 = Sun as per Dart standard)
  List<int> _selectedDays = [];

  final List<String> _daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Medicine",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset App",
            onPressed: () => AppUtilities.performFactoryReset(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Name Field ---
            _buildLabel("Medicine Name"),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration("e.g. Paracetamol"),
            ),
            const SizedBox(height: 20),

            // --- Dosage & Unit ---
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Dosage"),
                      TextFormField(
                        controller: _dosageController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration("Amount"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Unit"),
                      DropdownButtonFormField<DosageType>(
                        decoration: _inputDecoration("Type"),
                        items: DosageType.values.map((DosageType type) {
                          // 👈 2. Map Enum values
                          return DropdownMenuItem<DosageType>(
                            value: type,
                            child: Text(
                              type.name,
                            ), // This displays "mg", "ml", etc.
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedUnit =
                                  val; // Now types match (DosageType = DosageType)
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Time Picker ---
            _buildLabel("Schedule Time"),
            InkWell(
              onTap: () async {
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_selectedTime),
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = DateTime(
                      _selectedTime.year,
                      _selectedTime.month,
                      _selectedTime.day,
                      time.hour,
                      time.minute,
                    );
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: _boxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(_selectedTime),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Repeat Logic ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel("Repeat Weekly"),

                Switch(
                  value: _isRecurring,
                  onChanged: (val) {
                    setState(() {
                      _isRecurring = val;

                      // If toggled ON, select every day (1 to 7)
                      _selectedDays = _isRecurring ? [1, 2, 3, 4, 5, 6, 7] : [];
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                int dayNum = index + 1; // 1 = Mon
                bool isSelected = _selectedDays.contains(dayNum);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected
                          ? _selectedDays.remove(dayNum)
                          : _selectedDays.add(dayNum);
                      _isRecurring != _isRecurring;
                    });
                  },
                  child: SizedBox(
                    height: 30,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      child: Text(
                        _daysOfWeek[index],
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 25),

            // --- Info Field ---
            _buildLabel("Additional Info"),
            TextFormField(
              controller: _infoController,
              maxLines: 1,
              decoration: _inputDecoration("Take after food"),
            ),
            const SizedBox(height: 40),

            // --- Final Schedule Button ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: submitMed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Schedule Medication",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper UI methods to keep build() clean
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    ),
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.grey[100],
    borderRadius: BorderRadius.circular(12),
  );

  void submitMed() {
    // 1. Data Collection & Validation
    final String name = _nameController.text.trim();
    final String dosageStr = _dosageController.text.trim();
    final String info = _infoController.text.trim();

    // Basic Validation Check
    if (name.isEmpty) {
      _showErrorSnackBar("Please enter the medicine name");
      return;
    }
    if (dosageStr.isEmpty || int.tryParse(dosageStr) == null) {
      _showErrorSnackBar("Please enter a valid dosage amount");
      return;
    }

    // 2. Create the MedItem Instance
    final newMed = MedItem(
      id: DateTime.now().millisecondsSinceEpoch, // Unique ID based on time
      name: name,
      dosage: int.parse(dosageStr),
      type: _selectedUnit,
      addInfo: info,
      repeatDays: _selectedDays, // Empty if it's a one-time med
      scheduledTime: _selectedTime,
      isTaken: false,
    );

    // 3. Save to Hive via ViewModel
    try {
      // We use listen: false because we are inside a function, not the build method
      Provider.of<MedicationViewModel>(
        context,
        listen: false,
      ).addMedication(newMed);

      // 4. Success Feedback & Navigation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Medication scheduled successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Go back to Home Screen
    } catch (e) {
      _showErrorSnackBar("Failed to save medication: $e");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
