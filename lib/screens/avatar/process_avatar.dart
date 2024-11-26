import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProcessAvatarPage extends StatefulWidget {
  const ProcessAvatarPage({super.key});

  @override
  State<ProcessAvatarPage> createState() => _ProcessAvatarPageState();
}

class _ProcessAvatarPageState extends State<ProcessAvatarPage> {
  bool _isProcessing = false;

  Future<void> _processAvatar() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // الحصول على بيانات الأفاتار الأخيرة
      final avatarsSnapshot = await FirebaseFirestore.instance
          .collection('avatars')
          .orderBy('uploadedAt', descending: true)
          .limit(1)
          .get();

      if (avatarsSnapshot.docs.isEmpty) {
        throw Exception('No avatars found to process.');
      }

      final avatarData = avatarsSnapshot.docs.first.data();
      final imageUrl = avatarData['imageUrl'];

      // محاكاة عملية المعالجة
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar processed successfully!')),
        );

        // الانتقال إلى صفحة عرض الأفاتار النهائي
        Navigator.pushNamed(context, '/view_generated_avatar', arguments: imageUrl);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to process avatar: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Avatar'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: _isProcessing
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Processing your avatar...',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: _isProcessing ? null : _processAvatar, // تعطيل الزر أثناء التحميل
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Start Processing',
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}
