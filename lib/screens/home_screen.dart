import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // استعلام لجلب البيانات من Firestore
  Future<List<Map<String, dynamic>>> fetchData(String collection) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.notifications, color: Colors.black),
          onPressed: () {
            // Action for notifications
          },
        ),
        centerTitle: true,
        title: const Text(
          'KUNHII',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile_picture.jpg'),
            ),
            onPressed: () {
              // Action for profile navigation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            SizedBox(
              height: 200,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchData('hero'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Data Available"));
                  }
                  return PageView(
                    children: snapshot.data!
                        .map((item) => _buildHeroItem(item['image'], item['label']))
                        .toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Categories
            _buildSectionTitle('Categories'),
            SizedBox(
              height: 40,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchData('categories'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Categories"));
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!
                        .map((item) => _buildCategoryItem(item['name']))
                        .toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Offers Section
            _buildSectionTitle('Offers'),
            SizedBox(
              height: 150,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchData('offers'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Offers"));
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!
                        .map((item) => _buildOfferItem(item['label'], item['image']))
                        .toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Trending Products
            _buildSectionTitle('Trending This Year'),
            SizedBox(
              height: 200,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchData('trending'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Trending Products"));
                  }
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2 / 3,
                    children: snapshot.data!
                        .map((item) => _buildTrendingProduct(item['name'], item['image'], item['price'], item['oldPrice']))
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shops'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.brush), label: 'Makeup'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // Helper Components
  Widget _buildHeroItem(String imagePath, String label) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(imagePath, fit: BoxFit.cover),
        Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 10, color: Colors.black, offset: Offset(0, 2))],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(
        label: Text(category),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }

  Widget _buildOfferItem(String label, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(imagePath, fit: BoxFit.cover, width: 250),
      ),
    );
  }

  Widget _buildTrendingProduct(String name, String imagePath, double price, double oldPrice) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imagePath, fit: BoxFit.cover, height: 120, width: double.infinity),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('EGP $price', style: const TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
