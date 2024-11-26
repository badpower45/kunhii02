import 'package:flutter/material.dart';

class ManagePostsScreen extends StatefulWidget {
  @override
  _ManagePostsScreenState createState() => _ManagePostsScreenState();
}

class _ManagePostsScreenState extends State<ManagePostsScreen> {
  final List<Map<String, dynamic>> posts = [
    // بوستات تجريبية
    {
      'id': 1,
      'shopName': 'Oakt Store',
      'description': '20% off on winter collection!',
      'image': 'assets/images/post1.jpg',
    },
    {
      'id': 2,
      'shopName': 'Urban Fashion',
      'description': 'New arrivals just landed!',
      'image': 'assets/images/post2.jpg',
    },
  ];

  // دالة لإضافة بوست جديد
  void _addPost(Map<String, dynamic> newPost) {
    setState(() {
      posts.add(newPost);
    });
  }

  // دالة لحذف بوست
  void _deletePost(int id) {
    setState(() {
      posts.removeWhere((post) => post['id'] == id);
    });
  }

  // نافذة لإضافة/تعديل بوست
  void _showPostDialog({Map<String, dynamic>? post}) {
    final TextEditingController shopNameController = TextEditingController(
        text: post != null ? post['shopName'] : '');
    final TextEditingController descriptionController = TextEditingController(
        text: post != null ? post['description'] : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(post != null ? 'Edit Post' : 'Add Post'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: shopNameController,
                decoration: InputDecoration(labelText: 'Shop Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (post != null) {
                    // تعديل بوست موجود
                    setState(() {
                      post['shopName'] = shopNameController.text;
                      post['description'] = descriptionController.text;
                    });
                  } else {
                    // إضافة بوست جديد
                    _addPost({
                      'id': DateTime.now().millisecondsSinceEpoch,
                      'shopName': shopNameController.text,
                      'description': descriptionController.text,
                      'image': 'assets/images/default_post.jpg', // صورة افتراضية
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text(post != null ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Posts'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(post['image']),
                    radius: 30,
                  ),
                  title: Text(post['shopName']),
                  subtitle: Text(post['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showPostDialog(post: post);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deletePost(post['id']);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPostDialog(),
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }
}
