import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorites_provider.dart';

class ProductScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Image.asset(product['image'], height: 250, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product['price'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    context.read<FavoritesProvider>().addFavoriteProduct(product); // إضافة المنتج للمفضلات
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product['name']} added to favorites!')),
                    );
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add to cart logic
            },
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
