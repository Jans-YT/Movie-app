import 'package:flutter/material.dart';
// import 'package:flutter_1/presentation/pages/movie_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/movie_list_provider.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_screen.dart';
import 'favorite_screen.dart';
import 'movie_search_screen.dart';

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({super.key});

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mendengarkan posisi scroll untuk trigger pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Jika posisi scroll sudah mencapai batas bawah dikurangi margin toleransi 200 pixel
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(movieListProvider.notifier).fetchMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Berlangganan ke perubahan state provider
    final state = ref.watch(movieListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Discovery'),
        // Nanti kita tambahkan tombol search di sini
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MovieSearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteScreen(),
                ),
              );
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: (){

          //   },
          // )
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(MovieListState state) {
    // 1. Tangani Error State (Kondisi Gagal Pertama Kali)
    if (state.errorMessage != null && state.movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(movieListProvider.notifier).fetchMovies(isRefresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // 2. Tangani Loading State (Kondisi Muat Pertama Kali)
    if (state.isLoading && state.movies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // 3. Tangani Empty State
    if (state.movies.isEmpty) {
      return const Center(child: Text('Tidak ada film yang ditemukan.'));
    }

    // 4. Tangani Data Loaded (Termasuk pagination loading di bawah list)
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(movieListProvider.notifier).fetchMovies(isRefresh: true);
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.movies.length + (state.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          // Render loading indicator di item paling bawah saat fetch berikutnya
          if (index == state.movies.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final movie = state.movies[index];
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