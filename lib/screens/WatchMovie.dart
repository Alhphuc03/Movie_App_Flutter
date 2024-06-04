import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:xemphim/services/movie_service.dart';

class WatchMovieScreen extends StatefulWidget {
  final int movieId;
  final String movieTitle;

  const WatchMovieScreen({
    Key? key,
    required this.movieId,
    required this.movieTitle,
  }) : super(key: key);

  @override
  _WatchMovieScreenState createState() => _WatchMovieScreenState();
}

class _WatchMovieScreenState extends State<WatchMovieScreen> {
  late Future<Map<String, dynamic>> _movieFuture;
  bool _disposed = false;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  String _linkm3u8 = '';

  @override
  void initState() {
    super.initState();
    _movieFuture = searchMovie(widget.movieTitle, _disposed, showError);
  }

  @override
  void dispose() {
    _disposed = true;
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer(String linkm3u8) {
    _linkm3u8 = linkm3u8;
    _videoPlayerController = VideoPlayerController.network(linkm3u8);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      allowFullScreen: true, // Cho phép chuyển sang toàn màn hình
      aspectRatio: 16 / 9, // Tỉ lệ khung hình
      showControlsOnInitialize: false, // Ẩn thanh điều khiển ban đầu
      showControls: true, // Hiển thị thanh điều khiển khi chạm vào video
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red, // Màu sắc cho phần đã phát
        handleColor: Colors.blue, // Màu sắc cho nút kéo thanh tiến độ
        bufferedColor: Colors.grey, // Màu sắc cho phần đã đệm
        backgroundColor: Colors.black, // Màu sắc nền của thanh tiến độ
      ),
    );
  }

  void showError(dynamic error) {
    if (!_disposed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movieTitle),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _movieFuture,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final movieData = snapshot.data ?? {};
            final episodes = movieData['episodes'] as List<dynamic>? ?? [];

            final linkm3u8 = episodes.isNotEmpty
                ? (episodes[0]['server_data'][0]['link_m3u8'] ??
                    'Link not available')
                : 'No episodes available';

            _initializeVideoPlayer(linkm3u8);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: Text('Movie not found.'),
            );
          }
        },
      ),
    );
  }
}
