import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/login.dart';
import 'package:flutter_application_1/const/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicoDashboardScreen extends StatefulWidget {
  const MedicoDashboardScreen({super.key});

  @override
  State<MedicoDashboardScreen> createState() => _MedicoDashboardScreenState();
}

class _MedicoDashboardScreenState extends State<MedicoDashboardScreen> {
  String _username = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "Médico";
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
          'Medico',
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
              leading: const Icon(Icons.folder),
              title: Text(
                'Gestión de Documentos',
                style: AppStyles.bodyText1,
              ),
              onTap: () {
                // Navegar a la gestión de documentos
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(
                'Gestión de Usuarios',
                style: AppStyles.bodyText1,
              ),
              onTap: () {
                // Navegar a la gestión de usuarios
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
