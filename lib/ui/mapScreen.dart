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

  getUserLocation() async {
    Position position = await GPSGeoLocator.getOneTimeLocation();
    if (position != null) {
      print('got the location');
      print('firestore location :' + widget.user.location.latitude.toString());
      setState(() {
        //this._center = LatLng(position.latitude, position.longitude);
        this._center = LatLng(
            widget.user.location.latitude, widget.user.location.longitude);
        this._loading = false;
      });
      setMarker();
      print(position.latitude);
      print(position.longitude);
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
      onTap: () {},
      icon: BitmapDescriptor.defaultMarker,
    );
    _markers.add(marker);
  }

  getMarkers() async {

  }

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
                child: Text('Loading...'),
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
              mapType: MapType.terrain,
              zoomGesturesEnabled: true,
              markers: _markers,
            ),
    );
  }
}
