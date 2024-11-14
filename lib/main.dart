import 'package:mapas_api/blocs/pagar/pagar_bloc.dart';
import 'package:mapas_api/models/theme_provider.dart';
import 'package:mapas_api/screens/home_screen.dart';
import 'package:mapas_api/screens/user/login_user.dart';
import 'package:mapas_api/services/traffic_service.dart';
import 'package:mapas_api/themes/dark_theme.dart';
import 'package:mapas_api/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas_api/blocs/blocs.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegura la inicialización de los widgets

  Stripe.publishableKey =
      'pk_test_51OM6g0A7qrAo0IhR3dbWDmmwmpyZ6fu5WcwDQ9kSNglvbcqlPKy4xXSlwltVkGOkQgWh12T7bFJgjCQq3B7cGaFV007JonVDPp';

  await Stripe.instance.applySettings();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GpsBloc()),
        BlocProvider(create: (context) => LocationBloc()),
        BlocProvider(
            create: (context) =>
                MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context))),
        BlocProvider(
            create: (context) => SearchBloc(trafficService: TrafficService())),
        BlocProvider(create: (_) => PagarBloc())
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<SharedPreferences> prefsFuture;
  bool? _isAuthenticated;

  @override
  void initState() {
    super.initState();
    prefsFuture = SharedPreferences.getInstance();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    setState(() {
      _isAuthenticated = token != null && token.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: themeProvider.isDarkMode ? darkUberTheme : lightUberTheme,
          home: _isAuthenticated != true
              ? const LoginView() // Si no está autenticado, muestra el LoginView
              : const HomeScreen(), // Si está autenticado, carga directamente HomeScreen
        );
      },
    );
  }
}
