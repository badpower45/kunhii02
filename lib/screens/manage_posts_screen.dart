import 'package:flutter/material.dart';

class ManagePostsScreen extends StatefulWidget {
  @override
  _ManagePostsScreenState createState() => _ManagePostsScreenState();
}

class _ManagePostsScreenState extends State<ManagePostsScreen> {
  List<Map<String, dynamic>> posts = [
    {
      'shopName': 'Oakt Store',
      'postImage': 'assets/images/post1.jpg',
      'description': '20% off on winter collection!',
    },
    {
      'shopName': 'Urban Fashion',
      'postImage': 'assets/images/post2.jpg',
      'description': 'New arrivals just dropped!',
    },
  ];

  void _addPost() {
    // Function to add a new post
    setState(() {
      posts.add({
        'shopName': 'New Shop',
        'postImage': 'assets/images/post3.jpg',
        'description': 'Exciting offer for you!',
      });
    });
  }

  void _editPost(int index) {
    // Function to edit a post
    setState(() {
      posts[index]['description'] = 'Updated post description';
    });
  }

  void _deletePost(int index) {
    // Function to delete a post
    setState(() {
      posts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Posts'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(
                post['postImage'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(post['shopName']),
              subtitle: Text(post['description']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editPost(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletePost(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPost,
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }
}
