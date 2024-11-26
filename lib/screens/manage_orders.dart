import 'package:flutter/material.dart';

class ManageOrdersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      'orderId': '12345',
      'customerName': 'John Doe',
      'totalAmount': '\$150',
      'status': 'Pending',
    },
    {
      'orderId': '12346',
      'customerName': 'Jane Smith',
      'totalAmount': '\$200',
      'status': 'Completed',
    },
    {
      'orderId': '12347',
      'customerName': 'Ali Ahmed',
      'totalAmount': '\$100',
      'status': 'Shipped',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            color: Colors.grey.shade900,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                'Order ID: ${order['orderId']}',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer: ${order['customerName']}', style: TextStyle(color: Colors.grey)),
                  Text('Total: ${order['totalAmount']}', style: TextStyle(color: Colors.grey)),
                  Text('Status: ${order['status']}', style: TextStyle(color: Colors.blue)),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  // Perform actions based on the selected option
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected: $value')),
                  );
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'View', child: Text('View Details')),
                  PopupMenuItem(value: 'Cancel', child: Text('Cancel Order')),
                  PopupMenuItem(value: 'Mark as Shipped', child: Text('Mark as Shipped')),
                ],
                icon: Icon(Icons.more_vert, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
