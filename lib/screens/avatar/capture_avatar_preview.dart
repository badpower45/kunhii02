import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CaptureAvatarPreviewPage extends StatefulWidget {
  const CaptureAvatarPreviewPage({super.key});

  @override
  State<CaptureAvatarPreviewPage> createState() =>
      _CaptureAvatarPreviewPageState();
}

class _CaptureAvatarPreviewPageState extends State<CaptureAvatarPreviewPage> {
  List<String> _uploadedImages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUploadedImages();
  }

  Future<void> _fetchUploadedImages() async {
    try {
      const userId = 'example-user-id'; // استخدم معرف المستخدم الحقيقي
      final avatarsSnapshot = await FirebaseFirestore.instance
          .collection('avatars')
          .where('userId', isEqualTo: userId)
          .get();

      if (avatarsSnapshot.docs.isNotEmpty) {
        setState(() {
          _uploadedImages = avatarsSnapshot.docs
              .map((doc) => doc['imageUrl'] as String)
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch images: $e')),
        );
      }
    }
  }

  Future<void> _removeImage(String imageUrl) async {
    try {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      const userId = 'example-user-id'; // استخدم معرف المستخدم الحقيقي
      final avatarsSnapshot = await FirebaseFirestore.instance
          .collection('avatars')
          .where('userId', isEqualTo: userId)
          .where('imageUrl', isEqualTo: imageUrl)
          .get();

      for (var doc in avatarsSnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('avatars')
            .doc(doc.id)
            .delete();
      }

      setState(() {
        _uploadedImages.remove(imageUrl);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image removed successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Avatar Images'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _uploadedImages.isEmpty
              ? const Center(
                  child: Text(
                    'No images uploaded yet!',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: _uploadedImages.length,
                        itemBuilder: (context, index) {
                          final imageUrl = _uploadedImages[index];
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => _removeImage(imageUrl),
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/process_avatar');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text('Proceed to Process Avatar'),
                    ),
                  ],
                ),
    );
  }
}
