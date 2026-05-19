import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/movie.dart';
import 'depedency_providers.dart';

// Definisi state spesifik untuk pencarian
class SearchState {
  final List<Movie> movies;
  final bool isLoading;
  final String query;

  SearchState({this.movies = const [], this.isLoading = false, this.query = ''});

  SearchState copyWith({List<Movie>? movies, bool? isLoading, String? query}) {
    return SearchState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
    );
  }
}

// Notifier yang mengontrol logika Debounce 300ms
class SearchNotifier extends StateNotifier<SearchState> {
  final _repository;
  Timer? _debounceTimer;

  SearchNotifier(this._repository) : super(SearchState());

  void searchMovies(String query) {
    // 1. Update teks query secara instan di state
    state = state.copyWith(query: query);

    // 2. Batalkan timer sebelumnya jika pengguna masih mengetik
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    // Jika input kosong, reset daftar hasil
    if (query.trim().isEmpty) {
      state = state.copyWith(movies: [], isLoading: false);
      return;
    }

    // Tampilkan indikator loading saat menunggu
    state = state.copyWith(isLoading: true);

    // 3. Setel timer baru (Debounce minimal 300ms sesuai instruksi)
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        final results = await _repository.searchMovies(query);
        state = state.copyWith(movies: results, isLoading: false);
      } catch (e) {
        state = state.copyWith(movies: [], isLoading: false);
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final repository = ref.read(movieRepositoryProvider);
  return SearchNotifier(repository);
});