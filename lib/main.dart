import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'add_cargo_screen.dart';
import 'add_customer_screen.dart';
import 'add_expense_screen.dart';
import 'add_transport_relation_screen.dart';
import 'app_theme.dart';
import 'add_driver_screen.dart';
import 'add_edit_cargo_type_screen.dart';
import 'add_edit_vehicle_screen.dart';
import 'reporting_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Khatoon Bar',
      theme: ThemeData(
        fontFamily: 'Vazir',
        primaryColor: AppTheme.primaryColor,
        hintColor: AppTheme.secondaryColor,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'), // Farsi
      ],
      locale: const Locale('fa'),
      // Set the default locale
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: DashboardScreen(),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'داشبورد مدیریت',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
          
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildDashboardCard(
                    context,
                    'افزودن راننده',
                    Icons.person_add,
                    Color(0xFF4CAF50), // Green
                    AddDriverScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    'افزودن وسیله نقلیه',
                    Icons.directions_car,
                    Color(0xFF3F51B5), // Indigo
                    AddEditVehicleScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    'افزودن نوع بار',
                    Icons.local_shipping,
                    Color(0xFF9C27B0), // Purple
                    AddEditCargoTypeScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    'افزودن مشتری',
                    Icons.group_add,
                    Color(0xFFE64A19), // Deep Orange
                    AddCustomerScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    'افزودن بار',
                    Icons.inventory,
                    Color(0xFF607D8B), // Blue Grey
                    AddCargoScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    'افزودن هزینه',
                    Icons.attach_money,
                    Color(0xFFD84315), // Orange
                    AddExpenseScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    'افزودن رابطه حمل و نقل',
                    Icons.directions_car,
                    Color(0xFF512DA8), // Deep Purple Accent
                    AddTransportRelationScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    'گزارش گیری',
                    Icons.assessment,
                    Color(0xFF1976D2), // Blue
                    ReportingScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    'گزارش گیری درامدها',
                    Icons.trending_up,
                    Color(0xFF009688), // Teal
                    ReportingScreen(), // Replace with your Income Reporting Screen
                  ),
                  _buildDashboardCard(
                    context,
                    'گزارش گیری هزینه ها',
                    Icons.trending_down,
                    Color(0xFF795548), // Brown
                    ReportingScreen(), // Replace with your Expense Reporting Screen
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return Card(
      elevation: 5, // Reduced shadow intensity
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Slightly less rounded corners
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.8), color], // Adjusted gradient opacity
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white), // Slightly smaller icon size
              SizedBox(height: 12), // Reduced spacing
              Text(
                title,
                style: TextStyle(
                  fontSize: 16, // Reduced text size by 2
                  color: Colors.white,
                  fontWeight: FontWeight.w500, // Lighter font weight
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context, String title, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(title),
    );
  }
}


// echo "# khatoonbar_client" >> README.md
// git init
// git add README.md
// git commit -m "first commit"
// git branch -M main
// git remote add origin https://github.com/asgharkarimi/khatoonbar_client.git
// git push -u origin main

