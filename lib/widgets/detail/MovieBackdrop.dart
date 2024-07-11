import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/common/session_manager.dart';
import 'package:xemphim/main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:xemphim/model/movie_detail.dart';
import 'package:xemphim/api/api.dart'; // Import lớp Api để sử dụng
import 'package:xemphim/common/languageManager.dart';

class MovieBackdrop extends StatefulWidget {
  final MovieDetail movie;

  const MovieBackdrop({required this.movie});

  @override
  _MovieBackdropState createState() => _MovieBackdropState();
}

class _MovieBackdropState extends State<MovieBackdrop> {
  bool _isTrailerPlaying = false;
  YoutubePlayerController? _youtubePlayerController;
  String? directorName;

  @override
  void initState() {
    super.initState();
    _fetchDirectorName();
  }

  void _fetchDirectorName() async {
    try {
      String director = await Api().getDirectorName(widget.movie.id);
      if (mounted) {
        setState(() {
          directorName = director;
        });
      }
    } catch (e) {
      print('Failed to fetch director name: $e');
      if (mounted) {
        setState(() {
          directorName = 'Unknown';
        });
      }
    }
  }

  void _playTrailer() async {
    try {
      String? trailerUrl = await Api().getMovieTrailerUrl(widget.movie.id);
      if (trailerUrl != null) {
        final videoId = YoutubePlayer.convertUrlToId(trailerUrl);
        if (videoId != null) {
          _youtubePlayerController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
                autoPlay: true, showLiveFullscreenButton: false),
          );
          setState(() {
            _isTrailerPlaying = true;
          });
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('No trailer available for this movie.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to load trailer. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String firstGenreName =
        widget.movie.genres.isNotEmpty ? widget.movie.genres[0].name : '';
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    var languageManager = Provider.of<LanguageManager>(context);
    bool isVietnameseMode = languageManager.isVietnamese();

    return Container(
      width: screenWidth,
      height: 423,
      child: Stack(
        children: <Widget>[
          // Phần giao diện hiển thị trailer và backdrop của phim
          _isTrailerPlaying
              ? YoutubePlayer(
                  controller: _youtubePlayerController!,
                  showVideoProgressIndicator: true,
                )
              : Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: screenWidth,
                    height: 230,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://image.tmdb.org/t/p/original/${widget.movie.backdropPath}",
                        ),
                        fit: BoxFit.fitWidth,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.4),
                          BlendMode.modulate,
                        ),
                      ),
                    ),
                  ),
                ),
          // Phần hiển thị ảnh bìa phim và nút phát trailer
          Positioned(
            top: _isTrailerPlaying ? 240 : 140,
            left: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 150,
                height: _isTrailerPlaying ? 170 : 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://image.tmdb.org/t/p/w200/${widget.movie.posterPath}",
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ),
          // Phần hiển thị nút phát trailer và thông tin chi tiết phim
          if (!_isTrailerPlaying)
            Positioned(
              top: 100,
              left: 120,
              child: GestureDetector(
                onTap: _playTrailer,
                child: Row(
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      color: isDarkMode ? Colors.white : Colors.black,
                      size: 35,
                    ),
                    SizedBox(width: 8),
                    Text(
                      isVietnameseMode ? 'Xem trailer' : 'Play Trailer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.black87,
                        fontSize: 24,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Phần hiển thị thông tin chi tiết phim (tên, đạo diễn, ngày phát hành, thể loại)
          Positioned(
            top: 300,
            left: 180,
            child: Text(
              isVietnameseMode
                  ? 'Đạo diễn: \nXuất bản: \nThể loại: '
                  : 'Director: \nReleased: \nGenre: ',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: isDarkMode
                    ? Color.fromRGBO(255, 255, 255, 0.37)
                    : Colors.black87,
                fontSize: 16,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.4285714285714286,
              ),
            ),
          ),
          Positioned(
            top: 300,
            left: 290,
            child: Text(
              '${directorName ?? 'Loading...'} \n${widget.movie.releasedate.split('-')[0]}+ \n$firstGenreName',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: isDarkMode
                    ? Color.fromRGBO(255, 255, 255, 0.9)
                    : Colors.black,
                fontSize: 16,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.4285714285714286,
              ),
            ),
          ),
          Positioned(
            top: 240,
            left: 180,
            width: 220,
            child: Text(
              widget.movie.title,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: isDarkMode
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Colors.black,
                fontSize: 26,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.0833333333333333,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Phần nút chức năng

          Positioned(
            bottom: 0,
            left: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      final accountId = SessionManager.accountId;
                      final sessionId = SessionManager.sessionId;
                      await Api().addToWatchlist(int.parse(accountId),
                          sessionId, widget.movie.id, true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to watchlist successfully'),
                        ),
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to add to watchlist: $error'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    try {
                      final accountId = SessionManager.accountId;
                      final sessionId = SessionManager.sessionId;
                      await Api().markAsFavorite(int.parse(accountId),
                          sessionId, widget.movie.id, true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Marked as favorite successfully'),
                        ),
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to mark as favorite: $error'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pink,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    // Rate movie logic here
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
