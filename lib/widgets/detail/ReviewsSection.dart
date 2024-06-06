import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reviews',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<Reviews>>(
            future: widget.movieReviews,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No reviews found.'));
              } else {
                final reviews = snapshot.data!;
                final displayReviews = widget.seeAllReviews ? reviews : reviews.take(3).toList();
                return Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: displayReviews.map((review) {
                          return Container(
                            width: 300,
                            child: Card(
                              color: Colors.black87,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            "https://image.tmdb.org/t/p/w500${review.avatarPath}",
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          review.author,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0), // Thêm padding bên trái
                                      child: Text(
                                        review.content,
                                        style: const TextStyle(color: Colors.white70),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          review.rating.toString(),
                                          style: const TextStyle(color: Colors.white),
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
                    ),
                    if (reviews.length > 3)
                      TextButton(
                        onPressed: widget.onSeeAllReviewsPressed,
                        child: Text(
                          widget.seeAllReviews ? 'See Less' : 'See All',
                          style: const TextStyle(color: Colors.amber),
                        ),
                      ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
