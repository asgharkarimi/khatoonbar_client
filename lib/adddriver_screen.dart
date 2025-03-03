import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({super.key});

  @override
  _AddDriverScreenState createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nationalCodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _nationalCardImage;
  String? _licenseImage;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await ApiServices.addDriver(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        nationalCode: _nationalCodeController.text,
        phoneNumber: _phoneNumberController.text,
        password: _passwordController.text,
        nationalCardImage: _nationalCardImage,
        licenseImage: _licenseImage,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: response['success'] ? Colors.green : Colors.red,
        ),
      );

      if (response['success']) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _pickImage(bool isNationalCard) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        final base64Image = base64Encode(bytes);
        
        setState(() {
          if (isNationalCard) {
            _nationalCardImage = base64Image;
          } else {
            _licenseImage = base64Image;
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isNationalCard ? 'کارت ملی بارگذاری شد' : 'گواهینامه بارگذاری شد'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطا در بارگذاری تصویر: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('افزودن راننده جدید',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'اطلاعات راننده',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildInputField(
                          controller: _firstNameController,
                          label: 'نام',
                          icon: Icons.person,
                        ),
                        SizedBox(height: 12),
                        _buildInputField(
                          controller: _lastNameController,
                          label: 'نام خانوادگی',
                          icon: Icons.person_outline,
                        ),
                        SizedBox(height: 12),
                        _buildInputField(
                          controller: _nationalCodeController,
                          label: 'کد ملی',
                          icon: Icons.credit_card,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'لطفا کد ملی را وارد کنید';
                            }
                            if (value.length != 10) {
                              return 'کد ملی باید ۱۰ رقم باشد';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
                        _buildInputField(
                          controller: _phoneNumberController,
                          label: 'شماره تلفن',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 12),
                        _buildInputField(
                          controller: _passwordController,
                          label: 'رمز عبور',
                          icon: Icons.lock,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'لطفا رمز عبور را وارد کنید';
                            }
                            if (value.length < 6) {
                              return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'بارگذاری مدارک',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildImageButton(
                                text: 'کارت ملی',
                                onPressed: () => _pickImage(true),
                                icon: Icons.credit_card,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: _buildImageButton(
                                text: 'گواهینامه',
                                onPressed: () => _pickImage(false),
                                icon: Icons.drive_eta,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'افزودن راننده',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade800),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }

  Widget _buildImageButton({
    required String text,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.blue.shade800, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue.shade800, size: 20),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.blue.shade800,
              fontSize: 14,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.check_circle,
            color: (text == 'کارت ملی' && _nationalCardImage != null) ||
                    (text == 'گواهینامه' && _licenseImage != null)
                ? Colors.green
                : Colors.transparent,
            size: 16,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nationalCodeController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}