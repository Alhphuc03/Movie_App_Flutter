// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import 'package:xemphim/api/api.dart';

// class TrailerScreen extends StatefulWidget {
//   final int movieId;

//   const TrailerScreen({Key? key, required this.movieId}) : super(key: key);

//   @override
//   State<TrailerScreen> createState() => _TrailerScreenState();
// }

// class _TrailerScreenState extends State<TrailerScreen> {
//   late Future<String?> _trailerUrl;

//   @override
//   void initState() {
//     super.initState();
//     _trailerUrl = Api().getMovieTrailerUrl(widget.movieId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Trailer')),
//       body: FutureBuilder<String?>(
//         future: _trailerUrl,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final trailerUrl = snapshot.data;
//             if (trailerUrl != null) {
//               return YoutubePlayer(
//                 controller: YoutubePlayerController(
//                   initialVideoId: YoutubePlayer.convertUrlToId(trailerUrl)!,
//                   flags: const YoutubePlayerFlags(
//                     autoPlay: false,
//                   ),
//                 ),
//                 showVideoProgressIndicator: true,
//                 onReady: () => debugPrint('Player is ready.'),
//               );
//             } else {
//               return const Center(child: Text('No trailer available'));
//             }
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:xemphim/api/api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerExample extends StatefulWidget {
  final int movieId;

  const YoutubePlayerExample({Key? key, required this.movieId})
      : super(key: key);

  @override
  State<YoutubePlayerExample> createState() => _YoutubePlayerExampleState();
}

class _YoutubePlayerExampleState extends State<YoutubePlayerExample> {
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
      appBar: AppBar(title: const Text('Youtube Player Example')),
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
