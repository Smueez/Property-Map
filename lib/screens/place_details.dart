import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'package:logo_demo/screens/map_page.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:logo_demo/screens/objectClass.dart';
class PlacesDetails extends StatefulWidget {
  @override
  _placeDetail createState() => _placeDetail();
}

class _placeDetail extends State<PlacesDetails>{

  var first;
  String adress,title,note;
  double lat,lng;
  _getCordinate(String add)async{
    final query = add;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    first = addresses.first;
    lat = first.coordinates.latitude;
    lng = first.coordinates.longitude;
    print(lng);
  }

  final adressController = TextEditingController();
  final titleController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    adressController.dispose();
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }



  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyAsaccCWqc2tx9pW9KaqqjkGhJwre_ecpA");

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      lat = detail.result.geometry.location.lat;
      lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);
      print(address);
      print(lat);
      print(lng);
    }
  }



  @override
  Widget build(BuildContext context) {

      return Scaffold (
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text('LOGO',textAlign: TextAlign.center,),
          backgroundColor: Colors.red[700],
        ),
        body: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    Text('Enter your property full address',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(

                     /* onTap: ()async{
                        //final places = new GoogleMapsPlaces(apiKey: "<AIzaSyAsaccCWqc2tx9pW9KaqqjkGhJwre_ecpA>");
                        Prediction p = await PlacesAutocomplete.show(context: context, apiKey: "AIzaSyAsaccCWqc2tx9pW9KaqqjkGhJwre_ecpA",mode: Mode.overlay,
                        language: "en", components: [
                          Component(Component.country,"us")
                            ],hint: "Canada street 555");
                        if(p != null){
                          print("prediction exist");
                          displayPrediction(p);
                        }
                      },*/
                       controller: adressController,
                      decoration: InputDecoration(
                        labelText: 'Property adress...',
                        hintText: 'e.g. Canada street 555',
                        fillColor: Colors.grey[400],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text('Write your property title',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Your property title...',
                        hintText: 'e.g. My home',
                        fillColor: Colors.grey[400],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text('Describe about your property',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                        labelText: 'Enter any note here...',
                        hintText: 'write here...',
                        fillColor: Colors.grey[400],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: ButtonTheme(
                            minWidth: 520.0,
                            height: 60.0,
                            buttonColor: Colors.red,
                            child: RaisedButton(
                              onPressed: (){
                                print('map button pressed');
                                print(_getCordinate((adressController.text)));
                                objectClass obj = new objectClass(lat, lng, adressController.text, titleController.text);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MapActivity(obj)),
                                );
                              },
                              color: Colors.red,
                              //disabledBorderColor: Colors.grey[400],
                              child: Text(
                                'Submit',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                         )
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ),
      );
  }

}