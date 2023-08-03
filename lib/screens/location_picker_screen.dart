import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ocean_change/models/user_report.dart';

class LocationPickerScreen extends StatefulWidget {
  static const String routeName = 'LocationPickerScreen';

  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  CustomPoint<double>? _position = const CustomPoint(10, 10);

  late final MapController _mapController;
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    final UserReport userReport =
        ModalRoute.of(context)?.settings.arguments as UserReport;

    updatePositionTarget() {
      setState(() {
        _position = _mapController.latLngToScreenPoint(LatLng(
            userReport.geopoint!.latitude, userReport.geopoint!.longitude));
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Where was this observed?')),
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            onPositionChanged: (mapPosition, someBool) {
              final updatedLatLng = LatLng(userReport.geopoint!.latitude,
                  userReport.geopoint!.longitude);

              _position = _mapController.latLngToScreenPoint(updatedLatLng);

              setState(() {});
              imageCache.clear();
              // imageCache.clearLiveImages();
            },
            onMapReady: () {
              if (userReport.geopoint != null) {
                _position = _mapController.latLngToScreenPoint(LatLng(
                    userReport.geopoint!.latitude,
                    userReport.geopoint!.longitude));
              } else {
                final centerLatLng = _mapController.center;
                _position = _mapController.latLngToScreenPoint(centerLatLng);
                userReport.geopoint =
                    GeoPoint(centerLatLng.latitude, centerLatLng.longitude);
              }
              _latController.text = '${userReport.geopoint!.latitude}';
              _longController.text = '${userReport.geopoint!.longitude}';

              setState(() {});
            },
            center: LatLng(45.3, -125),
            zoom: 6,
            maxZoom: 11,
            minZoom: 5,
            maxBounds:
                LatLngBounds(LatLng(35.65, -140.10), LatLng(50.80, -120.50)),
            onTap: (tapPos, latLng) {
              debugPrint('x: ${_position?.x} y: ${_position?.y}');

              _position = _mapController.latLngToScreenPoint(latLng);

              userReport.geopoint = GeoPoint(latLng.latitude, latLng.longitude);
              _latController.text = '${userReport.geopoint!.latitude}';
              _longController.text = '${userReport.geopoint!.longitude}';

              debugPrint(
                  'x: ${userReport.geopoint!.latitude}, y: ${userReport.geopoint!.longitude}');

              setState(() {
                _position = _mapController.latLngToScreenPoint(latLng);
              });
            },
          ),
          children: [
            TileLayer(
              tileProvider: AssetTileProvider(),
              urlTemplate: 'assets/map/{z}/{x}/{y}.png',
              tms: false,
            )
          ],
        ),
        Positioned(
            left: _position!.x - 10,
            top: _position!.y - 10,
            height: 20,
            width: 20,
            child: const Icon(Icons.location_searching)),
        Positioned(
          top: MediaQuery.of(context).size.height * 1 / 24,
          left: MediaQuery.of(context).size.width * 1 / 8,
          width: MediaQuery.of(context).size.width * 3 / 4,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _latController,
                          decoration: const InputDecoration(
                              labelText: 'Latitude:',
                              border: OutlineInputBorder()),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*'))
                          ],
                          onChanged: (newValue) {
                            if (newValue.isEmpty ||
                                !(num.parse(newValue) >= -90 &&
                                    num.parse(newValue) <= 90)) {
                              _latController.text =
                                  userReport.geopoint!.latitude.toString();
                              return;
                            }

                            userReport.geopoint = GeoPoint(
                                double.parse(_latController.text),
                                userReport.geopoint!.longitude);

                            updatePositionTarget();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _longController,
                          decoration: const InputDecoration(
                              labelText: 'Longitude:',
                              border: OutlineInputBorder()),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[-]\d+\.?\d*'))
                          ],
                          onChanged: (newValue) {
                            if (newValue.isEmpty ||
                                !(num.parse(newValue) >= -180 &&
                                    num.parse(newValue) <= 180)) {
                              _longController.text =
                                  userReport.geopoint!.longitude.toString();
                              return;
                            }

                            userReport.geopoint = GeoPoint(
                                userReport.geopoint!.latitude,
                                double.parse(_longController.text));

                            updatePositionTarget();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        )
      ]),
    );
  }
}
