import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final List<Map<String, dynamic>> cartItems = [
    {'name': 'T-Shirt', 'price': 50, 'quantity': 1},
    {'name': 'Shoes', 'price': 80, 'quantity': 2},
  ];

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _primaryAddressController = TextEditingController();
  final TextEditingController _secondaryAddressController = TextEditingController();
  final TextEditingController _primaryPhoneController = TextEditingController();
  final TextEditingController _secondaryPhoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedPaymentMethod = 'Cash';

  double get totalAmount {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  void _placeOrder() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _primaryAddressController.text.isEmpty ||
        _primaryPhoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the required fields')),
      );
      return;
    }

    // Proceed with placing the order
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully!')),
    );

    // Reset the form and cart (for demonstration)
    _firstNameController.clear();
    _lastNameController.clear();
    _primaryAddressController.clear();
    _secondaryAddressController.clear();
    _primaryPhoneController.clear();
    _secondaryPhoneController.clear();
    _notesController.clear();
    setState(() {
      cartItems.clear();
    });

    // Navigate to another page if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart Items Section
            Text(
              'Your Cart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                  trailing: Text('\$${item['price'] * item['quantity']}'),
                );
              },
            ),
            Divider(),
            // Total Amount Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Total: \$${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            // Personal Information Section
            Text(
              'Personal Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            Divider(),
            // Address Section
            Text(
              'Address Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _primaryAddressController,
              decoration: InputDecoration(labelText: 'Primary Address'),
            ),
            TextField(
              controller: _secondaryAddressController,
              decoration: InputDecoration(labelText: 'Secondary Address (Optional)'),
            ),
            Divider(),
            // Phone Numbers Section
            Text(
              'Contact Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _primaryPhoneController,
              decoration: InputDecoration(labelText: 'Primary Phone'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _secondaryPhoneController,
              decoration: InputDecoration(labelText: 'Secondary Phone (Optional)'),
              keyboardType: TextInputType.phone,
            ),
            Divider(),
            // Notes Section
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Order Notes (Optional)',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            // Payment Method Section
            Text(
              'Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Cash'),
              leading: Radio(
                value: 'Cash',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Card'),
              leading: Radio(
                value: 'Card',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            // Place Order Button
            ElevatedButton(
              onPressed: _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Center(
                child: Text(
                  'Place Order',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
