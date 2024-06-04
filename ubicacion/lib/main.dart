import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubicacion/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageLocation(),
    );
  }
}

class PageLocation extends StatefulWidget {
  const PageLocation({super.key});

  @override
  State<PageLocation> createState() => _PageLocationState();
}

class _PageLocationState extends State<PageLocation> {
  final LocationService _locationService = LocationService();
  List<Map<String, double>> positions = [];

  void captarPosicion() async {
    Position position = await _locationService.requestPermissionAndGetLocation();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedPositions = prefs.getStringList('positions');

    if (savedPositions != null) {
      positions.clear();
      positions.addAll(savedPositions.map((pos) {
        List<String> parts = pos.split(',');
        return {
          'latitude': double.parse(parts[0]),
          'longitude': double.parse(parts[1]),
        };
      }).toList());
    }

    positions.add({
      'latitude': position.latitude,
      'longitude': position.longitude,
    });

    await prefs.setStringList(
      'positions',
      positions.map((pos) => '${pos['latitude']},${pos['longitude']}').toList(),
    );

    setState(() {
      // Actualiza la pantalla
    });

    print(position.latitude);
    print(position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking App"),
        centerTitle: true,
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                captarPosicion();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              ),
              child: const Text("Location Now"),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: positions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Lat: ${positions[index]['latitude']}, Long: ${positions[index]['longitude']}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 240, 228, 171),
    );
  }
}
