import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';
import '../services/api/products_service.dart'; // استيراد خدمة API

class ManageProductsScreen extends StatefulWidget {
  @override
  _ManageProductsScreenState createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final fetchedProducts = await ProductsService.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch products: $e')),
      );
    }
  }

  Future<void> _addProduct(Map<String, dynamic> product) async {
    final response = await ProductsService.addProduct(product);
    if (response['success']) {
      setState(() {
        products.add(response['data']);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: ${response['message']}')),
      );
    }
  }

  Future<void> _updateProduct(int index, String id, Map<String, dynamic> product) async {
    final response = await ProductsService.updateProduct(id, product);
    if (response['success']) {
      setState(() {
        products[index] = response['data'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product: ${response['message']}')),
      );
    }
  }

  Future<void> _deleteProduct(int index, String id) async {
    final response = await ProductsService.deleteProduct(id);
    if (response['success']) {
      setState(() {
        products.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product removed successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove product: ${response['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(
                  child: Text(
                    'No products available',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: product['image'] != null
                              ? NetworkImage(product['image'])
                              : null,
                          child: product['image'] == null
                              ? Icon(Icons.image_not_supported)
                              : null,
                        ),
                        title: Text(product['name']),
                        subtitle: Text('${product['price']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final updatedProduct = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProductScreen(
                                      product: product,
                                    ),
                                  ),
                                );
                                if (updatedProduct != null) {
                                  _updateProduct(index, product['id'], updatedProduct);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteProduct(index, product['id']);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(),
            ),
          );
          if (newProduct != null) {
            _addProduct(newProduct);
          }
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }
}
