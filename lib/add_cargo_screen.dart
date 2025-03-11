import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_theme.dart';
import 'app_links.dart'; // Import the AppLinks

class AddCargoScreen extends StatefulWidget {
  const AddCargoScreen({Key? key}) : super(key: key);
  @override
  _AddCargoScreenState createState() => _AddCargoScreenState();
}

class _AddCargoScreenState extends State<AddCargoScreen> {
  final _formKey = GlobalKey<FormState>();
  final String apiUrl = AppLinks.cargos;

  // Text controllers for form fields
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _shippingDateController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _pricePerTonController = TextEditingController();

  // Lists to hold data for dropdowns
  List<Map<String, dynamic>> _drivers = [];
  List<Map<String, dynamic>> _vehicles = [];
  List<Map<String, dynamic>> _cargoTypes = [];
  List<Map<String, dynamic>> _paymentTypes = []; // Added

  // Selected values for dropdowns
  String? _selectedDriverId;
  String? _selectedVehicleId;
  String? _selectedCargoTypeId;
  String? _selectedPaymentTypeId; // Added

  bool _isLoading = true; // Add a loading indicator

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    await _fetchDrivers();
    await _fetchVehicles();
    await _fetchCargoTypes();
    await _fetchPaymentTypes(); // Added
    if (!mounted) return;
    setState(() {
      _isLoading = false; // Set loading to false after data is fetched
    });
  }

  Future<void> _fetchDrivers() async {
    final response = await http.get(Uri.parse(AppLinks.drivers));
    print(response.body);
    if (!mounted) return; // Check if the widget is still in the tree
    if (response.statusCode == 200) {
      setState(() {
        _drivers = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      if (!mounted) return; // Check if the widget is still in the tree
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch drivers")),
      );
    }
  }

  Future<void> _fetchVehicles() async {
    final response = await http.get(Uri.parse(AppLinks.vehicles));
    print(response.body); // Replace with your vehicles API endpoint
    if (!mounted) return; // Check if the widget is still in the tree
    if (response.statusCode == 200) {
      setState(() {
        _vehicles = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      if (!mounted) return; // Check if the widget is still in the tree
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch vehicles")),
      );
    }
  }

  Future<void> _fetchCargoTypes() async {
    final response = await http.get(Uri.parse(AppLinks.cargoTypes));
    print(response.body); // Re// Replace with your cargo types API endpoint
    if (!mounted) return; // Check if the widget is still in the tree
    if (response.statusCode == 200) {
      setState(() {
        _cargoTypes =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      if (!mounted) return; // Check if the widget is still in the tree
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch cargo types")),
      );
    }
  }

  Future<void> _fetchPaymentTypes() async {
    // Added
    final response = await http.get(Uri.parse(AppLinks.paymentTypes));
    print(response.body);
    if (!mounted) return; // Check if the widget is still in the tree
    if (response.statusCode == 200) {
      setState(() {
        _paymentTypes =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      if (!mounted) return; // Check if the widget is still in the tree
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch payment types")),
      );
    }
  }

  Future<void> _createCargo() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "VehicleID": _selectedVehicleId,
          "DriverID": _selectedDriverId,
          "CargoTypeID": _selectedCargoTypeId,
          "Origin": _originController.text,
          "Destination": _destinationController.text,
          "ShippingDate": _shippingDateController.text,
          "Weight": double.parse(_weightController.text),
          "PricePerTon": double.parse(_pricePerTonController.text),
          "PaymentStatusID": _selectedPaymentTypeId, // Updated
        }),
      );

      if (!mounted) return; // Check if the widget is still in the tree
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("سرویس با موفقیت ایجاد شد")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("ایجاد سرویس با خطا مواجه شد")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("فرم سرویس", style: TextStyle(color: AppTheme.whiteColor)),
        backgroundColor: AppTheme.primaryColor,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _isLoading // Show loading indicator while data is loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding:
                    EdgeInsets.fromLTRB(16, 16, 16, 80), // Added bottom padding
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Driver ID Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "انتخاب راننده",
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedDriverId,
                        items: _drivers.map((driver) {
                          return DropdownMenuItem<String>(
                            value: driver['DriverID'].toString(),
                            child: Text(
                                '${driver['FirstName'] ?? ''} ${driver['LastName'] ?? ''}'),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedDriverId = value),
                        validator: (value) =>
                            value == null ? "لطفا راننده را انتخاب کنید" : null,
                      ),
                      SizedBox(height: 10),

                      // Vehicle ID Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "انتخاب وسیله نقلیه",
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedVehicleId,
                        items: _vehicles.map((vehicle) {
                          return DropdownMenuItem<String>(
                            value: vehicle['VehicleID'].toString(),
                            child: Text(vehicle['VehicleName'] ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedVehicleId = value),
                        validator: (value) => value == null
                            ? "لطفا وسیله نقلیه را انتخاب کنید"
                            : null,
                      ),
                      SizedBox(height: 10),

                      // Cargo Type ID Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "انتخاب نوع بار",
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedCargoTypeId,
                        items: _cargoTypes.map((cargoType) {
                          return DropdownMenuItem<String>(
                            value: cargoType['CargoTypeID'].toString(),
                            child: Text(cargoType['CargoTypeName'] ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedCargoTypeId = value),
                        validator: (value) => value == null
                            ? "لطفا نوع بار را انتخاب کنید"
                            : null,
                      ),
                      SizedBox(height: 10),

                      // Payment Type ID Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: "انتخاب وضعیت پرداخت",
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedPaymentTypeId,
                        items: _paymentTypes.map((paymentType) {
                          return DropdownMenuItem<String>(
                            value: paymentType['PaymentTypeID'].toString(),
                            child: Text(paymentType['PaymentTypeName'] ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            setState(() => _selectedPaymentTypeId = value),
                        validator: (value) => value == null
                            ? "لطفا وضعیت پرداخت را انتخاب کنید"
                            : null,
                      ),
                      SizedBox(height: 10),

                      // Origin
                      TextFormField(
                        controller: _originController,
                        decoration: InputDecoration(
                          labelText: "مبدا",
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "لطفا مبدا را وارد کنید";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                      // Destination
                      TextFormField(
                        controller: _destinationController,
                        decoration: InputDecoration(
                          labelText: "مقصد",
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "لطفا مقصد را وارد کنید";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                      // Shipping Date
                      TextFormField(
                        controller: _shippingDateController,
                        decoration: InputDecoration(
                          labelText: "تاریخ حمل",
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "لطفا تاریخ حمل را وارد کنید";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                      // Weight
                      TextFormField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          labelText: "وزن",
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "لطفا وزن را وارد کنید";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),

                      // Price Per Ton
                      TextFormField(
                        controller: _pricePerTonController,
                        decoration: InputDecoration(
                          labelText: "قیمت به ازای هر تن",
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "لطفا قیمت به ازای هر تن را وارد کنید";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 48,
        child: FloatingActionButton.extended(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: AppTheme.whiteColor,
          onPressed: _createCargo,
          label: Text(
            "ایجاد سرویس",
            style: TextStyle(color: AppTheme.whiteColor),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
