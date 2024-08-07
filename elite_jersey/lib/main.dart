import 'package:elite_jersey/Base de datos/db_helper.dart';
import 'package:elite_jersey/router.dart';
import 'package:elite_jersey/routes.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB(); // Inicializa la base de datos
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: MyRoutes.Main.name,
      routes: routes,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => PageNotFound(name: settings.name),
        );
      },
    );
  }
}

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key, required this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('La ruta $name no existe'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, MyRoutes.Main.name);
              },
              child: const Text('Ir a la página principal'),
            ),
          ],
        ),
      ),
    );
  }
}
