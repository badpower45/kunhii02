import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _profileImagePath; // مسار صورة المستخدم الافتراضية

  // اختيار صورة من المعرض
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery); // اختيار الصورة من المعرض
    if (image != null) {
      setState(() {
        _profileImagePath = image.path; // تحديث مسار الصورة
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/profile.jpg'), // الصورة الخلفية
                fit: BoxFit.cover,
              ),
            ),
          ),
          // المحتوى
          SafeArea(
            child: Column(
              children: [
                // زر الرجوع والشعار
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // العودة إلى الشاشة السابقة
                        },
                      ),
                      Spacer(),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // صورة المستخدم
                GestureDetector(
                  onTap: _pickImage, // تغيير الصورة عند الضغط عليها
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImagePath != null
                        ? FileImage(File(_profileImagePath!))
                        : AssetImage('assets/images/profile_picture.jpg') as ImageProvider,
                  ),
                ),
                SizedBox(height: 10),

                // اسم المستخدم
                Text(
                  'Toka Mahmoud', // اسم افتراضي
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30),

                // الخيارات
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        // تعديل الاسم
                        _buildProfileOption(
                          context,
                          icon: Icons.edit,
                          text: 'Edit Profile Name',
                          onTap: () {
                            // Action for editing profile name
                          },
                        ),
                        SizedBox(height: 10),

                        // تغيير كلمة المرور
                        _buildProfileOption(
                          context,
                          icon: Icons.lock,
                          text: 'Change Password',
                          onTap: () {
                            // Action for changing password
                          },
                        ),
                        SizedBox(height: 10),

                        // تغيير البريد الإلكتروني
                        _buildProfileOption(
                          context,
                          icon: Icons.email,
                          text: 'Change Email Address',
                          onTap: () {
                            // Action for changing email
                          },
                        ),
                        SizedBox(height: 10),

                        // الإعدادات
                        _buildProfileOption(
                          context,
                          icon: Icons.settings,
                          text: 'Settings',
                          onTap: () {
                            // Action for opening settings
                          },
                        ),
                        Spacer(),

                        // زر تسجيل الخروج
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (Route<dynamic> route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Log Out',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required IconData icon, required String text, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
