import 'package:flutter/material.dart';
import 'package:flutter_application_1/Service/api_service.dart';
import 'package:flutter_application_1/const/app_styles.dart';
import 'package:flutter_application_1/const/aap_colors.dart';

class AseguradoraScreen extends StatefulWidget {
  final ApiService apiService;

  const AseguradoraScreen({super.key, required this.apiService});

  @override
  AseguradoraScreenState createState() => AseguradoraScreenState();
}

class AseguradoraScreenState extends State<AseguradoraScreen> {
  List<dynamic> _aseguradoras = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarAseguradoras();
  }

  Future<void> _cargarAseguradoras() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _aseguradoras = await widget.apiService.obtenerAseguradoras();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar aseguradoras')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _crearAseguradora() async {
    TextEditingController nombreController = TextEditingController();
    TextEditingController descripcionController = TextEditingController();
    TextEditingController contactoController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Aseguradora', style: AppStyles.headline2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la aseguradora',
                ),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
              ),
              TextField(
                controller: contactoController,
                decoration: const InputDecoration(
                  labelText: 'Contacto',
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (nombreController.text.isNotEmpty &&
                    descripcionController.text.isNotEmpty &&
                    contactoController.text.isNotEmpty) {
                  final success = await widget.apiService.crearAseguradora({
                    'nombre': nombreController.text,
                    'descripcion': descripcionController.text,
                    'contacto': contactoController.text,
                  });

                  if (success) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    _cargarAseguradoras();
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al crear aseguradora'),
                      ),
                    );
                  }
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, completa todos los campos'),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editarAseguradora(int id, String nombreActual,
      String descripcionActual, String contactoActual) async {
    TextEditingController nombreController =
        TextEditingController(text: nombreActual);
    TextEditingController descripcionController =
        TextEditingController(text: descripcionActual);
    TextEditingController contactoController =
        TextEditingController(text: contactoActual);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Aseguradora', style: AppStyles.headline2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la aseguradora',
                ),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
              ),
              TextField(
                controller: contactoController,
                decoration: const InputDecoration(
                  labelText: 'Contacto',
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (nombreController.text.isNotEmpty &&
                    descripcionController.text.isNotEmpty &&
                    contactoController.text.isNotEmpty) {
                  final success =
                      await widget.apiService.actualizarAseguradora(id, {
                    'nombre': nombreController.text,
                    'descripcion': descripcionController.text,
                    'contacto': contactoController.text,
                  });

                  if (success) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop(); // Cierra el diálogo
                    _cargarAseguradoras(); // Recarga la lista de aseguradoras
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al actualizar aseguradora'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, completa todos los campos'),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarAseguradora(int id) async {
    final success = await widget.apiService.eliminarAseguradora(id);
    if (success) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Eliminado con exito')),
      );
      _cargarAseguradoras();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'No se puede eliminar la aseguradora porque está asociada a pacientes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar Aseguradoras',
            style: AppStyles.headline2.copyWith(color: Colors.white)),
        backgroundColor: AppColors.mainBlueColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _aseguradoras.length,
              itemBuilder: (context, index) {
                final aseguradora = _aseguradoras[index];
                return ListTile(
                  title:
                      Text(aseguradora['nombre'], style: AppStyles.bodyText1),
                  subtitle: Text(aseguradora['descripcion'],
                      style: AppStyles.bodyText2),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editarAseguradora(
                            aseguradora['id'],
                            aseguradora['nombre'],
                            aseguradora['descripcion'],
                            aseguradora['contacto']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _eliminarAseguradora(aseguradora['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearAseguradora,
        backgroundColor: AppColors.mainBlueColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
