import 'package:flutter/material.dart';
import 'package:flutter_application_1/Service/api_service.dart';
import 'package:flutter_application_1/const/app_styles.dart';
import 'package:flutter_application_1/const/aap_colors.dart';

class HorarioScreen extends StatefulWidget {
  final ApiService apiService;

  const HorarioScreen({super.key, required this.apiService});

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
  List<dynamic> _horarios = [];
  List<dynamic> _usuariosMedicos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarHorarios();
    _cargarUsuariosMedicos(); // Cargar los médicos cuando inicie la pantalla
  }

  Future<void> _cargarHorarios() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _horarios = await widget.apiService.obtenerHorarios();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar horarios')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _cargarUsuariosMedicos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _usuariosMedicos =
          await widget.apiService.obtenerUsuariosPorRol(2); // Rol de médico
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar médicos')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _crearHorario() async {
    TextEditingController diaController = TextEditingController();
    TextEditingController horaInicioController = TextEditingController();
    TextEditingController horaFinController = TextEditingController();
    TextEditingController cantidadFichasController = TextEditingController();
    dynamic usuarioSeleccionado;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Horario', style: AppStyles.headline2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: diaController,
                decoration: const InputDecoration(
                  labelText: 'Día de la Semana',
                ),
              ),
              TextField(
                controller: horaInicioController,
                decoration: const InputDecoration(
                  labelText: 'Hora de Inicio',
                ),
              ),
              TextField(
                controller: horaFinController,
                decoration: const InputDecoration(
                  labelText: 'Hora de Fin',
                ),
              ),
              TextField(
                controller: cantidadFichasController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad de Fichas',
                ),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<dynamic>(
                value: usuarioSeleccionado,
                items: _usuariosMedicos.map((usuario) {
                  return DropdownMenuItem(
                    value: usuario['id'],
                    child: Text(usuario['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    usuarioSeleccionado = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Seleccionar Médico',
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
                if (diaController.text.isNotEmpty &&
                    horaInicioController.text.isNotEmpty &&
                    horaFinController.text.isNotEmpty &&
                    cantidadFichasController.text.isNotEmpty &&
                    usuarioSeleccionado != null) {
                  final success = await widget.apiService.crearHorario({
                    'diaSemana': diaController.text,
                    'horaInicio': horaInicioController.text,
                    'horaFin': horaFinController.text,
                    'cantidadFichas': int.parse(cantidadFichasController.text),
                    'idUsuario': usuarioSeleccionado,
                  });

                  if (success) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop(); // Cierra el diálogo
                    _cargarHorarios(); // Recarga la lista de horarios
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al crear horario'),
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

  Future<void> _editarHorario(int id, String dia, String horaInicio,
      String horaFin, int cantidadFichas, int? idUsuario) async {
    TextEditingController diaController = TextEditingController(text: dia);
    TextEditingController horaInicioController =
        TextEditingController(text: horaInicio);
    TextEditingController horaFinController =
        TextEditingController(text: horaFin);
    TextEditingController cantidadFichasController =
        TextEditingController(text: cantidadFichas.toString());
    dynamic usuarioSeleccionado =
        idUsuario; // Puede ser null si no hay médico asignado

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Horario', style: AppStyles.headline2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Día de la semana
              TextField(
                controller: diaController,
                decoration:
                    const InputDecoration(labelText: 'Día de la semana'),
              ),
              // Hora de inicio
              TextField(
                controller: horaInicioController,
                decoration: const InputDecoration(labelText: 'Hora de Inicio'),
              ),
              // Hora de fin
              TextField(
                controller: horaFinController,
                decoration: const InputDecoration(labelText: 'Hora de Fin'),
              ),
              // Cantidad de fichas
              TextField(
                controller: cantidadFichasController,
                decoration:
                    const InputDecoration(labelText: 'Cantidad de Fichas'),
                keyboardType: TextInputType.number,
              ),
              // Selección de médico (Dropdown)
              DropdownButtonFormField<dynamic>(
                value: usuarioSeleccionado,
                hint: const Text("Seleccionar Médico"),
                items: _usuariosMedicos.map((usuario) {
                  return DropdownMenuItem(
                    value: usuario['id'],
                    child: Text(usuario['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    usuarioSeleccionado = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Seleccionar Médico',
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
                if (diaController.text.isNotEmpty &&
                    horaInicioController.text.isNotEmpty &&
                    horaFinController.text.isNotEmpty &&
                    cantidadFichasController.text.isNotEmpty &&
                    usuarioSeleccionado != null) {
                  final success =
                      await widget.apiService.actualizarHorario(id, {
                    'diaSemana': diaController.text,
                    'horaInicio': horaInicioController.text,
                    'horaFin': horaFinController.text,
                    'cantidadFichas': int.parse(cantidadFichasController.text),
                    'idUsuario':
                        usuarioSeleccionado, // El ID del médico (puede ser null)
                  });

                  if (success) {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    _cargarHorarios(); // Recarga la lista de horarios
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Error al actualizar horario')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Horarios',
            style: AppStyles.headline2.copyWith(color: Colors.white)),
        backgroundColor: AppColors.mainBlueColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _horarios.length,
              itemBuilder: (context, index) {
                final horario = _horarios[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      'Día: ${horario['diaSemana']}',
                      style: AppStyles.bodyText1,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Inicio: ${horario['horaInicio']}'),
                        Text('Fin: ${horario['horaFin']}'),
                        Text('Fichas: ${horario['cantidadFichas']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editarHorario(
                              horario['id'],
                              horario['diaSemana'],
                              horario['horaInicio'],
                              horario['horaFin'],
                              horario['cantidadFichas'],
                              horario['idUsuario']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearHorario,
        backgroundColor: AppColors.mainBlueColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
