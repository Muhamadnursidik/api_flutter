import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:api_flutter/services/field_service.dart';

class CreateFieldPage extends StatefulWidget {
  const CreateFieldPage({super.key});

  @override
  State<CreateFieldPage> createState() => _CreateFieldPageState();
}

class _CreateFieldPageState extends State<CreateFieldPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _locationIdController = TextEditingController();
  final _typeController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  Uint8List? _imageBytes;
  String? _imageName;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationIdController.dispose();
    _typeController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageName = image.name;
      });
    }
  }

  Future<void> _createField() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await FieldService.createField(
      _nameController.text,
      int.parse(_locationIdController.text),
      _typeController.text,
      int.parse(_priceController.text),
      _descriptionController.text,
      _imageBytes,
      _imageName,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Field berhasil dibuat'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuat Field'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Lapangan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Lapangan"),
                validator:
                    (value) =>
                        value!.isEmpty ? "Nama tidak boleh kosong" : null,
              ),

              const SizedBox(height: 16),

              // Gambar
              if (_imageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    _imageBytes!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: Text(
                  _imageBytes == null ? 'Pilih Gambar' : 'Ganti Gambar',
                ),
              ),
              if (_imageBytes != null)
                TextButton.icon(
                  onPressed:
                      () => setState(() {
                        _imageBytes = null;
                        _imageName = null;
                      }),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Hapus Gambar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              TextFormField(
                controller: _locationIdController,
                decoration: const InputDecoration(labelText: "ID Lokasi"),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value!.isEmpty ? "Lokasi tidak boleh kosong" : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: "Tipe Lapangan"),
                validator:
                    (value) =>
                        value!.isEmpty ? "Tipe tidak boleh kosong" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Harga per Jam"),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value!.isEmpty ? "Harga tidak boleh kosong" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                maxLines: 3,
                validator:
                    (value) =>
                        value!.isEmpty ? "Deskripsi tidak boleh kosong" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _createField,
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
