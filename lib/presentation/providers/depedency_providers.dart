import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local_movie_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';

// 1. SharedPreferences bersifat asinkron saat diinisialisasi.
// Kita buat provider kosong yang akan di-override ("ditimpa") di main.dart nanti.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider belum diinisialisasi di main.dart');
});

// 2. Membaca provider SharedPreferences untuk diinjeksi ke Data Source
final localMovieDataSourceProvider = Provider<LocalMovieDataSource>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return LocalMovieDataSourceImpl(sharedPreferences: prefs);
});

// 3. Membaca provider Data Source untuk diinjeksi ke Repository
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final dataSource = ref.read(localMovieDataSourceProvider);
  return MovieRepositoryImpl(localDataSource: dataSource);
});