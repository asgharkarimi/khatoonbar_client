import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Import the image picker package
import 'app_links.dart';
import 'app_theme.dart';
import 'dart:ui' as ui;
import 'text_input_style.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _billOfLadingCostController = TextEditingController();
  File? _billOfLadingImage;
  final _highwayTollController = TextEditingController();
  File? _highwayTollImage;
  final _dieselCostController = TextEditingController();
  File? _dieselCostImage;
  final _loadingTipController = TextEditingController();
  File? _loadingTipImage;
  final _unloadingTipController = TextEditingController();
  File? _unloadingTipImage;
  final _disinfectionCostController = TextEditingController();
  File? _disinfectionCostImage;
  final _otherCost1Controller = TextEditingController();
  File? _otherCostImage1;
  final _otherCost2Controller = TextEditingController();
  File? _otherCostImage2;
  final _otherCost3Controller = TextEditingController();
  File? _otherCostImage3;
  final _otherCost4Controller = TextEditingController();
  File? _otherCostImage4;
  final _otherCost5Controller = TextEditingController();
  File? _otherCostImage5;

  List<Map<String, dynamic>> _cargos = [];
  String? _selectedCargoId;
  bool _isLoading = true;
  bool _showOtherCosts = false;

  @override
  void initState() {
    super.initState();
    _fetchCargos();
  }

  Future<void> _fetchCargos() async {
    final response = await http.get(Uri.parse(AppLinks.cargos));
    print(response.body);
    if (!mounted) return;
    if (response.statusCode == 200) {
      setState(() {
        _cargos = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در بارگذاری لیست بارها')),
      );
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _pickImage(String type) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        setState(() {
          if (type == 'billOfLading') {
            _billOfLadingImage = imageFile;
          } else if (type == 'highwayToll') {
            _highwayTollImage = imageFile;
          } else if (type == 'dieselCost') {
            _dieselCostImage = imageFile;
          } else if (type == 'loadingTip') {
            _loadingTipImage = imageFile;
          } else if (type == 'unloadingTip') {
            _unloadingTipImage = imageFile;
          } else if (type == 'disinfectionCost') {
            _disinfectionCostImage = imageFile;
          } else if (type == 'otherCost1') {
            _otherCostImage1 = imageFile;
          } else if (type == 'otherCost2') {
            _otherCostImage2 = imageFile;
          } else if (type == 'otherCost3') {
            _otherCostImage3 = imageFile;
          } else if (type == 'otherCost4') {
            _otherCostImage4 = imageFile;
          } else if (type == 'otherCost5') {
            _otherCostImage5 = imageFile;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ثبت هزینه', style: TextStyle(color: AppTheme.whiteColor)),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
      ),
      backgroundColor: AppTheme.lightColor,
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor))
            : Padding(
                padding:
                    EdgeInsets.fromLTRB(16, 16, 16, 80), // Added bottom padding
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildCargoDropdown(),
                        SizedBox(height: 20),
                        _buildCostField(
                          controller: _billOfLadingCostController,
                          label: 'هزینه بارنامه',
                          icon: Icons.receipt,
                          onImagePressed: () => _pickImage('billOfLading'),
                          image: _billOfLadingImage,
                        ),
                        SizedBox(height: 20),
                        _buildCostField(
                          controller: _highwayTollController,
                          label: 'عوارض جاده ای',
                          icon: Icons.local_shipping,
                          onImagePressed: () => _pickImage('highwayToll'),
                          image: _highwayTollImage,
                        ),
                        SizedBox(height: 20),
                        _buildCostField(
                          controller: _dieselCostController,
                          label: 'هزینه گازوئیل',
                          icon: Icons.local_gas_station,
                          onImagePressed: () => _pickImage('dieselCost'),
                          image: _dieselCostImage,
                        ),
                        SizedBox(height: 20),
                        _buildCostField(
                          controller: _loadingTipController,
                          label: 'انعام بارگیری',
                          icon: Icons.file_upload,
                          onImagePressed: () => _pickImage('loadingTip'),
                          image: _loadingTipImage,
                        ),
                        SizedBox(height: 20),
                        _buildCostField(
                          controller: _unloadingTipController,
                          label: 'انعام تخلیه',
                          icon: Icons.file_download,
                          onImagePressed: () => _pickImage('unloadingTip'),
                          image: _unloadingTipImage,
                        ),
                        SizedBox(height: 20),
                        _buildCostField(
                          controller: _disinfectionCostController,
                          label: 'هزینه ضد عفونی',
                          icon: Icons.local_hospital,
                          onImagePressed: () => _pickImage('disinfectionCost'),
                          image: _disinfectionCostImage,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showOtherCosts = !_showOtherCosts;
                            });
                          },
                          child: Text(_showOtherCosts
                              ? 'بستن سایر هزینه ها'
                              : 'نمایش سایر هزینه ها'),
                        ),
                        if (_showOtherCosts) ...[
                          SizedBox(height: 20),
                          _buildCostField(
                            controller: _otherCost1Controller,
                            label: 'سایر هزینه 1',
                            icon: Icons.monetization_on,
                            onImagePressed: () => _pickImage('otherCost1'),
                            image: _otherCostImage1,
                          ),
                          SizedBox(height: 20),
                          _buildCostField(
                            controller: _otherCost2Controller,
                            label: 'سایر هزینه 2',
                            icon: Icons.monetization_on,
                            onImagePressed: () => _pickImage('otherCost2'),
                            image: _otherCostImage2,
                          ),
                          SizedBox(height: 20),
                          _buildCostField(
                            controller: _otherCost3Controller,
                            label: 'سایر هزینه 3',
                            icon: Icons.monetization_on,
                            onImagePressed: () => _pickImage('otherCost3'),
                            image: _otherCostImage3,
                          ),
                          SizedBox(height: 20),
                          _buildCostField(
                            controller: _otherCost4Controller,
                            label: 'سایر هزینه 4',
                            icon: Icons.monetization_on,
                            onImagePressed: () => _pickImage('otherCost4'),
                            image: _otherCostImage4,
                          ),
                          SizedBox(height: 20),
                          _buildCostField(
                            controller: _otherCost5Controller,
                            label: 'سایر هزینه 5',
                            icon: Icons.monetization_on,
                            onImagePressed: () => _pickImage('otherCost5'),
                            image: _otherCostImage5,
                          ),
                        ],
                        SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            textStyle: TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _submitForm,
                          child: Text('ثبت هزینه'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildCargoDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<String>(
          decoration: TextInputStyle.getDropdownDecoration(
            labelText: 'شناسه بار',
            prefixIcon: Icons.local_shipping,
          ),
          value: _selectedCargoId,
          items: _cargos.map((cargo) {
            return DropdownMenuItem<String>(
              value: cargo['CargoID'].toString(),
              child: Text('${cargo['Origin']} -> ${cargo['Destination']}'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCargoId = value;
            });
          },
          validator: (value) {
            return null;
          },
          hint: Text('انتخاب بار'),
        ),
      ),
    );
  }

  Widget _buildCostField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required VoidCallback onImagePressed,
    File? image,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(fontFamily: null),
            decoration: TextInputStyle.getInputDecoration(
              labelText: 'مقدار را وارد کنید',
              prefixIcon: icon,
            ),
            validator: (value) {
              return null;
            },
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: onImagePressed,
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                border:
                    Border.all(color: AppTheme.secondaryColor.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.lightColor,
              ),
              child: image != null
                  ? Image.file(image!, fit: BoxFit.cover)
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt,
                              size: 32, color: AppTheme.secondaryColor),
                          Text("انتخاب تصویر",
                              style: TextStyle(color: AppTheme.secondaryColor)),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  double parse(String text) {
    return double.tryParse(text) ?? 0.0;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var request = http.MultipartRequest('POST', Uri.parse(AppLinks.expenses));
      request.fields['CargoID'] =
          _selectedCargoId ?? ''; // Use empty string if null
      request.fields['BillOfLadingCost'] = _billOfLadingCostController.text;
      request.fields['HighwayToll'] = _highwayTollController.text;
      request.fields['DieselCost'] = _dieselCostController.text;
      request.fields['LoadingTip'] = _loadingTipController.text;
      request.fields['UnloadingTip'] = _unloadingTipController.text;
      request.fields['DisinfectionCost'] = _disinfectionCostController.text;
      request.fields['OtherCost1'] = _otherCost1Controller.text;
      request.fields['OtherCost2'] = _otherCost2Controller.text;
      request.fields['OtherCost3'] = _otherCost3Controller.text;
      request.fields['OtherCost4'] = _otherCost4Controller.text;
      request.fields['OtherCost5'] = _otherCost5Controller.text;

      if (_billOfLadingImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'BillOfLadingImage',
          _billOfLadingImage!.path,
        ));
      }
      if (_highwayTollImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'HighwayTollImage',
          _highwayTollImage!.path,
        ));
      }
      if (_dieselCostImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'DieselCostImage',
          _dieselCostImage!.path,
        ));
      }
      if (_loadingTipImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'LoadingTipImage',
          _loadingTipImage!.path,
        ));
      }
      if (_unloadingTipImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'UnloadingTipImage',
          _unloadingTipImage!.path,
        ));
      }
      if (_disinfectionCostImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'DisinfectionCostImage',
          _disinfectionCostImage!.path,
        ));
      }
      if (_otherCostImage1 != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'OtherCostImage1',
          _otherCostImage1!.path,
        ));
      }
      if (_otherCostImage2 != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'OtherCostImage2',
          _otherCostImage2!.path,
        ));
      }
      if (_otherCostImage3 != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'OtherCostImage3',
          _otherCostImage3!.path,
        ));
      }
      if (_otherCostImage4 != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'OtherCostImage4',
          _otherCostImage4!.path,
        ));
      }
      if (_otherCostImage5 != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'OtherCostImage5',
          _otherCostImage5!.path,
        ));
      }

      try {
        var response = await request.send();
        final respStr = await response.stream.bytesToString();
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${respStr}");

        if (!mounted) return;
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('هزینه با موفقیت ثبت شد'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطا در ثبت هزینه'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _billOfLadingCostController.dispose();
    _highwayTollController.dispose();
    _dieselCostController.dispose();
    _loadingTipController.dispose();
    _unloadingTipController.dispose();
    _disinfectionCostController.dispose();
    _otherCost1Controller.dispose();
    _otherCost2Controller.dispose();
    _otherCost3Controller.dispose();
    _otherCost4Controller.dispose();
    _otherCost5Controller.dispose();
    super.dispose();
  }
}
