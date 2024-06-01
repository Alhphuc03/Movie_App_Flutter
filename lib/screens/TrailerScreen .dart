import 'package:flutter/material.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/widgets/App_Bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerTrailer extends StatefulWidget {
  final int movieId;

  const YoutubePlayerTrailer({Key? key, required this.movieId})
      : super(key: key);

  @override
  State<YoutubePlayerTrailer> createState() => _YoutubePlayerTrailerState();
}

class _YoutubePlayerTrailerState extends State<YoutubePlayerTrailer> {
  late Future<String?> _trailerUrlFuture;
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _trailerUrlFuture = _fetchTrailerUrl(widget.movieId);
  }

  Future<String?> _fetchTrailerUrl(int movieId) async {
    final api = Api();
    final trailerUrl = await api.getMovieTrailerUrl(movieId);
    return trailerUrl;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder<String?>(
        future: _trailerUrlFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No trailer available for this movie.'));
          } else {
            final videoUrl = snapshot.data!;
            final videoId = YoutubePlayer.convertUrlToId(videoUrl);
            if (videoId == null) {
              return const Center(child: Text('Invalid trailer URL.'));
            }

            _controller = YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(autoPlay: false),
            );

            return YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
              onReady: () => debugPrint('Ready'),
              bottomActions: [
                CurrentPosition(),
                ProgressBar(
                  isExpanded: true,
                  colors: const ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.amberAccent,
                  ),
                ),
                const PlaybackSpeedButton(),
              ],
            );
          }
        },
      ),
    );
  }
}
