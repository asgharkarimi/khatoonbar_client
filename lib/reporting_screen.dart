import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'app_links.dart';
import 'app_theme.dart';
import 'package:intl/intl.dart' as intl;

class ReportingScreen extends StatefulWidget {
  @override
  _ReportingScreenState createState() => _ReportingScreenState();
}

class _ReportingScreenState extends State<ReportingScreen> {
  List<dynamic> _cargos = [];
  List<dynamic> _expenses = []; // List to hold expenses
  bool _isLoading = true;
  bool _showRevenueReport = false;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch both cargos and expenses
  }

  Future<void> _fetchData() async {
    await Future.wait([_fetchCargos(), _fetchExpenses()]); // Fetch both in parallel
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchCargos() async {
    final response = await http.get(Uri.parse(AppLinks.cargos));
    if (response.statusCode == 200) {
      setState(() {
        _cargos = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cargos')),
      );
    }
  }

  Future<void> _fetchExpenses() async {
    final response = await http.get(Uri.parse(AppLinks.expenses));
    if (response.statusCode == 200) {
      setState(() {
        _expenses = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load expenses')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'هزینه های پرداخت شده'),
              Tab(text: 'هزینه های پرداخت نشده'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildExpenseList(), // Display expenses in the first tab
            _buildIncomeList(false), // Unreceived Incomes
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
    }

    if (_expenses.isEmpty) {
      return Center(child: Text('هیچ هزینه ای یافت نشد', style: TextStyle(color: AppTheme.secondaryColor)));
    }

    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final expense = _expenses[index];
        double totalExpense = calculateTotalExpense(expense);

        // Find the corresponding cargo
        final cargo = _cargos.firstWhere(
          (c) => c['CargoID'].toString() == expense['CargoID'].toString(),
          orElse: () => null,
        );

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (cargo != null) ...[
                  _buildInfoRow('مبدا', cargo['Origin'], fontWeight: FontWeight.w500),
                  _buildInfoRow('مقصد', cargo['Destination'], fontWeight: FontWeight.w500),
                ],
                if (expense['BillOfLadingCost'] != null && double.tryParse(expense['BillOfLadingCost']?.toString() ?? '0') != 0)
                  _buildCostRow(
                    'هزینه بارنامه',
                    expense['BillOfLadingCost'],
                    expense['BillOfLadingImage'],
                    context,
                  ),
                if (expense['HighwayToll'] != null && double.tryParse(expense['HighwayToll']?.toString() ?? '0') != 0)
                  _buildCostRow(
                    'عوارض جاده ای',
                    expense['HighwayToll'],
                    expense['HighwayTollImage'],
                    context,
                  ),
                if (expense['DieselCost'] != null && double.tryParse(expense['DieselCost']?.toString() ?? '0') != 0)
                  _buildCostRow(
                    'هزینه گازوئیل',
                    expense['DieselCost'],
                    expense['DieselCostImage'],
                    context,
                  ),
                if (expense['LoadingTip'] != null && double.tryParse(expense['LoadingTip']?.toString() ?? '0') != 0)
                  _buildCostRow(
                    'انعام بارگیری',
                    expense['LoadingTip'],
                    expense['LoadingTipImage'],
                    context,
                  ),
                if (expense['UnloadingTip'] != null && double.tryParse(expense['UnloadingTip']?.toString() ?? '0') != 0)
                  _buildCostRow(
                    'انعام تخلیه',
                    expense['UnloadingTip'],
                    expense['UnloadingTipImage'],
                    context,
                  ),
                if (expense['DisinfectionCost'] != null && double.tryParse(expense['DisinfectionCost']?.toString() ?? '0') != 0)
                  _buildCostRow(
                    'هزینه ضد عفونی',
                    expense['DisinfectionCost'],
                    expense['DisinfectionCostImage'],
                    context,
                  ),
                if (expense['OtherCost1'] != null && double.tryParse(expense['OtherCost1']?.toString() ?? '0') != 0)
                  _buildCostRow(
                    'هزینه های دیگر 1',
                    expense['OtherCost1'],
                    expense['OtherCostImage1'],
                    context,
                  ),
                if (expense['OtherCost2'] != null && double.tryParse(expense['OtherCost2']?.toString() ?? '0') != 0)
                  _buildCostRow(
                    'هزینه های دیگر 2',
                    expense['OtherCost2'],
                    expense['OtherCostImage2'],
                    context,
                  ),
                if (expense['OtherCost3'] != null && double.tryParse(expense['OtherCost3']?.toString() ?? '0') != 0)
                  _buildCostRow(
                    'هزینه های دیگر 3',
                    expense['OtherCost3'],
                    expense['OtherCostImage3'],
                    context,
                  ),
                if (expense['OtherCost4'] != null && double.tryParse(expense['OtherCost4']?.toString() ?? '0') != 0)
                  _buildCostRow(
                    'هزینه های دیگر 4',
                    expense['OtherCost4'],
                    expense['OtherCostImage4'],
                    context,
                  ),
                if (expense['OtherCost5'] != null && double.tryParse(expense['OtherCost5']?.toString() ?? '0') != 0)
                  _buildCostRow(
                    'هزینه های دیگر 5',
                    expense['OtherCost5'],
                    expense['OtherCostImage5'],
                    context,
                  ),
                Divider(),
                Container(
                  color: Colors.lightGreen[100], // Light green background color
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: _buildInfoRow('جمع کل هزینه', totalExpense, isPrice: true, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCostRow(String label, dynamic value, String? imagePath, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoRow(label, value, isPrice: true, fontWeight: FontWeight.w500),
        ),
        if (imagePath != null && imagePath.isNotEmpty)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('رسید $label'),
                    content: Image.network(AppLinks.imageBaseUrl + imagePath),
                    actions: [
                      TextButton(
                        child: Text('بستن'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('سند هزینه'),
          ),
      ],
    );
  }

  double calculateTotalExpense(dynamic expense) {
    double billOfLadingCost = double.tryParse(expense['BillOfLadingCost']?.toString() ?? '0') ?? 0;
    double highwayToll = double.tryParse(expense['HighwayToll']?.toString() ?? '0') ?? 0;
    double dieselCost = double.tryParse(expense['DieselCost']?.toString() ?? '0') ?? 0;
    double loadingTip = double.tryParse(expense['LoadingTip']?.toString() ?? '0') ?? 0;
    double unloadingTip = double.tryParse(expense['UnloadingTip']?.toString() ?? '0') ?? 0;
    double disinfectionCost = double.tryParse(expense['DisinfectionCost']?.toString() ?? '0') ?? 0;
    double otherCost1 = double.tryParse(expense['OtherCost1']?.toString() ?? '0') ?? 0;
    double otherCost2 = double.tryParse(expense['OtherCost2']?.toString() ?? '0') ?? 0;
    double otherCost3 = double.tryParse(expense['OtherCost3']?.toString() ?? '0') ?? 0;
    double otherCost4 = double.tryParse(expense['OtherCost4']?.toString() ?? '0') ?? 0;
    double otherCost5 = double.tryParse(expense['OtherCost5']?.toString() ?? '0') ?? 0;

    return billOfLadingCost + highwayToll + dieselCost + loadingTip + unloadingTip + disinfectionCost + otherCost1 + otherCost2 + otherCost3 + otherCost4 + otherCost5;
  }

  Widget _buildIncomeList(bool received) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
    }

    List<dynamic> filteredCargos = _cargos.where((cargo) {
      if (received) {
        return cargo['PaymentTypeName'] == 'نقد';
      } else {
        return cargo['PaymentTypeName'] != 'نقد';
      }
    }).toList();

    if (filteredCargos.isEmpty) {
      return Center(child: Text('هیچ باری یافت نشد', style: TextStyle(color: AppTheme.secondaryColor)));
    }

    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: filteredCargos.length,
      itemBuilder: (context, index) {
        final cargo = filteredCargos[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('نام وسیله نقلیه', cargo['VehicleName'], fontWeight: FontWeight.w500),
                _buildInfoRow('شماره پلاک', cargo['PlateNumber'], fontWeight: FontWeight.w500),
                _buildInfoRow('نام راننده', '${cargo['DriverFirstName']} ${cargo['DriverLastName']}', fontWeight: FontWeight.w500),
                _buildInfoRow('مبدا', cargo['Origin'], fontWeight: FontWeight.w500),
                _buildInfoRow('مقصد', cargo['Destination'], fontWeight: FontWeight.w500),
                _buildInfoRow('تاریخ حمل', cargo['ShippingDate'], fontWeight: FontWeight.w500),
                _buildInfoRow('وزن', cargo['Weight'], fontWeight: FontWeight.w500),
                _buildInfoRow('قیمت هر تن', cargo['PricePerTon'], isPrice: true, fontWeight: FontWeight.w500),
                _buildInfoRow('وضعیت پرداخت', cargo['PaymentTypeName'], fontWeight: FontWeight.w500),
                _buildInfoRow('نوع بار', cargo['CargoTypeName'], fontWeight: FontWeight.w500),
                _buildInfoRow('قیمت کل', cargo['TotalPrice'], isPrice: true, fontWeight: FontWeight.w500),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRevenueReport() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
    } else if (_cargos.isEmpty) {
      return Center(child: Text('هیچ باری یافت نشد', style: TextStyle(color: AppTheme.secondaryColor)));
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _cargos.length,
        itemBuilder: (context, index) {
          final cargo = _cargos[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('نام وسیله نقلیه', cargo['VehicleName']),
                  _buildInfoRow('شماره پلاک', cargo['PlateNumber']),
                  _buildInfoRow('نام راننده', '${cargo['DriverFirstName']} ${cargo['DriverLastName']}'),
                  _buildInfoRow('مبدا', cargo['Origin']),
                  _buildInfoRow('مقصد', cargo['Destination']),
                  _buildInfoRow('تاریخ حمل', cargo['ShippingDate']),
                  _buildInfoRow('وزن', cargo['Weight']),
                  _buildInfoRow('قیمت هر تن', cargo['PricePerTon'], isPrice: true),
                  _buildInfoRow('وضعیت پرداخت', cargo['PaymentTypeName']),
                  _buildInfoRow('نوع بار', cargo['CargoTypeName']),
                  _buildInfoRow('قیمت کل', cargo['TotalPrice'], isPrice: true),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildInfoRow(String label, dynamic value, {bool isPrice = false, FontWeight? fontWeight}) {
    String displayValue = value?.toString() ?? 'N/A';
    if (isPrice && value != null) {
      // Check if the value is already a formatted string
      if (value is String && value.contains(',')) {
        displayValue = value;
      } else {
        // Try parsing the value as a double, if it's not already a double
        double? number = value is double ? value : double.tryParse(value.toString());

        if (number != null) {
          // Format number with commas
          final numberFormat = intl.NumberFormat("#,###", "fa_IR");
          displayValue = numberFormat.format(number);
        } else {
          displayValue = 'N/A';
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.darkColor)),
          Expanded(
            child: Text(displayValue, style: TextStyle(fontSize: 14, color: AppTheme.darkColor, fontWeight: fontWeight)),
          ),
        ],
      ),
    );
  }
} 