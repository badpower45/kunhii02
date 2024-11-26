import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _favoritePosts = [];
  final List<Map<String, dynamic>> _favoriteProducts = [];

  List<Map<String, dynamic>> get favoritePosts => _favoritePosts;
  List<Map<String, dynamic>> get favoriteProducts => _favoriteProducts;

  void addFavoritePost(Map<String, dynamic> post) {
    if (!_favoritePosts.contains(post)) {
      _favoritePosts.add(post);
      notifyListeners();
    }
  }

  void removeFavoritePost(Map<String, dynamic> post) {
    _favoritePosts.remove(post);
    notifyListeners();
  }

  void addFavoriteProduct(Map<String, dynamic> product) {
    if (!_favoriteProducts.contains(product)) {
      _favoriteProducts.add(product);
      notifyListeners();
    }
  }

  void removeFavoriteProduct(Map<String, dynamic> product) {
    _favoriteProducts.remove(product);
    notifyListeners();
  }

  void addFavorite(Map<String, dynamic> post) {}
}
