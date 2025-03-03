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
  bool _isLoading = true;
  bool _showRevenueReport = false;

  @override
  void initState() {
    super.initState();
    _fetchCargos();
  }

  Future<void> _fetchCargos() async {
    final response = await http.get(Uri.parse(AppLinks.cargos));
    if (response.statusCode == 200) {
      setState(() {
        _cargos = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cargos')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('گزارش گیری', style: TextStyle(color: AppTheme.whiteColor)),
          backgroundColor: AppTheme.primaryColor,
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'درآمدهای وصول شده'),
              Tab(text: 'درآمدهای وصول نشده'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildIncomeList(true),  // Received Incomes
            _buildIncomeList(false), // Unreceived Incomes
          ],
        ),
      ),
    );
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
      // Format number with commas
      final numberFormat = intl.NumberFormat("#,###", "fa_IR");
      displayValue = numberFormat.format(int.parse(value.toString()));
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