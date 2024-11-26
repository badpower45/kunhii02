import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritePosts = context.watch<FavoritesProvider>().favoritePosts;
    final favoriteProducts = context.watch<FavoritesProvider>().favoriteProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Favorite Posts
            if (favoritePosts.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Favorite Posts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: favoritePosts.length,
                itemBuilder: (context, index) {
                  final post = favoritePosts[index];
                  return ListTile(
                    leading: Image.asset(post['postImage'], width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(post['shopName']),
                    subtitle: Text(post['description']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<FavoritesProvider>().removeFavoritePost(post); // إزالة البوست
                      },
                    ),
                  );
                },
              ),
            ],
            // Favorite Products
            if (favoriteProducts.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Favorite Products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];
                  return ListTile(
                    leading: Image.asset(product['image'], width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(product['name']),
                    subtitle: Text(product['price']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<FavoritesProvider>().removeFavoriteProduct(product); // إزالة المنتج
                      },
                    ),
                  );
                },
              ),
            ],
            if (favoritePosts.isEmpty && favoriteProducts.isEmpty)
              const Center(child: Text('No favorites yet!')),
          ],
        ),
      ),
    );
  }
}
