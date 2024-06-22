// import 'package:flutter/material.dart';
// import 'package:xemphim/model/movie_detail.dart';
// import 'package:xemphim/screens/detail/watch_movie_screen.dart';
// import 'package:xemphim/widgets/detail/GenreTag.dart';

// class Movieinfo extends StatelessWidget {
//   final MovieDetail movie;

//   const Movieinfo({required this.movie});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             movie.original_title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Card(
//             color: Colors.black.withOpacity(0.5),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//               side: const BorderSide(width: 1, color: Colors.grey),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               const SizedBox(width: 16),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => WatchMovieScreen(
//                           movieId: movie.id,
//                           movieTitle: movie.original_title,
//                         ),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFFF0000),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Icon(Icons.play_circle_outline_rounded),
//                       SizedBox(width: 8),
//                       Text('Watch Movie'),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
