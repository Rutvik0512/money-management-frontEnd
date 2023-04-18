import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Payload/Credit.dart';
import '../Payload/Place.dart';
import '../Widget/StaticMapWidget.dart';
import 'GoogleMapScreen.dart';

class MapScreen extends StatefulWidget {

   const MapScreen({Key? key, this.credit}) : super(key: key);
  static const routeName ='/MapScreen';
  final Credit? credit;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

    bool _gotLocation = false;
    Place? place;

    getLocation() async{
      Location location = Location();
      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      setState((){
        _gotLocation = true;
      });

      locationData = await location.getLocation();

      double? latitude = locationData.latitude;
      double? longitude = locationData.longitude;

      final url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyCu5pAsFBSLj-Yko5pjRjAvnoDJPaRqif0");


      final response = await http.get(url);

      String address = jsonDecode(response.body)['results'][0]['formatted_address'];

      print(address);

      setState((){
         place = Place(
             latitude: latitude,
             longitude: longitude,
             address: address
         );
        _gotLocation = false;
      });


  }

  @override
  Widget build(BuildContext context) {

      if(widget.credit != null) place = widget.credit!.place;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Getting Location'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, place);
              },
              icon: const Icon(Icons.save)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => GoogleMapScreen(place: place!,isSelecting: false,)
                    ),
                )
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: MediaQuery.of(context).size.height/2,
                child: _gotLocation && place==null ? const CircularProgressIndicator(): StaticMapWidget(place: place),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    onPressed: getLocation,
                    icon: const Icon(Icons.location_on_sharp),
                    label: const Text('Get Current Location')
                ),
                TextButton.icon(
                    onPressed: getLocation,
                    icon: const Icon(Icons.map_rounded),
                    label: const Text('Select Location')
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
