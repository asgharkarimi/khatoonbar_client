import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'app_links.dart';
import 'app_theme.dart';
import 'models/cargo_type.dart';

class AddEditCargoTypeScreen extends StatefulWidget {
  final CargoType? cargoType;

  const AddEditCargoTypeScreen({Key? key, this.cargoType}) : super(key: key);

  @override
  _AddEditCargoTypeScreenState createState() => _AddEditCargoTypeScreenState();
}

class _AddEditCargoTypeScreenState extends State<AddEditCargoTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cargoTypeNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.cargoType != null) {
      _cargoTypeNameController.text = widget.cargoType!.cargoTypeName;
    }
  }

  Future<void> _saveCargoType() async {
    if (_formKey.currentState!.validate()) {
      final cargoTypeName = _cargoTypeNameController.text;

      final cargoType = CargoType(cargoTypeName: cargoTypeName);

      final url = AppLinks.cargoTypes;
      final headers = {'Content-Type': 'application/json'};

      try {
        http.Response response;
        if (widget.cargoType == null) {
          // Add new cargo type
          response = await http.post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(cargoType.toJson()),
          );
        } else {
          // Edit existing cargo type
          final updatedCargoType = CargoType(
            cargoTypeID: widget.cargoType!.cargoTypeID,
            cargoTypeName: cargoTypeName,
          );
          response = await http.put(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(updatedCargoType.toJson()),
          );
        }

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('نوع بار با موفقیت ذخیره شد')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ذخیره نوع بار با خطا مواجه شد')),
          );
        }
      } catch (e) {
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
          title: Text(
            widget.cargoType == null ? 'افزودن نوع بار' : 'ویرایش نوع بار',
            style: TextStyle(color: AppTheme.whiteColor),
          ),
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
                  controller: _cargoTypeNameController,
                  decoration: InputDecoration(
                    labelText: 'نام نوع بار',
                    labelStyle: TextStyle(color: AppTheme.secondaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا نام نوع بار را وارد کنید';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: AppTheme.whiteColor,
                  ),
                  onPressed: _saveCargoType,
                  child: Text('ذخیره نوع بار'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 