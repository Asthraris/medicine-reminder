import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                      DropdownButtonFormField(
                        decoration: _inputDecoration("Type"),
                        items: const [
                          DropdownMenuItem(value: "mg", child: Text("mg")),
                          DropdownMenuItem(value: "ml", child: Text("ml")),
                          DropdownMenuItem(value: "pcs", child: Text("pcs")),
                        ],
                        onChanged: (val) {},
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
                  onChanged: (val) => setState(() => _isRecurring = val),
                ),
              ],
            ),

            if (_isRecurring) ...[
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
                      });
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      child: Text(
                        _daysOfWeek[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
            const SizedBox(height: 20),

            // --- Info Field ---
            _buildLabel("Additional Info"),
            TextFormField(
              controller: _infoController,
              maxLines: 2,
              decoration: _inputDecoration("e.g. Take after food"),
            ),
            const SizedBox(height: 40),

            // --- Final Schedule Button ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Logic to build MedItem and send to ViewModel
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
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
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
}
