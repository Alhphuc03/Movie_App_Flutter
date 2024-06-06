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
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  String _linkm3u8 = '';

  @override
  void initState() {
    super.initState();
    _movieFuture = searchMovie(widget.movieTitle, _disposed, showError);
  }

  @override
  void dispose() {
    _disposed = true;
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer(String linkm3u8) {
    _linkm3u8 = linkm3u8;
    _videoPlayerController = VideoPlayerController.network(linkm3u8);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: true,
      allowFullScreen: true, // Allow full screen
      aspectRatio: 16 / 9, // Aspect ratio
      showControlsOnInitialize: false, // Hide controls initially
      showControls: true, // Show controls on touch
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red, // Played part color
        handleColor: Colors.blue, // Handle color
        bufferedColor: Colors.grey, // Buffered part color
        backgroundColor: Colors.black, // Background color
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final movieData = snapshot.data ?? {};
            final episodes = movieData['episodes'] as List<dynamic>? ?? [];

            final linkm3u8 = episodes.isNotEmpty
                ? (episodes[0]['server_data'][0]['link_m3u8'] ?? '')
                : '';

            if (linkm3u8.isNotEmpty) {
              _initializeVideoPlayer(linkm3u8);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(
                        controller: _chewieController!,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text('No movie available.'),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: Text('Movie not found.'),
            );
          }
        },
      ),
    );
  }
}
