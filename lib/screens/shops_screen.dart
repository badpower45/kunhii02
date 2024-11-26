import 'package:flutter/material.dart';
import 'shop_screen.dart'; // استيراد ملف ShopScreen

class ShopsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> featuredShops = [
      {
        'name': 'Oakt Store',
        'logo': 'assets/images/shop1_logo.jpg',
        'description': 'Luxury clothing for modern people.',
        'heroImage': 'assets/images/shop1_hero.jpg',
      },
      {
        'name': 'Urban Fashion',
        'logo': 'assets/images/shop2_logo.jpg',
        'description': 'Stylish outfits for everyone.',
        'heroImage': 'assets/images/shop2_hero.jpg',
      },
    ];

    final List<Map<String, String>> otherShops = [
      {'name': 'Kamy Collection', 'logo': 'assets/images/kamy_logo.jpg'},
      {'name': 'Duas Atelier', 'logo': 'assets/images/duas_logo.jpg'},
      {'name': 'Perfect Princess', 'logo': 'assets/images/perfect_princess_logo.jpg'},
      {'name': 'Luna Style', 'logo': 'assets/images/luna_logo.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shops'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Featured Shops Section
              const SectionTitle(title: "Featured Shops"),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredShops.length,
                  itemBuilder: (context, index) {
                    final shop = featuredShops[index];
                    return FeaturedShopCard(
                      shop: shop,
                      defaultBackgroundColor: Colors.grey[200]!, // لون افتراضي رمادي
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Other Shops Section
              const SectionTitle(title: "Other Shops"),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: otherShops.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final shop = otherShops[index];
                  return OtherShopCard(
                    shop: shop,
                    defaultBackgroundColor: Colors.grey[200]!, // لون افتراضي رمادي
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class FeaturedShopCard extends StatelessWidget {
  final Map<String, String> shop;
  final Color defaultBackgroundColor;

  const FeaturedShopCard({
    required this.shop,
    required this.defaultBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopScreen(
              shopName: shop['name']!,
              shopLogo: shop['logo']!,
              heroImage: shop['heroImage']!,
              topRatedProducts: [
                {'name': 'Product 1', 'image': 'assets/images/product1.jpg', 'price': '\$50'},
                {'name': 'Product 2', 'image': 'assets/images/product2.jpg', 'price': '\$70'},
              ],
              categories: ['T-Shirts', 'Shoes', 'Bags'],
              collections: [
                {'title': 'Winter Collection', 'image': 'assets/images/collection1.jpg'},
                {'title': 'Summer Collection', 'image': 'assets/images/collection2.jpg'},
              ], recommendedShops: [],
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: defaultBackgroundColor, // لون الخلفية الافتراضي
          borderRadius: BorderRadius.circular(10),
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
                shop['heroImage']!,
                width: 200,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop['name']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    shop['description']!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OtherShopCard extends StatelessWidget {
  final Map<String, String> shop;
  final Color defaultBackgroundColor;

  const OtherShopCard({
    required this.shop,
    required this.defaultBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clicked on ${shop['name']}')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: defaultBackgroundColor, // لون الخلفية الافتراضي
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(shop['logo']!),
            ),
            const SizedBox(height: 10),
            Text(
              shop['name']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
