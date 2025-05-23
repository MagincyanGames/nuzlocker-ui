import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'services/user_service.dart';
import 'services/api_service.dart';
import 'services/developer_service.dart'; // Asegúrate de importar el servicio

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar servicios
  final apiService = ApiService();
  await apiService.init();
  
  final userService = UserService();
  await userService.init();
  
  runApp(
    MultiProvider(
      providers: [
        // Add ApiService provider
        Provider.value(value: apiService),
        ChangeNotifierProvider.value(value: userService),
        ChangeNotifierProvider(create: (_) => DeveloperService()), // Agregar DeveloperService
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NuzlockeTracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red, // Color temático de Pokémon
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
