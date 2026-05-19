import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.releaseDate,
    required super.voteAverage,
    required super.runtime,
    required super.genres,
    required super.posterUrl,
    required super.backdropUrl,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      // Mengantisipasi format integer yang terdeteksi sebagai double atau sebaliknya
      voteAverage: (json['vote_average'] as num).toDouble(),
      runtime: json['runtime'],
      genres: List<String>.from(json['genres']),
      posterUrl: json['poster_url'],
      backdropUrl: json['backdrop_url'],
    );
  }
}