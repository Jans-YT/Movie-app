import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import 'depedency_providers.dart';

class FavoriteNotifier extends StateNotifier<List<Movie>> {
  final MovieRepository repository;

  FavoriteNotifier({required this.repository}) : super([]) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favorites = await repository.getFavoriteMovies();
    state = favorites;
  }

  Future<void> toggleFavorite(Movie movie) async {
    await repository.toggleFavorite(movie.id);
    
    final isAlreadyFavorite = state.any((m) => m.id == movie.id);
    if (isAlreadyFavorite) {
      state = state.where((m) => m.id != movie.id).toList();
    } else {
      state = [...state, movie];
    }
  }

  bool isFavorite(int movieId) {
    return state.any((movie) => movie.id == movieId);
  }
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<Movie>>((ref) {
  final repository = ref.read(movieRepositoryProvider);
  return FavoriteNotifier(repository: repository);
});