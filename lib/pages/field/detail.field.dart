// ignore_for_file: unused_field

import 'package:api_flutter/pages/field/edit_field.dart';
import 'package:api_flutter/services/field_service.dart';
import 'package:flutter/material.dart';
import 'package:api_flutter/models/field_model.dart';
import 'package:api_flutter/services/booking_service.dart';

class FieldDetailPage extends StatefulWidget {
  final DataField field;

  const FieldDetailPage({super.key, required this.field});

  @override
  State<FieldDetailPage> createState() => _FieldDetailPageState();
}

class _FieldDetailPageState extends State<FieldDetailPage> {
  bool _isLoading = false;

  Future<void> deleteField() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Hapus field"),
            content: Text("Yakin ingin menghapus \"${widget.field.name}\"?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Hapus"),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      final success = await FieldService.deleteField(widget.field.id!);
      if (success && mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("\"${widget.field.name}\" berhasil dihapus")),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.field.name!),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isLoading ? null : deleteField,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'http://127.0.0.1:8000/storage/${widget.field.img}',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.field.name!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Tipe: ${widget.field.type}"),
                  const SizedBox(height: 4),
                  Text("Harga: Rp${widget.field.pricePerHour} /jam"),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit"),
                          onPressed: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        EditFieldPage(field: widget.field),
                              ),
                            );
                            if (updated == true && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Field berhasil diperbarui'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text("Booking"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed:
                              _isLoading
                                  ? null
                                  : () async {
                                    final now = DateTime.now();

                                    // Pilih tanggal mulai
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: now,
                                      firstDate: now,
                                      lastDate: DateTime(now.year + 1),
                                      locale: const Locale('id', 'ID'),
                                    );

                                    if (pickedDate == null) return; // batal

                                    // Pilih jam mulai
                                    final pickedStartTime =
                                        await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(
                                            now,
                                          ),
                                        );

                                    if (pickedStartTime == null)
                                      return; // batal

                                    // Pilih jam selesai
                                    final pickedEndTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                        now.add(const Duration(hours: 2)),
                                      ),
                                    );

                                    if (pickedEndTime == null) return; // batal

                                    // Gabung tanggal & waktu
                                    final startDateTime = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedStartTime.hour,
                                      pickedStartTime.minute,
                                    );

                                    final endDateTime = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedEndTime.hour,
                                      pickedEndTime.minute,
                                    );

                                    if (endDateTime.isBefore(startDateTime)) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Waktu selesai harus setelah waktu mulai',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    setState(() => _isLoading = true);
                                    final success =
                                        await BookingService.createBooking(
                                          fieldId: widget.field.id!,
                                          startTime:
                                              startDateTime.toIso8601String(),
                                          endTime:
                                              endDateTime.toIso8601String(),
                                          status: "pending",
                                        );
                                    setState(() => _isLoading = false);

                                    if (success && mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Booking berhasil dibuat',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Gagal membuat booking',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
