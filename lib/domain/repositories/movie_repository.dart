import '../entities/movie.dart';

abstract class MovieRepository {
  // Mengambil daftar film dengan pagination (PDF mensyaratkan load per batch 10-20 item)
  Future<List<Movie>> getMovies({required int page, required int limit});
  
  // Mencari film berdasarkan judul
  Future<List<Movie>> searchMovies(String query);
  
  // Mengambil semua film yang ditandai favorit
  Future<List<Movie>> getFavoriteMovies();
  
  // Menambahkan atau menghapus film dari daftar favorit
  Future<void> toggleFavorite(int movieId);
  
  // Mengecek apakah sebuah film adalah favorit (berguna untuk merubah warna icon Love di UI)
  Future<bool> isFavorite(int movieId);
}