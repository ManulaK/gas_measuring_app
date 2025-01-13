import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gas_measuring_app/home_screen.dart';
import 'package:gas_measuring_app/result_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RpmIndicatorScreen extends StatefulWidget {
  final String? vehicleNumber;

  const RpmIndicatorScreen({super.key, required this.vehicleNumber});

  @override
  State<RpmIndicatorScreen> createState() => _RpmIndicatorPageState();
}

class _RpmIndicatorPageState extends State<RpmIndicatorScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  Map<String, String> _sensorData = {
    "co": "0",
    "co2": "0",
    "hc": "0",
    "rpm": "0"
  };

  @override
  void initState() {
    super.initState();
    _fetchMeasuringConstants();
    _fetchSensorData();
  }

  // Fetch the measuring constants from Firebase
  void _fetchMeasuringConstants() {
    _dbRef.child("measuringConstants").get().then((DataSnapshot snapshot) {
      final data = snapshot.value as Map?;
      if (data != null) {
        setState(() {});
      }
    });
  }

  // Fetch sensor data and check the threshold
  void _fetchSensorData() {
    _dbRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final measuringConstants = data["measuringConstants"] as Map?;
        final sensorData = data["sensorData"] as Map?;

        if (measuringConstants != null && sensorData != null) {
          setState(() {
            _sensorData = {
              "co": sensorData["co"]?.toString() ?? "0",
              "co2": sensorData["co2"]?.toString() ?? "0",
              "hc": sensorData["hc"]?.toString() ?? "0",
              "rpm": sensorData["rpm"]?.toString() ?? "0",
            };
          });

          // Parse measuring constants
          double rpmThreshold =
              double.tryParse(measuringConstants["rpm"].toString()) ?? 2500;
          double coThreshold =
              double.tryParse(measuringConstants["co"].toString()) ?? 4.5;
          double co2Threshold =
              double.tryParse(measuringConstants["co2"].toString()) ?? 4.5;
          double hcThreshold =
              double.tryParse(measuringConstants["hc"].toString()) ?? 1200;

          // Parse sensor data
          double currentRpm = double.tryParse(_sensorData['rpm'] ?? "0") ?? 0;
          double co = double.tryParse(_sensorData['co'] ?? "0") ?? 0;
          double co2 = double.tryParse(_sensorData['co2'] ?? "0") ?? 0;
          double hc = double.tryParse(_sensorData['hc'] ?? "0") ?? 0;

          // Check if the test is pass or fail
          bool isTestPass =
              co < coThreshold && co2 < co2Threshold && hc < hcThreshold;

          // Navigate to the ResultPage if RPM threshold is exceeded
          if (currentRpm >= rpmThreshold) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultPage(
                  vehicleNumber: widget.vehicleNumber,
                  rpm: currentRpm,
                  co: co,
                  co2: co2,
                  hc: hc,
                  isTestPass: isTestPass,
                ),
              ),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                )),
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
