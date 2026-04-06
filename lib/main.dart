import 'package:flutter/material.dart';
import 'package:todo_app/Screens/firestore_screen.dart';
import 'package:todo_app/Screens/homescreen.dart';
import 'package:todo_app/auth_gate.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/util/todoProvider.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/util/themeProvider.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    MultiProvider(providers: [ChangeNotifierProvider(create: (_) => TodoProvider()), 
    ChangeNotifierProvider(create: (_) => ThemeProvider()), ],
          child: MyApp(),
    )

  
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FirestoreScreen(),
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF9161E0),
        fontFamily: 'Unbounded',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Standard dark background
        primaryColor: const Color(0xFF9161E0),
        fontFamily: 'Unbounded',
      ),
    );
  }
}