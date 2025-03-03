import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'app_links.dart';
import 'app_theme.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({Key? key}) : super(key: key);

  @override
  _AddDriverScreenState createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nationalCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _nationalCardImageFile;
  File? _licenseImageFile;

  Future<void> _pickImage(String type) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        setState(() {
          if (type == 'nationalCard') {
            _nationalCardImageFile = imageFile;
          } else {
            _licenseImageFile = imageFile;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addDriver() async {
    if (_formKey.currentState!.validate()) {
      var request = http.MultipartRequest('POST', Uri.parse(AppLinks.drivers));
      request.fields['FirstName'] = _firstNameController.text;
      request.fields['LastName'] = _lastNameController.text;
      request.fields['NationalCode'] = _nationalCodeController.text;
      request.fields['PhoneNumber'] = _phoneNumberController.text;
      request.fields['Password'] = _passwordController.text;

      if (_nationalCardImageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'NationalCardImage',
          _nationalCardImageFile!.path,
        ));
      }

      if (_licenseImageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'LicenseImage',
          _licenseImageFile!.path,
        ));
      }

      // Print request details to console
      print("Request URL: ${request.url}");
      print("Request Fields: ${request.fields}");
      print("Request Files: ${request.files.map((f) => f.filename).toList()}");

      try {
        var response = await request.send();
        final respStr = await response.stream.bytesToString();
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${respStr}");
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('راننده با موفقیت اضافه شد')),
          );
          Navigator.pop(context);
        } else {
          print("Error Response: ${response.statusCode} - ${response.reasonPhrase}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('اضافه کردن راننده با خطا مواجه شد')),
          );
        }
      } catch (e) {
        print("Exception: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('افزودن راننده', style: TextStyle(color: AppTheme.whiteColor)),
          backgroundColor: AppTheme.primaryColor,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'نام',
                    labelStyle: TextStyle(color: AppTheme.secondaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا نام را وارد کنید';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'نام خانوادگی',
                    labelStyle: TextStyle(color: AppTheme.secondaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا نام خانوادگی را وارد کنید';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nationalCodeController,
                  decoration: InputDecoration(
                    labelText: 'کد ملی',
                    labelStyle: TextStyle(color: AppTheme.secondaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا کد ملی را وارد کنید';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'شماره تلفن',
                    labelStyle: TextStyle(color: AppTheme.secondaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا شماره تلفن را وارد کنید';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'رمز عبور',
                    labelStyle: TextStyle(color: AppTheme.secondaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا رمز عبور را وارد کنید';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _pickImage('nationalCard'),
                  child: Text('انتخاب تصویر کارت ملی'),
                ),
                _nationalCardImageFile != null
                    ? Image.file(_nationalCardImageFile!)
                    : SizedBox.shrink(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _pickImage('license'),
                  child: Text('انتخاب تصویر گواهینامه'),
                ),
                _licenseImageFile != null
                    ? Image.file(_licenseImageFile!)
                    : SizedBox.shrink(),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: AppTheme.whiteColor,
                  ),
                  onPressed: _addDriver,
                  child: Text('افزودن راننده'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 