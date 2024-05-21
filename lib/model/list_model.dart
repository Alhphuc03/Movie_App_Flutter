// ignore_for_file: public_member_api_docs, sort_constructors_first
class MovieList {
  final int id;
  final String name;
  MovieList({
    required this.id,
    required this.name,
  });

  factory MovieList.fromMap(Map<String, dynamic> map) {
    return MovieList(
      id: map['id'] ?? 0,
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
