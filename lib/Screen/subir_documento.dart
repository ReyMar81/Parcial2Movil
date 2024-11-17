import 'package:flutter/material.dart';
import 'package:flutter_application_1/Service/api_service.dart';
import 'package:flutter_application_1/const/aap_colors.dart';
import 'package:flutter_application_1/const/app_styles.dart';
import 'package:file_picker/file_picker.dart';

class SubirDocumentoScreen extends StatefulWidget {
  final ApiService apiService;

  const SubirDocumentoScreen({super.key, required this.apiService});

  @override
  State<SubirDocumentoScreen> createState() => _SubirDocumentoScreenState();
}

class _SubirDocumentoScreenState extends State<SubirDocumentoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _ruta;
  String? _tipoDocumento;
  final DateTime _fechaSubida = DateTime.now();
  int? _idCita;
  int? _idHistorialMedico;

  Future<void> _seleccionarArchivo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _ruta = result.files.single.path;
      });
    }
  }

  Future<void> _subirDocumento() async {
    if (_formKey.currentState!.validate() && _ruta != null) {
      _formKey.currentState!.save();
      final datosDocumento = {
        'ruta': _ruta,
        'tipoDocumento': _tipoDocumento,
        'fechaSubida': _fechaSubida.toIso8601String(),
        'idCita': _idCita,
        'idHistorialMedico': _idHistorialMedico,
      };

      try {
        await widget.apiService.subirDocumento(datosDocumento);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Documento subido exitosamente')),
        );
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir documento: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un archivo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subir Documento',
          style: AppStyles.headline2.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.mainBlueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Tipo de Documento'),
                onSaved: (value) => _tipoDocumento = value,
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ID de Cita'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _idCita = int.tryParse(value ?? ''),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'ID de Historial Médico'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _idHistorialMedico = int.tryParse(value ?? ''),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _seleccionarArchivo,
                child: Text(_ruta == null
                    ? 'Seleccionar Archivo'
                    : 'Archivo Seleccionado'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _subirDocumento,
                child: const Text('Subir Documento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
