import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logo_demo/screens/objectClass.dart';
import 'package:logo_demo/screens/place_details.dart';

class MapActivity extends StatefulWidget {

  objectClass object;
  MapActivity(objectClass object){this.object = object;}
  @override
  _MapClass createState() => _MapClass();

}

class _MapClass extends State<MapActivity>{

  GoogleMapController mapController;
  //var lat=, lng=;

  Completer<GoogleMapController> _controler = Completer();
  Placemark place_pos;
  static LatLng _center = LatLng(22.9006 ,89.5024);
  final Set<Marker> markers = {};
  final Set<Marker> placesM = {};

  MapType currenMapType = MapType.normal;

  getcurrentPos(){
    var location = new Location();
    //LatLng currentpos;
    location.onLocationChanged().listen((LocationData currentLocation) {
      //print(currentLocation.latitude);
      //print(currentLocation.longitude);
      _center = LatLng(currentLocation.latitude,currentLocation.longitude);
    });

    print(_center.latitude.toString());
    print(_center.longitude.toString());
  }

  LatLng _lastMapPosition = _center;

  _OnMapCreated(GoogleMapController controller){
    getcurrentPos();
    _onAddMarkerButtonPressed();
    _controler.complete(controller);
    //placesM.clear();

    //_getAddress(_lastMapPosition);
    LatLng placePos = LatLng(widget.object.getLat(),widget.object.getLng());
    _center = placePos;
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(placePos.toString()),
        position: placePos,
        infoWindow: InfoWindow(
          title: widget.object.getTitle(),
          snippet: widget.object.getAdd(),
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

  }
  var first;
  _getAddress(LatLng pos) async {
    final coordinates = new Coordinates(pos.latitude, pos.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    print("${first.featureName} : ${first.addressLine} ");
  }

  _clearMarkers(){
    placesM.clear();
  }

  _OncameraMove(CameraPosition position){
    _lastMapPosition = position.target;
  }



  Widget button(Function function, IconData icon,int x){
    return FloatingActionButton(
      heroTag: 'btn'+x.toString(),
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(icon,size: 36.0),
    );
  }


  _onMapTypeButtonPressed(){
    setState(() {
      currenMapType = currenMapType == MapType.normal ? MapType.satellite: MapType.normal;

    });
  }

  _onAddMarkerButtonPressed(){
    markers.clear();
    _getAddress(_lastMapPosition);
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'My current Location',
          snippet: first.addressLine,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

  }


  @override
  Widget build(BuildContext context) {
    //_center = LatLng(widget.object.getLat(),widget.object.getLng());
    return  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('LOGO',textAlign: TextAlign.center,),
          backgroundColor: Colors.red[700],
        ),
        body: Stack (
          children: <Widget>[
            GoogleMap(
              onMapCreated: _OnMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 13.0,
              ),
              mapType: currenMapType,
              markers: markers,
              onCameraMove: _OncameraMove,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0,350.0,16.0,0.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  children: <Widget>[
                    button(_onMapTypeButtonPressed, Icons.map,1),
                    SizedBox(
                      height: 16.0,
                    ),
                    button(_onAddMarkerButtonPressed, Icons.add_location,2),
                    SizedBox(
                      height: 16.0,
                    ),
                    button(_clearMarkers, Icons.clear,3),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: ButtonTheme(
                  minWidth: 500.0,
                  height: 60.0,
                  buttonColor: Colors.grey[400],
                  child: RaisedButton(
                    onPressed: (){
                      print('button pressed');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlacesDetails()),
                      );
                    },
                    color: Colors.green[50],
                    //disabledBorderColor: Colors.grey[400],
                    child: Text(
                      'Search location here...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),

                  ),

                )
              ),
            ),
          ],
        )
    );
  }

}