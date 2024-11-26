import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final productData = {
        'name': productNameController.text,
        'description': productDescriptionController.text,
        'category': categoryController.text,
        'tags': tagsController.text,
        'price': priceController.text,
        'salePrice': salePriceController.text,
        'image': null, // أضف الربط بالصورة لاحقًا
      };

      Navigator.pop(context, productData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Product Name', productNameController),
                _buildTextField('Description', productDescriptionController),
                _buildTextField('Category', categoryController),
                _buildTextField('Tags', tagsController),
                _buildTextField('Price', priceController, inputType: TextInputType.number),
                _buildTextField('Sale Price', salePriceController, inputType: TextInputType.number),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: Text('Save Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
