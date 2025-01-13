import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ECO Tester'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("sensorData");
  Map<String, String> _sensorData = {"co": "", "co2": "", "hc": "", "rpm": ""};

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
            "co": data["co"] ?? "",
            "co2": data["co2"] ?? "",
            "hc": data["hc"] ?? "",
            "rpm": data["rpm"] ?? "",
          };
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sensor Data:", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text("CO: ${_sensorData['co']}"),
            const SizedBox(height: 8),
            Text("CO2: ${_sensorData['co2']}"),
            const SizedBox(height: 8),
            Text("HC: ${_sensorData['hc']}"),
            const SizedBox(height: 8),
            Text("rpm: ${_sensorData['rpm']}"),
          ],
        ),
      ),
    );
  }
}
