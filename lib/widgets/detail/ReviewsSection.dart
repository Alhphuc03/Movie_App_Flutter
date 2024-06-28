import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/common/languageManager.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/model/movie_review.dart';

class ReviewsSection extends StatefulWidget {
  final Future<List<Reviews>> movieReviews;
  final bool seeAllReviews;
  final VoidCallback onSeeAllReviewsPressed;

  const ReviewsSection({
    required this.movieReviews,
    required this.seeAllReviews,
    required this.onSeeAllReviewsPressed,
    Key? key,
  }) : super(key: key);

  @override
  _ReviewsSectionState createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    var languageManager = Provider.of<LanguageManager>(context, listen: false);
    bool isVietnameseMode = languageManager.isVietnamese();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Reviews>>(
              future: widget.movieReviews,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      isVietnameseMode
                          ? 'Không có đánh giá nào.'
                          : 'No reviews found.',
                    ),
                  );
                } else {
                  final reviews = snapshot.data!;
                  final displayReviews =
                      widget.seeAllReviews ? reviews : reviews.take(2).toList();
                  return SingleChildScrollView(
                    child: Column(
                      children: displayReviews.map((review) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Card(
                            color: isDarkMode ? Colors.black87 : Colors.white70,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: review
                                                .avatarPath.isNotEmpty
                                            ? NetworkImage(
                                                "https://image.tmdb.org/t/p/w500${review.avatarPath}")
                                            : AssetImage('assets/avt_df.png'),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        review.author,
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      review.content,
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        review.rating.toString(),
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ),
          FutureBuilder<List<Reviews>>(
            future: widget.movieReviews,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return Container();
              } else {
                final reviews = snapshot.data!;
                return reviews.length > 2
                    ? TextButton(
                        onPressed: widget.onSeeAllReviewsPressed,
                        child: Center(
                          child: Text(
                            widget.seeAllReviews
                                ? isVietnameseMode
                                    ? 'Thu gọn'
                                    : 'See Less'
                                : isVietnameseMode
                                    ? 'Xem thêm'
                                    : 'See All',
                            style: const TextStyle(color: Colors.amber),
                          ),
                        ),
                      )
                    : Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
