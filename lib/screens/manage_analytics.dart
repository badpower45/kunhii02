import 'package:flutter/material.dart';

class ManageAnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Analytics'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAnalyticsCard(
              title: 'Total Sales',
              value: '\$10,000',
              icon: Icons.attach_money,
            ),
            _buildAnalyticsCard(
              title: 'Total Orders',
              value: '150',
              icon: Icons.shopping_cart,
            ),
            _buildAnalyticsCard(
              title: 'Active Users',
              value: '1200',
              icon: Icons.people,
            ),
            _buildAnalyticsCard(
              title: 'Top Product',
              value: 'T-Shirt',
              icon: Icons.star,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard({required String title, required String value, required IconData icon}) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
