class Reviews {
  final String author;
  final String content;
  final String avatarPath;
  final double rating;

  Reviews({
    required this.author,
    required this.content,
    required this.avatarPath,
    required this.rating,
  });

  factory Reviews.fromMap(Map<String, dynamic> map) {
    return Reviews(
      author: map['author'],
      content: map['content'],
      avatarPath: map['author_details']['avatar_path'] ?? '',
      rating: map['author_details']['rating']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'content': content,
      'avatar_path': avatarPath,
      'rating': rating,
    };
  }
}
