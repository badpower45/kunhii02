import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadAvatarImages extends StatefulWidget {
  const UploadAvatarImages({super.key});

  @override
  State<UploadAvatarImages> createState() => _UploadAvatarImagesState();
}

class _UploadAvatarImagesState extends State<UploadAvatarImages> {
  File? _selectedImage;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    try {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('avatars/${DateTime.now()}.jpg');

      final uploadTask = storageRef.putFile(_selectedImage!);

      // Listen for progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress =
            snapshot.bytesTransferred / snapshot.totalBytes;
        setState(() {
          _uploadProgress = progress;
        });
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Save the download URL to Firestore
      await FirebaseFirestore.instance.collection('avatars').add({
        'imageUrl': downloadUrl,
        'uploadedAt': DateTime.now(),
      });

      // Ensure the widget is still mounted
      if (!mounted) return;

      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully!')),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Avatar Images'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _selectedImage != null
                ? Image.file(_selectedImage!)
                : const Placeholder(
                    fallbackHeight: 200,
                    fallbackWidth: double.infinity,
                  ),
            const SizedBox(height: 20),
            if (_isUploading)
              Column(
                children: [
                  LinearProgressIndicator(value: _uploadProgress),
                  const SizedBox(height: 10),
                  Text(
                    'Uploading: ${(_uploadProgress * 100).toStringAsFixed(2)}%',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadImage,
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
