import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/aseguradora_screen.dart';
import 'package:flutter_application_1/Screen/citas_view_screen.dart';
import 'package:flutter_application_1/Screen/especialidad_screen.dart';
import 'package:flutter_application_1/Screen/horario_atencion_screen.dart';
import 'package:flutter_application_1/Screen/registro_pacientes_admin.dart';
import 'package:flutter_application_1/Screen/subir_documento.dart';
import 'package:flutter_application_1/Service/api_service.dart';
import 'package:flutter_application_1/const/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _username = "";
  final ApiService apiService = ApiService(baseUrl);
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "Administrador";
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Eliminar todos los datos de SharedPreferences

    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Administrador',
          style: AppStyles.headline2.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bienvenid@, $_username',
                    style: AppStyles.headline2.copyWith(color: Colors.white),
                  ),
                  Text(
                    'correo@admin.com',
                    style: AppStyles.bodyText2.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: Text(
                'Registrar Paciente',
                style: AppStyles.bodyText1,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistroPacienteScreen(
                            apiService: apiService,
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Gestionar Aseguradoras'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AseguradoraScreen(apiService: apiService),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Gestionar Especialidades'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EspecialidadesScreen(apiService: apiService),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Gestionar Horarios'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HorarioScreen(apiService: apiService),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: Text(
                'Gestionar citas',
                style: AppStyles.bodyText1,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CitasViewScreen(apiService: apiService),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(
                'Gestión de Documentos',
                style: AppStyles.bodyText1,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SubirDocumentoScreen(apiService: apiService),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: Text(
                'Reportes',
                style: AppStyles.bodyText1,
              ),
              onTap: () {
                // Navegar a los reportes
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                'Cerrar Sesión',
                style: AppStyles.bodyText1,
              ),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Contenido principal del Dashboard del Administrador',
          style: AppStyles.subtitle1,
        ),
      ),
    );
  }
}
