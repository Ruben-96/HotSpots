
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotspots/models/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class SelectLocationPage extends StatefulWidget{

  final Function setLocation;

  SelectLocationPage(this.setLocation);

  @override
  _SelectLocationPage createState() => _SelectLocationPage();
}

class _SelectLocationPage extends State<SelectLocationPage>{

  String query = "";
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "loading...";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.administrativeArea}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context){
    return Material(
      child: Column(
        children: <Widget>[
          Row(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.red.shade400,
                height: 75,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 32),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(child: Text("Add Location", style: TextStyle(fontSize: 24, color: Colors.white)),),
                    ],
                  )
                )
              )
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child: TextFormField(
            maxLines: 1,
            minLines: 1,
            decoration: InputDecoration(
              icon: Icon(Icons.search,),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30),
                gapPadding: 0
              ),
              fillColor: Colors.black12,
              filled: true,
              hintText: "Search locations"
            ),
            onChanged: (val){
              query = val;
            },
          )
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal:50),child:FutureBuilder(
          future: FirebaseFirestore.instance.collection("Locations")
                                            .where("name", isGreaterThanOrEqualTo: query)
                                            .where("name", isLessThan: query + "z")
                                            .limit(10)
                                            .get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError || !snapshot.hasData) return new Center(child: CircularProgressIndicator());
            return  Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: <Widget>[
                    LocationContainer(Location(_currentAddress), widget.setLocation),
            ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index){
            Map<String, dynamic> info = snapshot.data.docs.elementAt(index).data();
            Location location = Location(info["name"]);
            return LocationContainer(location, widget.setLocation);
            }
            )
                  ],
                )); ////////

          }
        ))
        ],
      )
    );
  }
}

class LocationContainer extends StatelessWidget{

  final Location location;
  final Function setLocation;

  LocationContainer(this.location, this.setLocation);

  @override
  Widget build(BuildContext context){

    print(location.name);

    return ElevatedButton(
      child: Text(location.name, style: TextStyle(fontSize: 24, color: Colors.black87)),
      onPressed: (){
        setLocation(location.name);
        print("set to " + location.name);
        Navigator.pop(context);
      },
    );
  }
}