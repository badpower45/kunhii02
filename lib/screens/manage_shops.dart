import 'package:flutter/material.dart';

class ManageShopsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Shops'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            _buildShopTile(context, 'Shop 1', 'Active', Colors.green),
            _buildShopTile(context, 'Shop 2', 'Pending', Colors.orange),
            _buildShopTile(context, 'Shop 3', 'Suspended', Colors.red),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // إضافة محل جديد
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Add Shop Clicked")),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildShopTile(
      BuildContext context, String shopName, String status, Color statusColor) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clicked on $shopName')),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.store, color: Colors.black),
          ),
          title: Text(shopName),
          subtitle: Text(
            'Status: $status',
            style: TextStyle(color: statusColor),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
