import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InputBodyMeasurementsPage extends StatefulWidget {
  const InputBodyMeasurementsPage({super.key});

  @override
  State<InputBodyMeasurementsPage> createState() => _InputBodyMeasurementsPageState();
}

class _InputBodyMeasurementsPageState extends State<InputBodyMeasurementsPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _chestController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _hipsController = TextEditingController();

  Future<void> _saveMeasurements() async {
    if (_heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _chestController.text.isEmpty ||
        _waistController.text.isEmpty ||
        _hipsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    try {
      const userId = 'example-user-id'; // يجب استبدال هذا بمعرف المستخدم الحقيقي
      await FirebaseFirestore.instance.collection('measurements').doc(userId).set({
        'height': _heightController.text,
        'weight': _weightController.text,
        'chest': _chestController.text,
        'waist': _waistController.text,
        'hips': _hipsController.text,
        'timestamp': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Measurements saved successfully')),
        );

        // الانتقال إلى صفحة رفع الصور
        Navigator.pushNamed(context, '/upload_avatar_images');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save measurements: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Measurements'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_heightController, 'Height (cm)'),
            const SizedBox(height: 10),
            _buildTextField(_weightController, 'Weight (kg)'),
            const SizedBox(height: 10),
            _buildTextField(_chestController, 'Chest (cm)'),
            const SizedBox(height: 10),
            _buildTextField(_waistController, 'Waist (cm)'),
            const SizedBox(height: 10),
            _buildTextField(_hipsController, 'Hips (cm)'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMeasurements,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text('Save Measurements'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
