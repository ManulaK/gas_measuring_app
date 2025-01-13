import 'package:flutter/material.dart';
import 'package:gas_measuring_app/home_screen.dart';
import 'package:lottie/lottie.dart';

class ResultPage extends StatelessWidget {
  final String? vehicleNumber;
  final double rpm;
  final double co;
  final double co2;
  final double hc;
  final bool isTestPass;

  const ResultPage({
    super.key,
    this.vehicleNumber,
    required this.rpm,
    required this.co,
    required this.co2,
    required this.hc,
    required this.isTestPass,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(38.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              isTestPass ? "Passed !" : "Failed !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Lottie.asset(isTestPass ? 'assets/pass.json' : 'assets/fail.json',
                width: 200, height: 200, repeat: false),
            Text(
              isTestPass
                  ? "Great news! Your vehicle has passed the gas emission test. This means the emissions from your vehicle meet the required environmental standards, ensuring it is eco-friendly and safe for the environment. Keep up with regular maintenance to maintain these levels."
                  : "Unfortunately, your vehicle did not pass the gas emission test. This indicates that one or more emission levels (e.g., CO, CO2, HC) exceeded the acceptable limits. Please have your vehicle inspected and serviced to address potential issues with the engine, exhaust system, or fuel efficiency. Regular checks can help improve performance and ensure compliance with environmental standards.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildDetailedCard(
                    "CO",
                    co.toStringAsFixed(2),
                    "Carbon monoxide levels in the air.",
                    Colors.blue,
                    Icons.air,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailedCard(
                    "CO2",
                    co2.toStringAsFixed(2),
                    "Carbon dioxide levels in the air.",
                    Colors.teal,
                    Icons.cloud,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailedCard(
                    "HC",
                    hc.toStringAsFixed(2),
                    "Hydrocarbon levels in the air.",
                    Colors.purple,
                    Icons.water_drop_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedCard(
      String title, String value, String details, Color color, IconData icon) {
    String formattedValue = double.tryParse(value)?.toStringAsFixed(2) ?? value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 36, color: color),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              Text(
                formattedValue,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            details,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
