import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapLocateDelivery extends StatefulWidget {
  final String startPoint;
  final String endPoint;
  const MapLocateDelivery({
    super.key,
    required this.startPoint,
    required this.endPoint,
  });

  @override
  State<MapLocateDelivery> createState() => MapLocateDeliveryState();
}

class MapLocateDeliveryState extends State<MapLocateDelivery> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  final LatLng _startLatLng = const LatLng(
    37.42796133580664,
    -122.085749655962,
  );
  final LatLng _endLatLng = const LatLng(
    37.43296265331129,
    -122.08832357078792,
  );

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = Set<Polyline>(); // Constructor form

  @override
  void initState() {
    super.initState();
    _setMapElements();
    _getRoute();
  }

  void _setMapElements() {
    _markers = {
      Marker(
        markerId: const MarkerId('start'),
        position: _startLatLng,
        infoWindow: InfoWindow(title: widget.startPoint),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
      Marker(
        markerId: const MarkerId('end'),
        position: _endLatLng,
        infoWindow: InfoWindow(title: widget.endPoint),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }

  Future<void> _getRoute() async {
    const apiKey = 'AIzaSyBPeRH6NQArkUATfGeUVJPaxDldLY3Mb9s';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_startLatLng.latitude},${_startLatLng.longitude}&destination=${_endLatLng.latitude},${_endLatLng.longitude}&mode=driving&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['routes'].isNotEmpty) {
        final points = data['routes'][0]['overview_polyline']['points'];
        final decodedPoints = _decodePolyline(points);

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: decodedPoints,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      }
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: _markers,
        polylines: _polylines,
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        _startLatLng.latitude < _endLatLng.latitude
            ? _startLatLng.latitude
            : _endLatLng.latitude,
        _startLatLng.longitude < _endLatLng.longitude
            ? _startLatLng.longitude
            : _endLatLng.longitude,
      ),
      northeast: LatLng(
        _startLatLng.latitude > _endLatLng.latitude
            ? _startLatLng.latitude
            : _endLatLng.latitude,
        _startLatLng.longitude > _endLatLng.longitude
            ? _startLatLng.longitude
            : _endLatLng.longitude,
      ),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }
}
