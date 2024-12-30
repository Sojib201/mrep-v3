import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class OpenStreetMapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  OpenStreetMapScreen({required this.latitude, required this.longitude});

  @override
  State<OpenStreetMapScreen> createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  late MapController mapController;
  // late double currentLatitude;
  // late double currentLongitude;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    // _getCurrentLocation();
  }
  // Future<void> _getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     currentLatitude = position.latitude;
  //     currentLongitude = position.longitude;
  //   });
  // }

  // Move the camera to the user's current location
  void _moveToCurrentLocation() {
    if (widget.latitude != 0.0 && widget.longitude != 0.0) {
      mapController.move(LatLng(widget.latitude, widget.longitude ), 17.0);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _moveToCurrentLocation,
        child: Icon(Icons.my_location),
      ),
      appBar: AppBar(
        title: Text('location'.tr()),
        centerTitle: true,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(widget.latitude, widget.longitude),
          zoom: 17.0,
          minZoom: 3,
          maxZoom: 18.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(widget.latitude, widget.longitude),
                width: 80.0,
                height: 80.0,
                builder: (ctx) => Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
