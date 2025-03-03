import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentTypeDropdown extends StatefulWidget {
  final ValueChanged<String?> onChanged;
  final String? initialValue;

  const PaymentTypeDropdown({
    required this.onChanged,
    this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  _PaymentTypeDropdownState createState() => _PaymentTypeDropdownState();
}

class _PaymentTypeDropdownState extends State<PaymentTypeDropdown> {
  List<Map<String, dynamic>> _paymentTypes = [];
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _fetchPaymentTypes();
  }

  Future<void> _fetchPaymentTypes() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.192.166/khatoonbar/api/payment_types.php'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Sort the data by PaymentTypeName
        data.sort((a, b) => (a['PaymentTypeName'] as String)
            .compareTo(b['PaymentTypeName'] as String));

        setState(() {
          _paymentTypes = data.cast<Map<String, dynamic>>();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطا در دریافت انواع پرداخت. کد وضعیت: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطا در ارتباط با سرور: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonFormField<String>(
        value: _selectedValue != null && _paymentTypes.any((type) => type['PaymentTypeID'].toString() == _selectedValue)
            ? _selectedValue
            : null,
        decoration: InputDecoration(
          labelText: 'نوع پرداخت',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          alignLabelWithHint: true,
        ),
        isExpanded: true,
        itemHeight: 60,
        items: _paymentTypes.map((paymentType) {
          return DropdownMenuItem<String>(
            value: paymentType['PaymentTypeID'].toString(),
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: Text(
                paymentType['PaymentTypeName'],
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            _selectedValue = value;
          });
          widget.onChanged(value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'لطفا نوع پرداخت را انتخاب کنید';
          }
          return null;
        },
      ),
    );
  }
}