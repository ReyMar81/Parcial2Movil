import 'package:flutter/material.dart';
import 'package:flutter_application_1/Service/api_service.dart';
import 'package:flutter_application_1/const/app_styles.dart';
import 'package:flutter_application_1/const/aap_colors.dart';

class EspecialidadesScreen extends StatefulWidget {
  final ApiService apiService;

  const EspecialidadesScreen({super.key, required this.apiService});

  @override
  EspecialidadesScreenState createState() => EspecialidadesScreenState();
}

class EspecialidadesScreenState extends State<EspecialidadesScreen> {
  List<dynamic> _especialidades = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarEspecialidades();
  }

  Future<void> _cargarEspecialidades() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _especialidades = await widget.apiService.obtenerEspecialidades();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar especialidades')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _crearEspecialidad() async {
    TextEditingController nombreController = TextEditingController();
    TextEditingController descripcionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Especialidad', style: AppStyles.headline2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la especialidad',
                ),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
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
                    descripcionController.text.isNotEmpty) {
                  final success = await widget.apiService.crearEspecialidades({
                    'nombre': nombreController.text,
                    'descripcion': descripcionController.text,
                  });

                  if (success) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    _cargarEspecialidades();
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al crear especialidad'),
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

  Future<void> _editarEspecialidad(
      int id, String nombreActual, String descripcionActual) async {
    TextEditingController nombreController =
        TextEditingController(text: nombreActual);
    TextEditingController descripcionController =
        TextEditingController(text: descripcionActual);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Especialidad', style: AppStyles.headline2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la especialidad',
                ),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
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
                    descripcionController.text.isNotEmpty) {
                  final success =
                      await widget.apiService.actualizarEspecialidades(id, {
                    'nombre': nombreController.text,
                    'descripcion': descripcionController.text,
                  });

                  if (success) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    _cargarEspecialidades();
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al actualizar especialidad'),
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

  Future<void> _eliminarEspecialidad(int id) async {
    final success = await widget.apiService.eliminarEspecialidades(id);
    if (success) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Especialidad eliminada con éxito')),
      );
      _cargarEspecialidades();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Especialidad vinculada no se puede eliminar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestionar Especialidades',
          style: AppStyles.headline2.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.mainBlueColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _especialidades.length,
              itemBuilder: (context, index) {
                final especialidad = _especialidades[index];
                return ListTile(
                  title:
                      Text(especialidad['nombre'], style: AppStyles.bodyText1),
                  subtitle: Text(especialidad['descripcion'],
                      style: AppStyles.bodyText2),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editarEspecialidad(
                          especialidad['id'],
                          especialidad['nombre'],
                          especialidad['descripcion'],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _eliminarEspecialidad(especialidad['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearEspecialidad,
        backgroundColor: AppColors.mainBlueColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
