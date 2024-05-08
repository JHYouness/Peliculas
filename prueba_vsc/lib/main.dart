import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vsc/providers/movies_providers.dart';
import 'package:prueba_vsc/screens/screens.dart';

void main() => runApp(const AppState());

class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Inizializo la clase para optener los datos de la api, es necesario poner lazy en false, para que se cree
        ChangeNotifierProvider(
          create: (_) => MoviesProvider(),
          lazy: false,
        )     ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home', //Primera pagina al iniciar la app
      routes: {
        'home': (_) => const HomeScreen(),
        'details': (_) => const DetailScreen(),
      },

      theme: ThemeData.light()
          .copyWith(appBarTheme: AppBarTheme(color: Colors.indigo.shade300)),
    );
  }
}
