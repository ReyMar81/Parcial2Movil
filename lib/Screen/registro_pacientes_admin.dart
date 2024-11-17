import 'package:flutter/material.dart';
import 'package:flutter_application_1/Service/api_service.dart';
import 'package:flutter_application_1/const/app_styles.dart';
import 'package:flutter_application_1/const/aap_colors.dart';

class RegistroPacienteScreen extends StatefulWidget {
  final ApiService apiService;

  const RegistroPacienteScreen({super.key, required this.apiService});

  @override
  State<RegistroPacienteScreen> createState() => _RegistroPacienteScreenState();
}

class _RegistroPacienteScreenState extends State<RegistroPacienteScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoPaternoController =
      TextEditingController();
  final TextEditingController _apellidoMaternoController =
      TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  final TextEditingController _rolIdController =
      TextEditingController(text: "3"); // Rol paciente

  final ApiService _apiService = ApiService(baseUrl); // Instancia de ApiService
  bool _isButtonPressed = false;
  int? _selectedAseguradoraId; // ID de la aseguradora seleccionada

  final List<Map<String, dynamic>> _aseguradoras = [
    {'id': 1, 'nombre': 'Aseguradora 1'},
    {'id': 2, 'nombre': 'Aseguradora 2'},
    {'id': 3, 'nombre': 'Aseguradora 3'},
    // Agrega más aseguradoras aquí según sea necesario
  ];

  Future<void> _registrarPaciente() async {
    if (_selectedAseguradoraId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una aseguradora')),
      );
      return;
    }

    final userName = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;
    final nombre = _nombreController.text;
    final apellidoPaterno = _apellidoPaternoController.text;
    final apellidoMaterno = _apellidoMaternoController.text;
    final fechaNacimiento = _fechaNacimientoController.text;
    final rolId = int.parse(_rolIdController.text);

    setState(() {
      _isButtonPressed = true;
    });

    // Llamada al servicio de registro de paciente
    final success = await _apiService.registrarPaciente(
      userName: userName,
      password: password,
      email: email,
      nombre: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
      fechaNacimiento: fechaNacimiento,
      rolId: rolId,
      idAseguradora: _selectedAseguradoraId!,
    );

    setState(() {
      _isButtonPressed = false;
    });

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paciente registrado con éxito')),
      );
      _usernameController.clear();
      _passwordController.clear();
      _emailController.clear();
      _nombreController.clear();
      _apellidoPaternoController.clear();
      _apellidoMaternoController.clear();
      _fechaNacimientoController.clear();
      setState(() {
        _selectedAseguradoraId = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar paciente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        title: Text(
          'Registro de Paciente',
          style: AppStyles.headline2.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.mainBlueColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40.0),
              Text(
                'Registrar Paciente',
                style: AppStyles.headline2.copyWith(
                  color: AppColors.blueDarkColor,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Por favor, ingresa los datos del paciente.',
                style: AppStyles.bodyText1.copyWith(
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 30.0),
              _buildTextField('Nombre de usuario', _usernameController),
              const SizedBox(height: 20.0),
              _buildTextField('Contraseña', _passwordController,
                  obscureText: true),
              const SizedBox(height: 20.0),
              _buildTextField('Correo Electrónico', _emailController),
              const SizedBox(height: 20.0),
              _buildTextField('Nombre', _nombreController),
              const SizedBox(height: 20.0),
              _buildTextField('Apellido Paterno', _apellidoPaternoController),
              const SizedBox(height: 20.0),
              _buildTextField('Apellido Materno', _apellidoMaternoController),
              const SizedBox(height: 20.0),
              _buildTextField('Fecha de Nacimiento (YYYY-MM-DD)',
                  _fechaNacimientoController),
              const SizedBox(height: 20.0),
              Text(
                'Selecciona Aseguradora',
                style: AppStyles.subtitle2
                    .copyWith(color: AppColors.blueDarkColor),
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: _selectedAseguradoraId,
                items: _aseguradoras.map((aseguradora) {
                  return DropdownMenuItem<int>(
                    value: aseguradora['id'],
                    child: Text(aseguradora['nombre']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAseguradoraId = value;
                  });
                },
                hint: const Text("Selecciona una aseguradora"),
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
                    onTap: _registrarPaciente,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          'Registrar Paciente',
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

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.subtitle2.copyWith(color: AppColors.blueDarkColor),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: 'Ingresa $label',
            hintStyle: AppStyles.inputText.copyWith(color: AppColors.greyColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
