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

  CameraPosition? _kGooglePlex;

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  LatLng? _startLatLng;
  LatLng? _endLatLng;

  Future<LatLng?> _getLatLngFromAddress(String address) async {
    const apiKey = 'AIzaSyBPeRH6NQArkUATfGeUVJPaxDldLY3Mb9s';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
    }
    return null;
  }

  late Future<void> _loadDataFuture;

  Future<void> _initMapData() async {
    _startLatLng = await _getLatLngFromAddress(widget.startPoint);
    _endLatLng = await _getLatLngFromAddress(widget.endPoint);

    if (_startLatLng != null && _endLatLng != null) {
      setState(() {
        _kGooglePlex = CameraPosition(target: _startLatLng!, zoom: 14.4746);
        _setMapElements();
      });
      await _getRoute();
    }
  }

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = Set<Polyline>(); // Constructor form

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _initMapData();
  }

  void _setMapElements() {
    _markers = {
      Marker(
        markerId: const MarkerId('start'),
        position: _startLatLng!,
        infoWindow: InfoWindow(title: widget.startPoint),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
      Marker(
        markerId: const MarkerId('end'),
        position: _endLatLng!,
        infoWindow: InfoWindow(title: widget.endPoint),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }

  Future<void> _getRoute() async {
    const apiKey = 'AIzaSyBPeRH6NQArkUATfGeUVJPaxDldLY3Mb9s';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_startLatLng!.latitude},${_startLatLng!.longitude}&destination=${_endLatLng!.latitude},${_endLatLng!.longitude}&mode=driving&key=$apiKey';

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
              color: Colors.blueAccent,
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
      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (context, asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              if (_kGooglePlex == null) {
                return const Center(
                  child: Text('Không thể tải bản đồ - Tọa độ không hợp lệ'),
                );
              }
              if (asyncSnapshot.hasError) {
                return Text('Error: ${asyncSnapshot.error}');
              } else {
                return GoogleMap(
                  markers: _markers,
                  polylines: _polylines,
                  mapType: MapType.hybrid,
                  initialCameraPosition: _kGooglePlex!,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                );
              }
          }
        },
      ),
    );
  }
}
