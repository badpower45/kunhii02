import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  final List<Map<String, String>> offers = [
    {'title': 'Winter Sale', 'discount': '20%'},
    {'title': 'Summer Collection', 'discount': '15%'},
  ];

  void _addOffer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String discount = '';
        return AlertDialog(
          title: Text('Add New Offer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Offer Title'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Discount'),
                onChanged: (value) => discount = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // إضافة العرض هنا (Firebase لاحقًا)
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Offers'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _addOffer(context),
            child: Text('Add Offer'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(offer['title']!),
                    subtitle: Text('Discount: ${offer['discount']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // حذف العرض (Firebase لاحقًا)
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
