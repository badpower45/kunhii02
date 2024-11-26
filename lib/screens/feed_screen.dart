import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorites_provider.dart';

class FeedScreen extends StatelessWidget {
  final List<Map<String, dynamic>> posts = [
    {
      'shopName': 'Oakt Store',
      'shopLogo': 'assets/images/shop1_logo.jpg',
      'postImage': 'assets/images/post1.jpg',
      'description': 'Exclusive 20% off on all winter collections!',
      'timestamp': '2 hours ago',
    },
    {
      'shopName': 'Urban Fashion',
      'shopLogo': 'assets/images/shop2_logo.jpg',
      'postImage': 'assets/images/post2.jpg',
      'description': 'New arrivals just dropped! Check them out.',
      'timestamp': '1 day ago',
    },
    {
      'shopName': 'Kamy Collection',
      'shopLogo': 'assets/images/kamy_logo.jpg',
      'postImage': 'assets/images/post3.jpg',
      'description': 'Flat 50% off on all items! Don’t miss it.',
      'timestamp': '3 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites'); // الانتقال إلى صفحة المفضلات
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Shop logo and name)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(post['shopLogo']),
                        radius: 25,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['shopName'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            post['timestamp'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Post image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.asset(
                    post['postImage'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Description
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    post['description'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {
                          context.read<FavoritesProvider>().addFavorite(post); // إضافة إلى المفضلات
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to favorites!')),
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/shop-details', arguments: post['shopName']);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        child: const Text('View Shop'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
