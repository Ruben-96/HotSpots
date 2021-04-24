import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';

class DiscoverPage extends StatefulWidget{

  final User user;

  DiscoverPage(this.user);

  @override
  _DiscoverPage createState() => _DiscoverPage();
}

class _DiscoverPage extends State<DiscoverPage>{
  Completer<GoogleMapController> _controller = Completer();
  final Set<Heatmap> _heatmaps = {};
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(32.73060330871282, -97.1129670622124),
    zoom: 17.0,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 190,
      target: LatLng(32.733114, -97.112524),
      tilt: 59.440717697143555,
      zoom: 10.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        heatmaps: _heatmaps,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addHeatmap,
        label: Text('Refresh'),
        icon: Icon(Icons.refresh),
      ),
    );
  }

  void _addHeatmap() async{
    LatLng _heatmapLocation = LatLng(32.733114, -97.112524);
    List<WeightedLatLng> heatmapPoints = _createPoints(_heatmapLocation);

    //TODO: for each post in the past day whose coordinates are in the visible area, add a heatmap point with said coordinates
    Widget serverHeatmapPoints = FutureBuilder(
        future: FirebaseFirestore.instance.collection("Post")
        //.where("timestamp", isGreaterThanOrEqualTo: "TODO: yesterday")
        //.where("latitude", isGreaterThan: "//TODO: map coordinate barrier").where("latitude", isLessThan: "TODO: map coordinate barrier")
        //.where("longitude", isGreaterThan: "//TODO: map coordinate barrier").where("longitude", isLessThan: "TODO: map coordinate barrier"))

            .limit(100)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError || !snapshot.hasData) return new Center(child: CircularProgressIndicator());
          else{
            for(var i = 0; i < snapshot.data.docs.length; i++){
              Map<String, dynamic> info = snapshot.data.docs.elementAt(i).data();

              _heatmapLocation = LatLng(info["latitude"], info["longitude"]);
              heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));
            }
          }
          // this part does not get used but is required by the function
          return Text('Hello, world!', textDirection: TextDirection.ltr,);
        }
    );

    setState(() {
      _heatmaps.add(
          Heatmap(
              heatmapId: HeatmapId(_heatmapLocation.toString()),
              points: heatmapPoints,
              radius: 50,
              visible: true,
              gradient:  HeatmapGradient(
                  colors: <Color>[Colors.green, Colors.red], startPoints: <double>[0.05, 0.50]
              )
          )
      );
    });
  }
  //heatmap generation helper functions
  List<WeightedLatLng> _createPoints(LatLng location) {
    final List<WeightedLatLng> points = <WeightedLatLng>[];
    //Can create multiple points here
    points.add(_createWeightedLatLng(location.latitude,location.longitude, 1));
    points.add(_createWeightedLatLng(location.latitude-1,location.longitude, 1));
    return points;
  }

  WeightedLatLng _createWeightedLatLng(double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }

}