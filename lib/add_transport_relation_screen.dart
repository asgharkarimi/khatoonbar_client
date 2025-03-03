import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_theme.dart';
import 'app_links.dart';

class AddTransportRelationScreen extends StatefulWidget {
  const AddTransportRelationScreen({Key? key}) : super(key: key);

  @override
  _AddTransportRelationScreenState createState() => _AddTransportRelationScreenState();
}

class _AddTransportRelationScreenState extends State<AddTransportRelationScreen> {
  List<Map<String, dynamic>> _cargos = [];
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _drivers = [];
  List<Map<String, dynamic>> _expenses = [];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  String? _selectedCargoId;
  String? _selectedCustomerId;
  String? _selectedDriverId;
  String? _selectedExpenseId;
  String? _selectedVehicleId;
  List<Map<String, dynamic>> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Helper function to validate selected ID
  bool isValidId(String? selectedId, List<Map<String, dynamic>> list) {
    if (selectedId == null) return false;
    return list.any((item) => item['ID'].toString() == selectedId);
  }

  Future<void> _fetchData() async {
    await Future.wait([
      _fetchDrivers(),
      _fetchVehicles(),
      _fetchCustomers(),
      _fetchCargos(),
      _fetchExpenses(),
    ]);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchDrivers() async {
    final response = await http.get(Uri.parse(AppLinks.drivers));
    if (response.statusCode == 200) {
      setState(() {
        _drivers = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('دریافت رانندگان با خطا مواجه شد')),
      );
    }
  }

  Future<void> _fetchVehicles() async {
    final response = await http.get(Uri.parse(AppLinks.vehicles));
    if (response.statusCode == 200) {
      setState(() {
        _vehicles = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('دریافت وسایل نقلیه با خطا مواجه شد')),
      );
    }
  }

  Future<void> _fetchCustomers() async {
    final response = await http.get(Uri.parse(AppLinks.customers));
    if (response.statusCode == 200) {
      setState(() {
        _customers = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('دریافت مشتریان با خطا مواجه شد')),
      );
    }
  }

  Future<void> _fetchCargos() async {
    final response = await http.get(Uri.parse(AppLinks.cargos));
    if (response.statusCode == 200) {
      setState(() {
        _cargos = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('دریافت بارها با خطا مواجه شد')),
      );
    }
  }

  Future<void> _fetchExpenses() async {
    final response = await http.get(Uri.parse(AppLinks.expenses));
    if (response.statusCode == 200) {
      setState(() {
        _expenses = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('دریافت هزینه ها با خطا مواجه شد')),
      );
    }
  }

  Future<void> _addTransportRelation() async {
    if (_formKey.currentState!.validate()) {
      // Validate selected IDs before submitting
      if (!isValidId(_selectedDriverId, _drivers) ||
          !isValidId(_selectedVehicleId, _vehicles) ||
          !isValidId(_selectedCargoId, _cargos) ||
          !isValidId(_selectedCustomerId, _customers) ||
          !isValidId(_selectedExpenseId, _expenses)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('شناسه های انتخاب شده معتبر نیستند')),
        );
        return;
      }

      final url = Uri.parse(AppLinks.transportRelations);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'DriverID': int.parse(_selectedDriverId!),
          'VehicleID': int.parse(_selectedVehicleId!),
          'CargoID': int.parse(_selectedCargoId!),
          'CustomerID': int.parse(_selectedCustomerId!),
          'ExpenseID': int.parse(_selectedExpenseId!),
        }),
      );

      // Print the entire response to the debug console
      print('Server Response: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('رابطه حمل و نقل با موفقیت اضافه شد')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('اضافه کردن رابطه حمل و نقل با خطا مواجه شد')),
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
          title: Text('افزودن رابطه حمل و نقل', style: TextStyle(color: AppTheme.whiteColor)),
          backgroundColor: AppTheme.primaryColor,
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'راننده',
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedDriverId,
                        items: _drivers.isEmpty
                            ? [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('هیچ راننده ای وجود ندارد'),
                                )
                              ]
                            : _drivers.map((driver) {
                                return DropdownMenuItem<String>(
                                  value: driver['ID'].toString(),
                                  child: Text('${driver['FirstName']} ${driver['LastName']}' ?? 'Unknown'),
                                );
                              }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDriverId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا یک راننده انتخاب کنید';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'وسیله نقلیه',
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedVehicleId,
                        items: _vehicles.isEmpty
                            ? [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('هیچ وسیله نقلیه ای وجود ندارد'),
                                )
                              ]
                            : _vehicles.map((vehicle) {
                                return DropdownMenuItem<String>(
                                  value: vehicle['ID'].toString(),
                                  child: Text(vehicle['VehicleName'] ?? 'Unknown'),
                                );
                              }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedVehicleId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا یک وسیله نقلیه انتخاب کنید';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'بار',
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedCargoId,
                        items: _cargos.isEmpty
                            ? [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('هیچ باری وجود ندارد'),
                                )
                              ]
                            : _cargos.map((cargo) {
                                return DropdownMenuItem<String>(
                                  value: cargo['ID'].toString(),
                                  child: Text('${cargo['Origin']} -> ${cargo['Destination']}'),
                                );
                              }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCargoId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا یک بار انتخاب کنید';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'مشتری',
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedCustomerId,
                        items: _customers.isEmpty
                            ? [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('هیچ مشتری وجود ندارد'),
                                )
                              ]
                            : _customers.map((customer) {
                                return DropdownMenuItem<String>(
                                  value: customer['ID'].toString(),
                                  child: Text(customer['CustomerName'] ?? 'Unknown'),
                                );
                              }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCustomerId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا یک مشتری انتخاب کنید';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'هزینه',
                          labelStyle: TextStyle(color: AppTheme.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.primaryColor),
                          ),
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedExpenseId,
                        items: _expenses.isEmpty
                            ? [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('هیچ هزینه ای وجود ندارد'),
                                )
                              ]
                            : _expenses.map((expense) {
                                return DropdownMenuItem<String>(
                                  value: expense['ID'].toString(),
                                  child: Text(expense['Description'] ?? 'Unknown'),
                                );
                              }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedExpenseId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا یک هزینه انتخاب کنید';
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
                        onPressed: _addTransportRelation,
                        child: Text('افزودن رابطه حمل و نقل'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
} 