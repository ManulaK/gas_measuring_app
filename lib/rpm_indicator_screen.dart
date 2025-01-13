import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RpmIndicatorScreen extends StatefulWidget {
  final String? vehicleNumber;

  const RpmIndicatorScreen({super.key, required this.vehicleNumber});

  @override
  State<RpmIndicatorScreen> createState() => _RpmIndicatorPageState();
}

class _RpmIndicatorPageState extends State<RpmIndicatorScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("sensorData");
  Map<String, String> _sensorData = {
    "co": "0",
    "co2": "0",
    "hc": "0",
    "rpm": "0"
  };

  @override
  void initState() {
    super.initState();
    _fetchSensorData();
  }

  void _fetchSensorData() {
    _dbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          _sensorData = {
            "co": data["co"]?.toString() ?? "0",
            "co2": data["co2"]?.toString() ?? "0",
            "hc": data["hc"]?.toString() ?? "0",
            "rpm": data["rpm"]?.toString() ?? "0",
          };
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous page
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(38.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${widget.vehicleNumber} Gas Metrics",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            SfRadialGauge(
              enableLoadingAnimation: true,
              axes: [
                RadialAxis(
                  minimum: 0,
                  maximum: 8000,
                  ranges: [
                    GaugeRange(
                        startValue: 0, endValue: 4000, color: Colors.green),
                    GaugeRange(
                        startValue: 4000, endValue: 6000, color: Colors.orange),
                    GaugeRange(
                        startValue: 6000, endValue: 8000, color: Colors.red),
                  ],
                  pointers: [
                    NeedlePointer(
                        value: double.tryParse(_sensorData['rpm']!) ?? 0),
                  ],
                  annotations: [
                    GaugeAnnotation(
                      widget: Text(
                        "${_sensorData['rpm']} RPM",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      angle: 90,
                      positionFactor: 0.5,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildDetailedCard(
                    "CO",
                    _sensorData['co'] ?? "N/A",
                    "Carbon monoxide levels in the air.",
                    Colors.blue,
                    Icons.air,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailedCard(
                    "CO2",
                    _sensorData['co2'] ?? "N/A",
                    "Carbon dioxide levels in the air.",
                    Colors.teal,
                    Icons.cloud,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailedCard(
                    "HC",
                    _sensorData['hc'] ?? "N/A",
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
    // Format the value to 3 decimal places
    String formattedValue = double.tryParse(value)?.toStringAsFixed(3) ?? value;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
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
                formattedValue, // Use the formatted value here
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
