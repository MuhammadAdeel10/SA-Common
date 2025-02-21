import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkers {
  final String markerId;
  final LatLng location;

  MapMarkers({required this.markerId, required this.location});
}

class SAMapWidget extends StatelessWidget {
  SAMapWidget({
    super.key,
    required this.onMapCreated,
    required this.mapController,
    this.mapType = MapType.normal,
    required this.target,
    this.onCameraMove,
    this.onCameraIdle,
    this.height = 0.20,
    this.isStaticMarker = false,
    this.zoomGesturesEnabled = true,
    this.markers = const [],
    this.zoomControlsEnabled = false,
    this.myLocationEnabled = false,
    this.zoom = 11.0,
    this.nonStaticMarker = const Icon(
      Icons.location_on_sharp,
      size: 40,
      color: Colors.red,
    ),
  });

  final void Function(CameraPosition)? onCameraMove;
  final void Function()? onCameraIdle;
  final void Function(GoogleMapController controller) onMapCreated;
  final Completer<GoogleMapController> mapController;
  final num height;
  final bool isStaticMarker;
  final bool zoomGesturesEnabled;
  final List<MapMarkers> markers;
  final bool zoomControlsEnabled;
  final bool myLocationEnabled;
  final double zoom;
  final LatLng target;
  final Icon nonStaticMarker;
  final MapType mapType;

//   late final GoogleMapController mapController;
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: mapType,
            zoomGesturesEnabled: zoomGesturesEnabled,
            zoomControlsEnabled: zoomControlsEnabled,
            myLocationEnabled: myLocationEnabled,
            onMapCreated: onMapCreated,
            gestureRecognizers: {Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())},
            onCameraIdle: onCameraIdle,
            onCameraMove: onCameraMove,
            initialCameraPosition: CameraPosition(
              target: target,
              zoom: zoom,
            ),
            markers: isStaticMarker
                ? markers.map(
                    (e) {
                      return Marker(markerId: MarkerId(e.markerId), position: e.location);
                    },
                  ).toSet()
                : {},
          ),
          if (!isStaticMarker) nonStaticMarker,
        ],
      ),
    );
  }
}
