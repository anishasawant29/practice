import 'package:flutter/material.dart';
import 'medicine.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onDelete;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final timeText = TimeOfDay.fromDateTime(medicine.time).format(context);

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected: ${medicine.name}")),
        );
      },
      onLongPress: onDelete, // LongPress delete (syllabus)
      child: Card(
        child: ListTile(
          title: Text(medicine.name),
          subtitle: Text("Dose: ${medicine.dose} | Time: $timeText"),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
