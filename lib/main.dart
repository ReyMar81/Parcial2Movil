import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/login.dart';
import 'Screen/admin_dashboard.dart';
import 'Screen/medico_dashboard.dart';
import 'Screen/paciente_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión Documental',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Inicia con SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    String? role = prefs.getString('user_role');

    if (token != null && role != null) {
      // Si el token y el rol están presentes, redirige según el rol
      if (role == 'ADMINISTRADOR') {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      } else if (role == 'MEDICO') {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => const MedicoDashboardScreen()),
        );
      } else if (role == 'PACIENTE') {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => const PacienteDashboardScreen()),
        );
      }
    } else {
      // Si no hay token o rol, redirige a la pantalla de inicio de sesión
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child:
              CircularProgressIndicator()), // Indicador de carga mientras se verifica el rol
    );
  }
}
