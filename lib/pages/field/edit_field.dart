import 'package:flutter/material.dart';
import 'package:api_flutter/models/field_model.dart';
import 'package:api_flutter/services/field_service.dart';

class EditFieldPage extends StatefulWidget {
  final Field field;

  const EditFieldPage({super.key, required this.field});

  @override
  State<EditFieldPage> createState() => _EditFieldPageState();
}

class _EditFieldPageState extends State<EditFieldPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _priceController;
  late TextEditingController _imgController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.field.name);
    _typeController = TextEditingController(text: widget.field.type);
    _priceController = TextEditingController(text: widget.field.pricePerHour.toString());
    _imgController = TextEditingController(text: widget.field.img);
  }

  Future<void> _saveField() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      Field updatedField = Field(
        id: widget.field.id,
        name: _nameController.text,
        type: _typeController.text,
        pricePerHour: int.parse(_priceController.text),
        img: _imgController.text,
        locationId: widget.field.locationId,
        description: widget.field.description,
      );

      await FieldService.updateField(
        widget.field.id,
        _nameController.text,
        _typeController.text,
        double.parse(_priceController.text),
        _imgController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lapangan berhasil diperbarui')),
        );
        Navigator.pop(context, true); // balikin ke halaman sebelumnya
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update: $e')),
        );
      }
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Lapangan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Lapangan'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Tipe Lapangan'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga per Jam'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _imgController,
                decoration: const InputDecoration(labelText: 'URL Gambar'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveField,
                      child: const Text('Simpan Perubahan'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
