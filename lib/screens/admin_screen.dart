import 'package:flutter/material.dart';
import 'manage_shops.dart';
import 'manage_products_screen.dart';
import 'orders_screen.dart'; // إدارة الطلبات
import 'offers_screen.dart'; // إدارة العروض

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildDashboardTile(
              context,
              icon: Icons.store,
              title: 'Manage Shops',
              route: MaterialPageRoute(builder: (context) => ManageShopsScreen()),
            ),
            _buildDashboardTile(
              context,
              icon: Icons.production_quantity_limits,
              title: 'Manage Products',
              route: MaterialPageRoute(builder: (context) => ManageProductsScreen()),
            ),
            _buildDashboardTile(
              context,
              icon: Icons.list_alt,
              title: 'Manage Orders',
              route: MaterialPageRoute(builder: (context) => OrdersScreen()),
            ),
            _buildDashboardTile(
              context,
              icon: Icons.local_offer,
              title: 'Manage Offers',
              route: MaterialPageRoute(builder: (context) => OffersScreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required MaterialPageRoute route,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, route);
      },
      child: Card(
        color: Colors.grey.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
