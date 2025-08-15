import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:api_flutter/models/field_model.dart';
import 'package:api_flutter/services/field_service.dart';
import 'package:api_flutter/pages/field/detail.field.dart';
import 'package:api_flutter/pages/field/create_field.dart'; // halaman create

class FieldPage extends StatefulWidget {
  const FieldPage({super.key});

  @override
  State<FieldPage> createState() => _FieldPageState();
}

class _FieldPageState extends State<FieldPage> {
  late Future<Field> _fields;

  @override
  void initState() {
    super.initState();
    _fields = FieldService.getFields();
  }

  void _loadData() {
    setState(() {
      _fields = FieldService.getFields();
    });
  }

  final formatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 0 
);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Lapangan"),
        actions: [
          IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh)),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Tambah Lapangan",
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateFieldPage()),
              );
              // reload data kalau berhasil tambah
              if (result == true) {
                _loadData();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Field>(
        future: _fields,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final fields = snapshot.data?.data ?? [];
          if (fields.isEmpty) {
            return const Center(child: Text("Tidak ada data lapangan"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3 / 4,
            ),
            itemCount: fields.length,
            itemBuilder: (context, index) {
              final field = fields[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FieldDetailPage(field: field),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          'http://127.0.0.1:8000/storage/${field.img}',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              field.name!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              field.type!,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${formatter.format(field.pricePerHour)} /jam",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
