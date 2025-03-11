import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_theme.dart';
import 'text_input_style.dart';

//نوع بار
class AddCargoTypeScreen extends StatefulWidget {
  @override
  _AddCargoTypeScreenState createState() => _AddCargoTypeScreenState();
}

class _AddCargoTypeScreenState extends State<AddCargoTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cargoTypeNameController = TextEditingController();
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final cargoTypeData = {
        'CargoTypeName': _cargoTypeNameController.text,
      };

      try {
        final response = await http.post(
          Uri.parse('http://192.168.192.166/khatoonbar/api/cargo_types.php'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(cargoTypeData),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  responseData['message'] ?? 'نوع بار با موفقیت افزوده شد'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'خطا در افزودن نوع بار. کد وضعیت: ${response.statusCode}'),
              backgroundColor: AppTheme.dangerColor,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در ارتباط با سرور: $e'),
            backgroundColor: AppTheme.dangerColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('افزودن نوع بار',
            style: TextStyle(
                color: AppTheme.whiteColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.lightColor, AppTheme.whiteColor],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildInputField(
                  controller: _cargoTypeNameController,
                  label: 'نام نوع بار',
                  icon: Icons.local_shipping,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا نام نوع بار را وارد کنید';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: AppTheme.whiteColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'افزودن نوع بار',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.whiteColor,
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      decoration: TextInputStyle.getInputDecoration(
        labelText: label,
        prefixIcon: icon,
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _cargoTypeNameController.dispose();
    super.dispose();
  }
}
