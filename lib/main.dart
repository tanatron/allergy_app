import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/allergy_provider.dart';
import 'screens/allergy_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AllergyProvider(),
      child: MaterialApp(
        title: 'Allergy Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const AllergyListScreen(),
      ),
    );
  }
}