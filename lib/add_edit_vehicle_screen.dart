import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'app_links.dart';
import 'app_theme.dart';
import 'models/vehicle.dart';

class AddEditVehicleScreen extends StatefulWidget {
  final Vehicle? vehicle;

  const AddEditVehicleScreen({Key? key, this.vehicle}) : super(key: key);

  @override
  _AddEditVehicleScreenState createState() => _AddEditVehicleScreenState();
}

class _AddEditVehicleScreenState extends State<AddEditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      _vehicleNameController.text = widget.vehicle!.vehicleName;
      _plateNumberController.text = widget.vehicle!.plateNumber;
    }
  }

  Future<void> _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      final vehicleName = _vehicleNameController.text;
      final plateNumber = _plateNumberController.text;

      final vehicle = Vehicle(vehicleName: vehicleName, plateNumber: plateNumber);

      final url = AppLinks.vehicles;
      final headers = {'Content-Type': 'application/json'};

      try {
        http.Response response;
        if (widget.vehicle == null) {
          // Add new vehicle
          response = await http.post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(vehicle.toJson()),
          );
        } else {
          // Edit existing vehicle
          final updatedVehicle = Vehicle(
            vehicleID: widget.vehicle!.vehicleID,
            vehicleName: vehicleName,
            plateNumber: plateNumber,
          );
          response = await http.put(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(updatedVehicle.toJson()),
          );
        }

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('وسیله نقلیه با موفقیت ذخیره شد')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ذخیره وسیله نقلیه با خطا مواجه شد')),
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
            widget.vehicle == null ? 'افزودن وسیله نقلیه' : 'ویرایش وسیله نقلیه',
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
                  controller: _vehicleNameController,
                  decoration: InputDecoration(
                    labelText: 'نام وسیله نقلیه',
                    labelStyle: TextStyle(color: AppTheme.secondaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا نام وسیله نقلیه را وارد کنید';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _plateNumberController,
                  decoration: InputDecoration(
                    labelText: 'شماره پلاک',
                    labelStyle: TextStyle(color: AppTheme.secondaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لطفا شماره پلاک را وارد کنید';
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
                  onPressed: _saveVehicle,
                  child: Text('ذخیره وسیله نقلیه'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 