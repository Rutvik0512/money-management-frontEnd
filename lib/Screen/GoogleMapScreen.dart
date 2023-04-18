import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Payload/Place.dart';

class GoogleMapScreen extends StatefulWidget {
    const GoogleMapScreen({super.key,this.place = const Place(
    longitude: 37.422,
    latitude: -122.084,
    address: ''
  ),this.isSelecting = true});

    static const routeName ='/GoogleMapScreen';

  final Place place;
  final bool isSelecting;
  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        actions: [
          if(widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {},
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.place.latitude!,widget.place.longitude!),
          zoom: 16
        ),
        markers: {
          Marker(
            markerId: const MarkerId("m1"),
            position: LatLng(widget.place.latitude!,widget.place.longitude!)
          )
        },
      ),
    );
  }
}
