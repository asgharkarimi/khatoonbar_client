import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices {
  static const String _baseUrl = 'http://192.168.192.166/khatoonbar/api';

  // Method to add a new driver
  static Future<Map<String, dynamic>> addDriver({
    required String firstName,
    required String lastName,
    required String nationalCode,
    required String phoneNumber,
    required String password,
    String? nationalCardImage,
    String? licenseImage,
  }) async {
    final url = Uri.parse('$_baseUrl/drivers.php');

    final Map<String, dynamic> driverData = {
      'FirstName': firstName,
      'LastName': lastName,
      'NationalCode': nationalCode,
      'PhoneNumber': phoneNumber,
      'Password': password,
      'NationalCardImage': nationalCardImage,
      'LicenseImage': licenseImage,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(driverData),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'راننده با موفقیت افزوده شد',
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'خطا در افزودن راننده. کد وضعیت: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'خطا رخ داد: $e',
      };
    }
  }

  // Add this method to the ApiServices class
  static Future<Map<String, dynamic>> addVehicle({
    required String plateNumber,
    required String vehicleType,
    required String model,
    required String color,
    required String driverNationalCode,
    String? vehicleImage,
  }) async {
    final url = Uri.parse('$_baseUrl/vehicles.php');

    final Map<String, dynamic> vehicleData = {
      'PlateNumber': plateNumber,
      'VehicleType': vehicleType,
      'Model': model,
      'Color': color,
      'DriverNationalCode': driverNationalCode,
      'VehicleImage': vehicleImage,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(vehicleData),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'وسیله نقلیه با موفقیت افزوده شد',
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'خطا در افزودن وسیله نقلیه. کد وضعیت: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'خطا رخ داد: $e',
      };
    }
  }

  // Add this method to the ApiServices class
  static Future<List<Map<String, dynamic>>> getPaymentTypes() async {
    final url = Uri.parse('$_baseUrl/payment_types.php');

    try {
      final response = await http.get(url);
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('خطا در دریافت انواع پرداخت. کد وضعیت: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطا در ارتباط با سرور: $e');
    }
  }

} 