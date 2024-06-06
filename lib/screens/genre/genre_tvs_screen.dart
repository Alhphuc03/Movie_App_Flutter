import 'package:flutter/material.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/model/movie_model.dart';

class GenreTvsScreen extends StatefulWidget {
  final int genreId;
  final String genreName;

  const GenreTvsScreen({
    Key? key,
    required this.genreId,
    required this.genreName,
  }) : super(key: key);

  @override
  _GenreTvsScreenState createState() => _GenreTvsScreenState();
}

class _GenreTvsScreenState extends State<GenreTvsScreen> {
  late Future<List<Movie>> _tvShows;

  @override
  void initState() {
    super.initState();
    _tvShows = Api().getTVByGenre(widget.genreId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.genreName}',
          style: const TextStyle(
              color: Color.fromARGB(255, 255, 0, 0),
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Movie>>(
        future: _tvShows,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No TV shows available for this genre.'),
            );
          } else {
            // Render grid of TV shows
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Số lượng cột
                  crossAxisSpacing: 8.0, // Khoảng cách giữa các cột
                  mainAxisSpacing: 8.0, // Khoảng cách giữa các hàng
                  childAspectRatio:
                      0.55, // Tỷ lệ giữa chiều rộng và chiều cao của mỗi item
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final tvShow = snapshot.data![index];
                  return _buildTVShowCard(tvShow);
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTVShowCard(Movie tvShow) {
    return Container(
      child: Card(
        elevation: 5.0, // Đỗ bóng
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.network(
                'https://image.tmdb.org/t/p/original/${tvShow.posterpath}',
                fit: BoxFit.cover,
                height: 280, // Chiều cao của hình ảnh
                width: double.infinity, // Chiều rộng tối đa
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tvShow.title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Align(
                    child: Text(
                      'Release Date: ${tvShow.releasedate}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
