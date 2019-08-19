import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_fire_login/models/user.dart';
import 'package:flutter_fire_login/utils/GpsGeoLocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key, this.title, this.user}) : super(key: key);
  final String title;
  final User user;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;
  LatLng _center; // = LatLng(45.521563, -122.677433);
  Set<Marker> _markers;
  bool _loading = false;
  bool _markerView = true;

  @override
  void initState() {
    super.initState();
    _loading = true;
    getUserLocation();
    getMarkers();
  }

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Text(
                    'User Infomation',
                    textAlign: TextAlign.left,
                  )),
              ListTile(
                leading: Icon(Icons.verified_user), //account_circle
                title: Text(widget.user.name.toString()),
                subtitle: Text(widget.user.designation),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.location_city),
                title: Text(widget.user.address),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(widget.user.startTime),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(widget.user.mobile.toString()),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(widget.user.email),
                onTap: () => {},
              ),
            ]),

            // child: Text(widget.user.mobile.toString()),
            // padding: EdgeInsets.all(40.0),
          );
        });
  }

  getUserLocation() async {
    //Position position = await GPSGeoLocator.getOneTimeLocation();  //get user current location
    if (widget.user != null) {
      print('got the location');
      setState(() {
        this._center = LatLng(widget.user.latitude, widget.user.longitude);
        //this._center = LatLng(position.latitude, position.longitude);
        this._loading = false;
      });
      setMarker();
    }
  }

  setMarker() {
    _markers = Set<Marker>();
    print(widget.user.id.toString());
    final MarkerId markerId = MarkerId(widget.user.id.toString());
    print(this._center.latitude);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        this._center.latitude + sin(1 * pi / 6.0) / 20.0,
        this._center.longitude + cos(1 * pi / 6.0) / 20.0,
      ),
      infoWindow:
          InfoWindow(title: widget.user.name, snippet: widget.user.address),
      onTap: () {
        showModalSheet();
      },
      icon: BitmapDescriptor.defaultMarker,
    );
    _markers.add(marker);
  }

  getMarkers() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.location_off),
            onPressed: () {
              if (this._markerView) {
                setState(() {
                  this._markers = null;
                });
              }
              if (!this._markerView) {
                setMarker();
              }
              this._markerView = !this._markerView;
            },
          )
        ],
      ),
      body: _loading == true
          ? Container(
              child: Center(
                  child: CircularProgressIndicator() //Text('Loading...'),
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
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              markers: _markers,
            ),
    );
  }
}
