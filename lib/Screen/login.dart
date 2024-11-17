import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screen/admin_dashboard.dart';
import 'package:flutter_application_1/Screen/medico_dashboard.dart';
import 'package:flutter_application_1/Screen/paciente_dashboard.dart';
import 'package:flutter_application_1/Service/api_service.dart';
import 'package:flutter_application_1/const/aap_colors.dart';
import 'package:flutter_application_1/const/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService(baseUrl);
  bool _isObscure = true;
  final bool _isButtonPressed = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (!mounted) return;

    // Llamada a la API para realizar el login
    final success = await _apiService.login(username, password);

    if (!mounted) return;

    if (success) {
      // Cargar el rol del usuario desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String role = prefs.getString('user_role') ?? '';

      // Redirigir al dashboard adecuado según el rol
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
      } else {
        // Si el rol no es válido, muestra un mensaje de error
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rol no reconocido')),
        );
      }
    } else {
      // Si el login falla, muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Fallido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50.0),
              Center(
                child: Text(
                  'ClinicaDMS',
                  style: AppStyles.headline1.copyWith(
                    color: AppColors.mainBlueColor,
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              Text(
                'Iniciar Sesión',
                style: AppStyles.headline2.copyWith(
                  color: AppColors.blueDarkColor,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Por favor, ingresa tus datos para continuar.',
                style: AppStyles.bodyText1.copyWith(
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 30.0),
              Text(
                'Nombre de usuario',
                style: AppStyles.subtitle2.copyWith(
                  color: AppColors.blueDarkColor,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu nombre de usuario',
                  hintStyle: AppStyles.inputText.copyWith(
                    color: AppColors.greyColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Contraseña',
                style: AppStyles.subtitle2.copyWith(
                  color: AppColors.blueDarkColor,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu contraseña',
                  hintStyle: AppStyles.inputText.copyWith(
                    color: AppColors.greyColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.greyColor,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _isButtonPressed
                      ? AppColors.mainBlueColor.withOpacity(0.8)
                      : AppColors.mainBlueColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _login,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          'Iniciar Sesión',
                          style: AppStyles.buttonText.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
