import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      'orderId': '001',
      'customerName': 'John Doe',
      'status': 'Pending',
      'total': '\$120',
      'items': ['T-Shirt', 'Jeans'],
    },
    {
      'orderId': '002',
      'customerName': 'Jane Smith',
      'status': 'Shipped',
      'total': '\$200',
      'items': ['Shoes', 'Bag'],
    },
    {
      'orderId': '003',
      'customerName': 'Alex Johnson',
      'status': 'Delivered',
      'total': '\$80',
      'items': ['Hoodie'],
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
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Order #${order['orderId']} - ${order['customerName']}'),
              subtitle: Text('Status: ${order['status']}\nTotal: ${order['total']}'),
              trailing: DropdownButton<String>(
                value: order['status'],
                onChanged: (String? newStatus) {
                  // تعديل الحالة هنا (ربط مع Firebase لاحقًا)
                },
                items: ['Pending', 'Shipped', 'Delivered']
                    .map<DropdownMenuItem<String>>(
                      (status) => DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      ),
                    )
                    .toList(),
              ),
              onTap: () {
                // عرض تفاصيل الطلب
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Order Details'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Items: ${order['items'].join(', ')}'),
                        SizedBox(height: 10),
                        Text('Total: ${order['total']}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
