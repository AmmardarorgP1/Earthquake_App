// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'model/QuakeModel.dart';
import 'network/network_quake.dart';


class QuakesApp extends StatefulWidget {
  const QuakesApp({super.key});



  @override
  State<QuakesApp> createState() => _QuakesAppState();
}

class _QuakesAppState extends State<QuakesApp> {

  late Future<Quake> _quakeData;
    final Completer<GoogleMapController> _controller = Completer();
    final List<Marker> _markerlist = <Marker>[];
    double _zoomValue = 5.00 ;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quakeData = Network().getQuakes();
    _quakeData.then((value) => debugPrint("value: ${value.features?[0].geometry?.coordinates}"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(

        children: <Widget>[
                    _buildMapGoogleMapController(),
                Row(
                  crossAxisAlignment:CrossAxisAlignment.start ,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _zoomout(),
                    _zoomIn()

                  ],
                )


        ],

      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        _findQuakes();
      }, label: Text("Find Quakes")),
    );
  }
Widget _zoomout()
{
  return Padding(
    padding: const EdgeInsets.only(top: 70.0),
    child: Align(
      alignment:  Alignment.topLeft,
      child: IconButton(onPressed: (){
        _zoomValue--;
        OutZoomed(_zoomValue);
      }, icon:Icon(FontAwesomeIcons.magnifyingGlassMinus),color: Colors.black, ),

    ),
  );
}
Widget  _buildMapGoogleMapController() {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: GoogleMap(mapType: MapType.normal,onMapCreated: (GoogleMapController controller){
      _controller.complete(controller);

    },initialCameraPosition: CameraPosition(target: LatLng(31.5204,74.3587),zoom: 3),
      markers: Set<Marker>.of(_markerlist),
      zoomControlsEnabled: false,

    ),
  );
}

  void _findQuakes() {
  setState(() {
    _markerlist.clear();  // clear the marker in the beginning
    _handleResponse();

  });
  }

  void _handleResponse() {
  setState(() {
      _quakeData.then((quakes) {
        quakes.features?.forEach((quakes) {
          _markerlist.add(Marker(markerId: MarkerId(quakes.id.toString()),
           infoWindow: InfoWindow(title: quakes.properties?.mag.toString(),snippet: quakes.properties?.title),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
            position: LatLng(quakes.geometry!.coordinates![1].toDouble(), quakes.geometry!.coordinates![0].toDouble())
            ,onTap: (){}
          )
          );
        });
      });
  });
  }

  Future<void> OutZoomed(double zoomValue) async {

  final GoogleMapController controller = await _controller.future ;
  controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition
    (target: LatLng(31.5204,74.3587),zoom: zoomValue, )));


  }

  Widget _zoomIn()
  { 
    return Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: Align(
        alignment:  Alignment.topLeft,
        child: IconButton(onPressed: (){
          _zoomValue++;
          InZoomed(_zoomValue);
        }, icon:Icon(FontAwesomeIcons.magnifyingGlassPlus),color: Colors.black, ),

      ),
    );
  }

 Future <void> InZoomed(double zoomValue) async
 {
   final GoogleMapController controller = await _controller.future ;
   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition
     (target: LatLng(31.5204,74.3587),zoom: zoomValue, )));

 }
}
