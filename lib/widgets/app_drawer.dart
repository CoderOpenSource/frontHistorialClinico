import 'package:flutter/material.dart';
import 'package:mapas_api/screens/home_screen.dart';
import 'package:mapas_api/screens/pacientes/listar_doctors_screen.dart';
import 'package:mapas_api/screens/pacientes/listar_especialidades_screen.dart';
import 'package:mapas_api/screens/pacientes/listar_horarios_screen.dart';
import 'package:mapas_api/screens/pacientes/listar_paciente_screen.dart';
import 'package:mapas_api/screens/user/login_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  // Método para cargar el nombre de usuario desde SharedPreferences
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');

    setState(() {
      _username = username ?? 'Nombre no disponible';
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildDrawer();
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E272E), // Lila oscuro
              Colors.white, // Blanco
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1E272E), // Lila oscuro para el DrawerHeader
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: const NetworkImage(
                        'https://res.cloudinary.com/dhok8ieuv/image/upload/v1726490883/pngwing.com_4_aq4v9b.png'), // Imagen predeterminada
                    child: _username == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _username ?? 'Nombre no disponible',
                    style: const TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, 'Home', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }),
            _buildDrawerItem(Icons.person, 'Gestionar Pacientes', () {
              // Navegar a VerPacientesScreen al hacer clic en este ítem
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VerPacientesScreen(),
                ),
              );
            }),
            _buildDrawerItem(Icons.local_hospital, 'Gestionar Especialidades',
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListarEspecialidadesScreen(),
                ),
              );
            }),
            _buildDrawerItem(Icons.medical_services, 'Gestionar Doctor', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListarDoctoresScreen(),
                ),
              );
            }),
            _buildDrawerItem(Icons.schedule, 'Gestionar Horarios', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListarHorariosScreen(),
                ),
              );
            }),
            // Nuevo item para ver historiales clínicos

            _buildDrawerItem(Icons.settings, 'Configuración', () {}),
            _buildDrawerItem(Icons.help, 'Ayuda', () {
              // Implementar navegación a la pantalla de ayuda
            }),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () => _showLogoutConfirmation(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E272E), // Lila oscuro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Cerrar sesión",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1E272E)),
      title: Text(title, style: const TextStyle(color: Color(0xFF1E272E))),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Quieres cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _logout(context);
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }
}

void _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  // Remueve las preferencias guardadas
  prefs.remove('token'); // Remueve el token
  prefs.remove('username'); // Remueve el nombre de usuario

  // Navegar a la página de login y eliminar todas las demás pantallas de la pila de navegación
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (BuildContext context) =>
          const LoginView(), // Suponiendo que la vista de login se llama LoginView
    ),
    (Route<dynamic> route) => false, // Esto elimina todas las pantallas previas
  );
}
