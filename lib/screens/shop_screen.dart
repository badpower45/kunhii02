import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  final String shopName; // اسم المحل
  final String shopLogo; // شعار المحل
  final String heroImage; // صورة الهيرو
  final List<Map<String, String>> topRatedProducts; // المنتجات الأعلى تقييمًا
  final List<String> categories; // قائمة الفئات
  final List<Map<String, String>> collections; // الكولكشنز

  const ShopScreen({
    required this.shopName,
    required this.shopLogo,
    required this.heroImage,
    required this.topRatedProducts,
    required this.categories,
    required this.collections, required List recommendedShops,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shopName),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Stack(
              children: [
                Image.asset(
                  heroImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    shopName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(shopLogo),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Top Rated Products
            _buildSectionTitle(context, title: "Top Rated"),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topRatedProducts.length,
                itemBuilder: (context, index) {
                  final product = topRatedProducts[index];
                  return _buildProductCard(product);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Categories
            _buildSectionTitle(context, title: "Categories"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: categories
                    .map(
                      (category) => Chip(
                        label: Text(category),
                        backgroundColor: Colors.grey[200],
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Collections
            _buildSectionTitle(context, title: "Collections"),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  final collection = collections[index];
                  return _buildCollectionCard(collection);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Suggested Shops
            _buildSectionTitle(context, title: "Shops You May Like"),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // عدد المحلات التي يمكن عرضها
                itemBuilder: (context, index) {
                  return _buildSuggestedShopCard(
                    shopName: 'Shop ${index + 1}',
                    logo: 'assets/images/shop${(index % 2) + 1}_logo.jpg',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, {required String title}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, String> product) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.asset(
              product['image']!,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              product['name']!,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              product['price']!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionCard(Map<String, String> collection) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Image.asset(
              collection['image']!,
              height: 150,
              width: 200,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                collection['title']!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedShopCard({
    required String shopName,
    required String logo,
  }) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(logo),
          ),
          const SizedBox(height: 5),
          Text(
            shopName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
