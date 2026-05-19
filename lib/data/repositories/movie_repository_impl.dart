import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/local_movie_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final LocalMovieDataSource localDataSource;

  MovieRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Movie>> getMovies({required int page, required int limit}) async {
    return await localDataSource.getMovies(page: page, limit: limit);
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    return await localDataSource.searchMovies(query);
  }

  @override
  Future<List<Movie>> getFavoriteMovies() async {
    return await localDataSource.getFavoriteMovies();
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    return await localDataSource.isFavorite(movieId);
  }

  @override
  Future<void> toggleFavorite(int movieId) async {
    await localDataSource.toggleFavorite(movieId);
  }
}