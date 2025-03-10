import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../components/get_current_location.dart';
import 'popup.dart';
import 'report_popup.dart';
import 'report_marker.dart';

class BaseMap extends StatefulWidget {
  final List<ReportMarker> reportMarkers;
  final bool adminStatus;
  const BaseMap({super.key, required this.reportMarkers, required this.adminStatus});

  @override
  State<BaseMap> createState() => _BaseMapState();
}

class _BaseMapState extends State<BaseMap> {
  final mapController = MapController();
  final PopupController _popupLayerController = PopupController();
  Position? currentLocation;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() async {
    currentLocation = await getCurrentLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        onPositionChanged: (mapPosition, someBool) {
          imageCache.clear();
          _popupLayerController.hideAllPopups();
        },
        crs: const Epsg3857(),                 //coordinate reference system
        center: LatLng(44.1, -124.75),
        //boundsOptions: const FitBoundsOptions(padding: EdgeInsets.all(8.0)),
        zoom: 10.0,
        minZoom: 7.0,
        maxZoom: 12.0,

        maxBounds: LatLngBounds(LatLng(41.9, -127.0), LatLng(46.3, -123.50)), //LatLng(46.3, -123.50), LatLng(44, -124)
        nePanBoundary: LatLng(46.3, -123.50),
        swPanBoundary: LatLng(41.9, -127.0),
        interactiveFlags: InteractiveFlag.doubleTapZoom |
            InteractiveFlag.drag |
            InteractiveFlag.pinchMove |
            InteractiveFlag.pinchZoom |
            InteractiveFlag.flingAnimation,
        onTap: (_, __) => _popupLayerController.hideAllPopups(),
      ),
      nonRotatedChildren: const [
        SimpleAttributionWidget(
          source: Text('mapzen, NOAA, OpenStreetMap'),
          alignment: Alignment.topRight,
        ),
      ],
      children: [
        TileLayer(
          tileProvider: AssetTileProvider(),
          urlTemplate: 'assets/map/{z}/{x}/{y}.png',
          tms: false,
        ),
        PopupMarkerLayerWidget(
          options: PopupMarkerLayerOptions(
              markers: widget.reportMarkers,
              popupController: _popupLayerController,
              popupBuilder: (BuildContext context, Marker marker) {
                if (marker is ReportMarker) {
                  return ReportPopUp(
                      marker, marker.userReport, widget.adminStatus);
                  // all markers should be ReportMarkers, so the else condition should never occur, but was required
                } else {
                  return PopUp(marker);
                }
              }),
        ),
        addCurrentLocationMarker(currentLocation),
      ],
    );
  }
}
