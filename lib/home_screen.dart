import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_measuring_app/rpm_indicator_screen.dart';
import 'package:lottie/lottie.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controller for the vehicle number input
  final TextEditingController _vehicleController = TextEditingController();
  String? _vehicleError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(38.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Text(
                  'Portable Emissions Measuring System',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Lottie animation
                Align(
                  alignment: Alignment.topCenter,
                  child: Lottie.asset(
                    'assets/car.json',
                    width: 500,
                    height: 300,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(height: 20),

                // Vehicle number text field
                TextField(
                  controller: _vehicleController,
                  decoration: InputDecoration(
                    labelText: 'Enter Vehicle Number',
                    errorText: _vehicleError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: _vehicleError == null ? Colors.grey : Colors.red,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.directions_car),
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  'Review the test results below to analyze the data and make informed decisions. The results will help you assess the performance and identify areas for improvement.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 30),

                // Button to go to the next screen
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50, // Button height
                    child: TextButton(
                      onPressed: () {
                        if (_vehicleController.text.isEmpty) {
                          setState(() {
                            _vehicleError = 'Please enter a vehicle number.';
                          });
                        } else {
                          setState(() {
                            _vehicleError = null;
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RpmIndicatorScreen(
                                vehicleNumber: _vehicleController
                                    .text, // Pass the vehicle number
                              ),
                            ),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Test Results',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
