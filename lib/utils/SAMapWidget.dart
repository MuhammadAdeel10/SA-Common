import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SAMapWidget extends StatelessWidget {
  SAMapWidget({
    super.key,
    this.onCameraMove,
    this.onCameraIdle,
    required this.cameraPosition,
    this.height = 0.20,
    this.isStaticMarker = false,
  });

  final void Function(CameraPosition)? onCameraMove;
  final void Function()? onCameraIdle;
  final CameraPosition cameraPosition;
  final num height;
  final bool isStaticMarker;

  late final GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            gestureRecognizers: {Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())},
            initialCameraPosition: cameraPosition,
            onCameraIdle: onCameraIdle,
            onCameraMove: onCameraMove,
            markers: isStaticMarker
                ? {
                    Marker(
                      markerId: const MarkerId(""),
                      position: cameraPosition.target,
                    ),
                  }
                : {},
          ),
          if (!isStaticMarker)
            const Icon(
              Icons.location_on_sharp,
              size: 40,
              color: Colors.red,
            ),
        ],
      ),
    );
  }
}
