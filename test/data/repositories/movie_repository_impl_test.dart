import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Sesuaikan import ini dengan nama project Anda jika merah (misal: package:flutter_1/...)
import 'package:flutter_1/data/datasources/local_movie_data_source.dart';
import 'package:flutter_1/data/models/movie_model.dart';
import 'package:flutter_1/data/repositories/movie_repository_impl.dart';

// 1. Buat Mock untuk LocalDataSource (Memalsukan pembacaan file JSON)
class MockLocalMovieDataSource extends Mock implements LocalMovieDataSource {}

void main() {
  late MovieRepositoryImpl repository;
  late MockLocalMovieDataSource mockDataSource;

  // Setup dieksekusi sebelum setiap pengujian berjalan
  setUp(() {
    mockDataSource = MockLocalMovieDataSource();
    repository = MovieRepositoryImpl(localDataSource: mockDataSource);
  });

  // Data dummy tiruan untuk pengujian
  final tMovieModelList = [
    const MovieModel(
      id: 1,
      title: 'Inception',
      overview: 'Test overview',
      releaseDate: '2010',
      voteAverage: 8.8,
      runtime: 148,
      genres: ['Action'],
      posterUrl: 'url',
      backdropUrl: 'url',
    )
  ];

  group('MovieRepositoryImpl Tests', () {
    // TEST 1: SKENARIO SUKSES
    test('Harus mengembalikan List<Movie> ketika getMovies dari datasource berhasil', () async {
      // Arrange: Atur mock untuk mengembalikan data dummy saat fungsi dipanggil
      when(() => mockDataSource.getMovies(page: 1, limit: 10))
          .thenAnswer((_) async => tMovieModelList);

      // Act: Eksekusi fungsi di repository
      final result = await repository.getMovies(page: 1, limit: 10);

      // Assert: Pastikan hasilnya sesuai ekspektasi
      expect(result, equals(tMovieModelList));
      verify(() => mockDataSource.getMovies(page: 1, limit: 10)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    // TEST 2: SKENARIO GAGAL
    test('Harus melempar Exception ketika getMovies dari datasource gagal', () async {
      // Arrange: Atur mock untuk melempar error saat dipanggil
      when(() => mockDataSource.getMovies(page: 1, limit: 10))
          .thenThrow(Exception('Gagal memuat JSON'));

      // Act & Assert: Pastikan error diteruskan (karena repository kita langsung mereturn future)
      expect(() => repository.getMovies(page: 1, limit: 10), throwsException);
      verify(() => mockDataSource.getMovies(page: 1, limit: 10)).called(1);
    });

    // TEST 3: SKENARIO PENCARIAN
    test('Harus mengembalikan daftar film yang difilter saat searchMovies dipanggil', () async {
      // Arrange
      const tQuery = 'Inception';
      when(() => mockDataSource.searchMovies(tQuery))
          .thenAnswer((_) async => tMovieModelList);

      // Act
      final result = await repository.searchMovies(tQuery);

      // Assert
      expect(result, equals(tMovieModelList));
      verify(() => mockDataSource.searchMovies(tQuery)).called(1);
    });
  });
}