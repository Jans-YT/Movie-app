import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import 'depedency_providers.dart';

// Definisi State untuk memenuhi syarat loading, error, empty 
class MovieListState {
  final List<Movie> movies;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  MovieListState({
    this.movies = const [],
    this.isLoading = false,
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  MovieListState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return MovieListState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Jika null, error akan terhapus (untuk fungsi retry)
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

// StateNotifier untuk mengontrol logika pagination
class MovieListNotifier extends StateNotifier<MovieListState> {
  final MovieRepository repository;
  static const int _limit = 10;

  MovieListNotifier({required this.repository}) : super(MovieListState()) {
    fetchMovies(); // Langsung ambil data saat provider diinisialisasi
  }

  Future<void> fetchMovies({bool isRefresh = false}) async {
    if (state.isLoading || (state.hasReachedMax && !isRefresh)) return;

    if (isRefresh) {
      state = MovieListState(isLoading: true); // Reset state
    } else {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    try {
      final newMovies = await repository.getMovies(page: state.currentPage, limit: _limit);
      
      if (newMovies.isEmpty) {
        state = state.copyWith(isLoading: false, hasReachedMax: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          movies: isRefresh ? newMovies : [...state.movies, ...newMovies],
          currentPage: state.currentPage + 1,
          hasReachedMax: newMovies.length < _limit,
        );
      }
    } catch (e) {

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Terjadi kesalahan saat memuat data film.',
      );
    }
  }
}

// Provider yang akan didengarkan (listen) oleh UI
final movieListProvider = StateNotifierProvider<MovieListNotifier, MovieListState>((ref) {
  final repository = ref.read(movieRepositoryProvider);
  return MovieListNotifier(repository: repository);
});