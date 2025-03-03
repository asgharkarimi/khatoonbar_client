import 'package:flutter/material.dart';

import 'payment_type_dropdown.dart';

class PaymentTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('انتخاب نوع پرداخت',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'نوع پرداخت را انتخاب کنید:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              PaymentTypeDropdown(
                onChanged: (value) {
                  if (value != null) {
                    print('نوع پرداخت انتخاب شده: $value');
                  }
                },
                initialValue: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}