class Movie {
  final String title;
  final int year;
  final double? rating;
  final String? imageUrl;

  const Movie({
    required this.title,
    required this.year,
    this.rating,
    this.imageUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      year: json['year'],
      rating: json['rating'],
      imageUrl: json['medium_cover_image'],
    );
  }
}