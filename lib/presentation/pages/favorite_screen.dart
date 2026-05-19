import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorite_provider.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_screen.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Membaca daftar film favorit dari state
    final favoriteMovies = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Film Favorit'),
      ),
      body: favoriteMovies.isEmpty
          // Memenuhi syarat dokumen: "Tampilkan empty state jika belum ada favorit"
          ? const Center(
              child: Text(
                'Anda belum memiliki film favorit.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return MovieCard(
                  movie: movie,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(movie: movie),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}