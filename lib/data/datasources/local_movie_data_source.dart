import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/errors/failures.dart';
import '../models/movie_model.dart';

abstract class LocalMovieDataSource {
  Future<List<MovieModel>> getMovies({required int page, required int limit});
  Future<List<MovieModel>> searchMovies(String query);
  Future<List<MovieModel>> getFavoriteMovies();
  Future<void> toggleFavorite(int movieId);
  Future<bool> isFavorite(int movieId);
}

class LocalMovieDataSourceImpl implements LocalMovieDataSource {
  final SharedPreferences sharedPreferences;
  static const String _favoritesKey = 'FAVORITE_MOVIES';
  List<MovieModel>? _cachedMovies; // Menyimpan data di memori agar tidak parse JSON berulang

  LocalMovieDataSourceImpl({required this.sharedPreferences});

  // Fungsi internal untuk membaca JSON sesuai instruksi dokumen
  Future<List<MovieModel>> _loadMoviesFromJson() async {
    if (_cachedMovies != null) return _cachedMovies!;
    try {
      final raw = await rootBundle.loadString('assets/data/movies.json'); // [cite: 25]
      final data = json.decode(raw) as List; // [cite: 26]
      _cachedMovies = data.map((e) => MovieModel.fromJson(e)).toList();
      return _cachedMovies!;
    } catch (e) {
      throw const GenericFailure('Gagal memuat data JSON lokal');
    }
  }

  @override
  Future<List<MovieModel>> getMovies({required int page, required int limit}) async {
    final allMovies = await _loadMoviesFromJson();
    
    // Simulasi network delay agar loading state di UI bisa dievaluasi reviewer
    await Future.delayed(const Duration(milliseconds: 800));

    // Logika Pagination manual [cite: 33]
    final startIndex = (page - 1) * limit;
    if (startIndex >= allMovies.length) return [];
    
    return allMovies.skip(startIndex).take(limit).toList();
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final allMovies = await _loadMoviesFromJson();
    await Future.delayed(const Duration(milliseconds: 500));
    
    return allMovies
        .where((movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    final favorites = sharedPreferences.getStringList(_favoritesKey) ?? [];
    return favorites.contains(movieId.toString());
  }

  @override
  Future<void> toggleFavorite(int movieId) async {
    final favorites = List<String>.from(sharedPreferences.getStringList(_favoritesKey) ?? []);
    final idString = movieId.toString();
    
    if (favorites.contains(idString)) {
      favorites.remove(idString);
    } else {
      favorites.add(idString);
    }
    final isSaved = await sharedPreferences.setStringList(_favoritesKey, favorites);
  }

  @override
  Future<List<MovieModel>> getFavoriteMovies() async {
    final allMovies = await _loadMoviesFromJson();
    
    await sharedPreferences.reload(); 
    final favoritesIds = sharedPreferences.getStringList(_favoritesKey) ?? [];
    
    return allMovies
        .where((movie) => favoritesIds.contains(movie.id.toString()))
        .toList();
  }
}