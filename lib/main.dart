import 'package:flutter/material.dart';
import 'package:untitled/screens/opening.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cyvooycvmqorkufkrbaa.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN5dm9veWN2bXFvcmt1ZmtyYmFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIwOTUyODgsImV4cCI6MjA2NzY3MTI4OH0.16QEAxdJRqFia44rMsPIhfhRYTxo2kJI8EHi2wEktDY',
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Construction',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
