import 'dart:convert';

import 'package:http/http.dart';

import '../model/QuakeModel.dart';

class Network{


  Future<Quake> getQuakes() async
  {
    var url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson";

    final response = await get(Uri.parse(Uri.encodeFull(url)));

    if(response.statusCode == 200)
      {
        print("response: ${response.body}" );

        return Quake.fromJson(json.decode(response.body));
      }
    else
      {
        throw Exception("Error getting Quakes!!!!");
      }



  }


}