import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_screen.dart';

class MovieSearchScreen extends ConsumerWidget {
  const MovieSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        // Meletakkan input pencarian langsung di AppBar untuk UX yang lebih baik
        title: TextField(
          autofocus: true, // Keyboard langsung muncul
          decoration: const InputDecoration(
            hintText: 'Ketik judul film...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            // Memicu fungsi debounce setiap kali ada ketikan
            ref.read(searchProvider.notifier).searchMovies(query);
          },
        ),
      ),
      body: _buildBody(searchState),
    );
  }

  Widget _buildBody(SearchState state) {
    if (state.query.isEmpty) {
      return const Center(child: Text('Ketikkan sesuatu untuk mulai mencari.'));
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Memenuhi syarat dokumen: "Tampilkan pesan yang jelas saat hasil kosong"
    if (state.movies.isEmpty) {
      return Center(
        child: Text(
          'Tidak ditemukan hasil untuk "${state.query}"',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    // Memenuhi syarat dokumen: "Tampilkan hasil dalam format yang sama"
    return ListView.builder(
      itemCount: state.movies.length,
      itemBuilder: (context, index) {
        final movie = state.movies[index];
        return MovieCard(
          movie: movie,
          onTap: () {
            // Memenuhi syarat dokumen: Navigasi ke Screen 3 dari Screen 2
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            );
          },
        );
      },
    );
  }
}