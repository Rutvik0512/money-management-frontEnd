import 'package:flutter/material.dart';

import '../Payload/Place.dart';

class StaticMapWidget extends StatelessWidget {
  const StaticMapWidget({Key? key, required this.place}) : super(key: key);

  final Place? place;

  String get staticLocation{
    double? lat = place?.latitude;
    double? long = place?.longitude;

    if(lat==null || long == null) return " ";

    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=AIzaSyCu5pAsFBSLj-Yko5pjRjAvnoDJPaRqif0";
  }
  @override
  Widget build(BuildContext context) {
    return  Card(
      child: place == null? const Text('Location Unavailable'): Image.network(staticLocation,fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
    );
  }
}
