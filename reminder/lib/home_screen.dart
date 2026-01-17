import 'package:flutter/material.dart';
import 'app_state.dart';
import 'medicine.dart';
import 'notification_service.dart';
import 'storage_service.dart';
import 'add_medicine_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _addMedicine(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
    );

    if (result != null && result is Medicine) {
      final list = List<Medicine>.from(AppState.medicines.value);
      list.add(result);
      AppState.medicines.value = list;

      await StorageService.saveMedicines(list);
      await NotificationService.scheduleDaily(
        id: result.id,
        name: result.name,
        dose: result.dose,
        time: result.time,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved & Notification Scheduled")),
      );
    }
  }

  Future<void> _deleteMedicine(BuildContext context, Medicine m) async {
    final list = List<Medicine>.from(AppState.medicines.value);
    list.removeWhere((x) => x.id == m.id);
    AppState.medicines.value = list;

    await StorageService.saveMedicines(list);
    await NotificationService.cancel(m.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicine Reminder"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMedicine(context),
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder<List<Medicine>>(
        valueListenable: AppState.medicines,
        builder: (_, list, __) {
          if (list.isEmpty) {
            return const Center(child: Text("No medicine added"));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final m = list[i];
              final t = TimeOfDay.fromDateTime(m.time).format(context);

              return Card(
                child: ListTile(
                  title: Text(m.name),
                  subtitle: Text("Dose: ${m.dose} | Time: $t"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteMedicine(context, m),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
