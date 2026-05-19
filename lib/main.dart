import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/providers/depedency_providers.dart';
import 'presentation/pages/movie_list_screen.dart';

void main() async{
  // ProviderScope adalah inti dari Riverpod. 
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi penyimpanan lokal
  final sharedPreferences = await SharedPreferences.getInstance();
  // Tanpa ini, tidak ada satupun provider yang akan bekerja.
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MovieDiscoveryApp(),
    )
  );
}

class MovieDiscoveryApp extends StatelessWidget {
  const MovieDiscoveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Discovery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Untuk sementara, arahkan ke layar kosong. Kita akan buat nanti.
      home: const MovieListScreen(),
    );
  }
}