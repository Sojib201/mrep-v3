import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowLocation extends StatefulWidget {
  final latitude;
  final longitude;
  const ShowLocation({super.key, this.latitude, this.longitude});

  @override
  // ignore: library_private_types_in_public_api
  _ShowLocationState createState() => _ShowLocationState();
}

class _ShowLocationState extends State<ShowLocation> {


  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
  }

  // Future<void> _getCurrentLocation() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }
  //
  //   if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
  //     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //     setState(() {
  //       latitude = position.latitude;
  //       longitude = position.longitude;
  //     });
  //   }
  // }

  void _openGoogleMaps() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nearby Mosques'),
        ),
        body: Center(
            child: widget.latitude != null && widget.longitude != null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your Location:',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Latitude: ${widget.latitude}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Longitude: ${widget.longitude}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _openGoogleMaps,
                  child: const Text('Find Nearby Mosques'),
                ),
              ],
            )
                : const CircularProgressIndicator(),
        ),
        );
    }
}