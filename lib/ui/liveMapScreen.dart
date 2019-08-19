import 'package:flutter/material.dart';
import 'package:flutter_fire_login/utils/GpsGeoLocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//https://medium.com/flutter-community/exploring-google-maps-in-flutter-8a86d3783d24

class LiveMapScreen extends StatefulWidget {
  LiveMapScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LiveMapScreenState createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final Firestore _database = Firestore.instance;

  GoogleMapController _mapController;
  LatLng _center, _vehicleLocation; // = LatLng(45.521563, -122.677433);

  Set<Marker> _markers = Set<Marker>();
  bool _loading = false;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _loading = true;
    getUsers();
    getVehicleLocation();
    getUserLocation();
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  getUsers() async {
    _database
        .collection('users')
        //.where('isActive', isEqualTo: 1)
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          getUserMarkers(
              docs.documents[i].data, docs.documents[i].documentID, false);
        }
      }
    });
  }

  getUserMarkers(data, id, isVehicle) {
    //since user and driver tables could have same id,
    // append id with a char to show unique id
    var markerId = isVehicle ? 'D' + id : id;

    final MarkerId _markerId = MarkerId(markerId);

    // create a new Marker
    final Marker marker = Marker(
        markerId: _markerId,
        position: LatLng(data['latitude'], data['longitude']),
        infoWindow: InfoWindow(title: data['name'], snippet: data['address']),
        icon: isVehicle
            ? BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRose,
              )
            : BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
        onTap: () {
          _mapController.animateCamera(
            CameraUpdate.newLatLngZoom(
                LatLng(data['latitude'], data['longitude']), 12.0),
          );
        });

    setState(() {
      // adding a new marker to map
      _markers.add(marker);
    });
  }

  getUserLocation() async {
    Position position =
        await GPSGeoLocator.getOneTimeLocation(); //get user current location
    if (position != null) {
      print('got the location');
      setState(() {
        this._center = LatLng(position.latitude, position.longitude);
        this._loading = false;
      });
      setMarker();
    }
  }

  setMarker() {
    // _markers = Set<Marker>();
    // final MarkerId markerId = MarkerId(widget.user.id.toString());
    // print(this._center.latitude);
    // final Marker marker = Marker(
    //   markerId: markerId,
    //   position: LatLng(
    //     this._center.latitude + sin(1 * pi / 6.0) / 20.0,
    //     this._center.longitude + cos(1 * pi / 6.0) / 20.0,
    //   ),
    //   infoWindow:
    //       InfoWindow(title: widget.user.name, snippet: widget.user.address),
    //   onTap: () {},
    //   icon: BitmapDescriptor.defaultMarker,
    // );
    // _markers.add(marker);
  }

  getVehicleLocation() {
    _database.collection('drivers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        getUserMarkers(docs.documents[0].data, docs.documents[0].documentID,
            true); //set Marker for vehicle
        setState(() {
          this._vehicleLocation = LatLng(docs.documents[0].data['latitude'],
              docs.documents[0].data['longitude']);
        });
        print(this._vehicleLocation);
      }
    });
  }

  navigateToVehicleLocation() async {
    //get driver LatLong from firestore and update it here
    //to track the vehicle exact position

    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(this._vehicleLocation, 11.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live View'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      body: _loading == true
          ? Container(
              child: Center(
                  child: CircularProgressIndicator() // Text('Loading...'),
                  ),
            )
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 11.0),
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              markers: _markers //Set<Marker>.of(markers.values)
              ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.drive_eta),
        onPressed: () {
          navigateToVehicleLocation();
        },
      ),
    );
  }
}
