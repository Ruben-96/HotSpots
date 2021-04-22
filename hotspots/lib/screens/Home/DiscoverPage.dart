import 'dart:async';

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
  void _addHeatmap(){
    LatLng _heatmapLocation = LatLng(32.733114, -97.112524);
    List<WeightedLatLng> heatmapPoints = _createPoints(_heatmapLocation);

    //TODO: for each post in the past day whose coordinates are in the visible area, add a heatmap point with said coordinates

    _heatmapLocation = LatLng(32.73060330871282, -97.1129670622124);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.729, -97.1130);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.7285, -97.1135);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.7298, -97.1129);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.731114, -97.112724);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.732114, -97.112824);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.733514, -97.112554);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.733314, -97.112624);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.733214, -97.112574);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.73414, -97.112654);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));
    _heatmapLocation = LatLng(32.733314, -97.112624);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.733214, -97.112574);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.73514, -97.112754);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.73414, -97.112454);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.73414, -97.112654);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));
    _heatmapLocation = LatLng(32.733344, -97.112724);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.733234, -97.112374);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.73344, -97.112654);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));

    _heatmapLocation = LatLng(32.735314, -97.112554);
    heatmapPoints.insertAll(0, _createPoints(_heatmapLocation));
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