import 'package:api_flutter/pages/field/edit_field.dart';
import 'package:api_flutter/services/field_service.dart';
import 'package:flutter/material.dart';
import 'package:api_flutter/models/field_model.dart';

class FieldDetailPage extends StatefulWidget {
  final Field field;

  const FieldDetailPage({super.key, required this.field});

  @override
  State<FieldDetailPage> createState() => _FieldDetailPageState();
}

class _FieldDetailPageState extends State<FieldDetailPage> {
  late Future<List<Field>> _fields;

  @override
  void initState() {
    super.initState();
    _fields = FieldService.getFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.field.name)),
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
                    widget.field.name,
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
                                    (context) => EditFieldPage(
                                      field: widget.field,
                                    ), // kirim data field
                              ),
                            );

                            if (updated == true) {
                              // refresh data lamun balik ti edit
                              setState(() {
                                _fields = FieldService.getFields();
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: const Text("Hapus"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            // konfirmasi hapus
                            showDialog(
                              context: context,
                              builder:
                                  (ctx) => AlertDialog(
                                    title: const Text("Konfirmasi"),
                                    content: const Text(
                                      "Apakah anda yakin ingin menghapus lapangan ini?",
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text("Batal"),
                                        onPressed: () => Navigator.pop(ctx),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: const Text("Hapus"),
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text("Lapangan dihapus"),
                                            ),
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                            );
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
