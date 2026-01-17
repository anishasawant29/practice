import 'package:flutter/material.dart';
import 'medicine.dart';

class AddMedicineScreen extends StatelessWidget {
  const AddMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final doseCtrl = TextEditingController();
    final ValueNotifier<TimeOfDay?> selectedTime = ValueNotifier(null);

    Future<void> pickTime() async {
      final t = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 9, minute: 0),
      );
      if (t != null) selectedTime.value = t;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Add Medicine")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Medicine Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter medicine name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: doseCtrl,
                decoration: const InputDecoration(
                  labelText: "Dose (ex: 1 tablet)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Enter dose" : null,
              ),
              const SizedBox(height: 12),

              ValueListenableBuilder<TimeOfDay?>(
                valueListenable: selectedTime,
                builder: (_, t, __) {
                  return ListTile(
                    title: Text(t == null ? "Pick Time" : "Time: ${t.format(context)}"),
                    trailing: const Icon(Icons.access_time),
                    onTap: pickTime,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;

                  if (selectedTime.value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select time")),
                    );
                    return;
                  }

                  final now = DateTime.now();
                  final t = selectedTime.value!;
                  final todayTime = DateTime(now.year, now.month, now.day, t.hour, t.minute);

                  final scheduleTime =
                      todayTime.isBefore(now) ? todayTime.add(const Duration(days: 1)) : todayTime;

                  final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

                  final med = Medicine(
                    id: id,
                    name: nameCtrl.text.trim(),
                    dose: doseCtrl.text.trim(),
                    time: scheduleTime,
                  );

                  Navigator.pop(context, med);
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
