import 'package:flutter/material.dart';
import 'package:flutter_application_1/Service/api_service.dart';
import 'package:flutter_application_1/const/aap_colors.dart';
import 'package:flutter_application_1/const/app_styles.dart';

class CitasViewScreen extends StatefulWidget {
  final ApiService apiService;

  const CitasViewScreen({super.key, required this.apiService});

  @override
  State<CitasViewScreen> createState() => _CitasViewScreenState();
}

class _CitasViewScreenState extends State<CitasViewScreen> {
  Map<String, Map<String, List<dynamic>>> _citasPorDia = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarCitas();
  }

  Future<void> _cargarCitas() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Llamamos a obtenerAllCitas en lugar de obtenerCitas
      final citas = await widget.apiService.obtenerAllCitas();
      final Map<String, Map<String, List<dynamic>>> citasPorDia = {};

      if (citas.containsKey('citasPorDia') &&
          citas['citasPorDia'] is Map<String, dynamic>) {
        (citas['citasPorDia'] as Map<String, dynamic>)
            .forEach((dia, especialidades) {
          if (especialidades is Map<String, dynamic>) {
            final Map<String, List<dynamic>> especialidadesMap = {};

            especialidades.forEach((especialidad, citasList) {
              if (citasList is List) {
                especialidadesMap[especialidad] = List<dynamic>.from(citasList);
              }
            });

            citasPorDia[dia] = especialidadesMap;
          }
        });

        setState(() {
          _citasPorDia = citasPorDia;
        });
      } else {
        throw Exception('Estructura de datos inesperada');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar citas: ${e.toString()}')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ver Citas',
          style: AppStyles.headline2.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.mainBlueColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: _citasPorDia.entries.map((diaEntry) {
                final dia = diaEntry.key;
                final especialidades = diaEntry.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    color: AppColors.backgroundAccentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ExpansionTile(
                      leading: const Icon(Icons.calendar_today,
                          color: AppColors.mainBlueColor),
                      title: Text(
                        dia,
                        style: AppStyles.headline2,
                      ),
                      children: especialidades.entries
                          .map<Widget>((especialidadEntry) {
                        final especialidad = especialidadEntry.key;
                        final citas = especialidadEntry.value;

                        return ExpansionTile(
                          leading: const Icon(Icons.medical_services,
                              color: AppColors.infoColor),
                          title: Text(
                            especialidad,
                            style: AppStyles.subtitle1,
                          ),
                          children: citas.map<Widget>((cita) {
                            bool isReservable =
                                cita['disponibilidad'] == 'Libre';

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Card(
                                color: AppColors.whiteColor,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.person,
                                              color: AppColors.mainBlueColor),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            'Doctor: ${cita['nombreDoctor']}',
                                            style: AppStyles.bodyText1.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time,
                                              color: AppColors.greyColor),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            'Hora de Inicio: ${cita['horaInicio']}',
                                            style: AppStyles.bodyText2,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time_outlined,
                                              color: AppColors.greyColor),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            'Hora de Fin: ${cita['horaFin']}',
                                            style: AppStyles.bodyText2,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          Icon(
                                            isReservable
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color: isReservable
                                                ? AppColors.successColor
                                                : AppColors.errorColor,
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            'Disponibilidad: ${cita['disponibilidad']}',
                                            style: AppStyles.bodyText2.copyWith(
                                              color: isReservable
                                                  ? AppColors.successColor
                                                  : AppColors.errorColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
