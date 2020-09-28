import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Model/Location.dart';
import 'package:gps_tracking_system/Utility/map_helper.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:geocoder/geocoder.dart';

class LocationPickerScreen extends StatefulWidget {
  final Location location;
  LocationPickerScreenState createState() =>
      LocationPickerScreenState(location);

  LocationPickerScreen(this.location, {Key key}):super(key:key);
}

class LocationPickerScreenState
    extends State<LocationPickerScreen> {

  static const double _INITIAL_CAMERA_ZOOM_RATIO  = 14.0;
  static const String _MARKER_ORIGIN_ID           = "origin";
  static const String _MARKER_TITLE               = 'Your location';
  static final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final Location _location;
  final Set<Marker> markerSet = {};
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();

  bool _isSearching = false;
  TextEditingController _searchBarController;

  LocationPickerScreenState(Location location):_location = location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          key: scaffoldKey,
          leading: _isSearching ? const BackButton() : null,
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
          actions: _buildActions(),
        ),
        body: _buildMap(context));
  }

  @override
  void initState() {
    super.initState();
    _searchBarController = new TextEditingController();
    if(_location.address.isEmpty) {
      _getCurrentLocation();
    } else {
      _updateLocation(_location.getPosition());
      _updateMarker();
    }
  }

  void _getCurrentLocation() async {
    await _updateLocation(await getCurrentPosition(desiredAccuracy: LocationAccuracy.high));
    _updateMarker();
  }

  Future<void> _updateLocation(Position position)async {
    _location.latitude  = position.latitude;
    _location.longitude = position.longitude;
    _location.address   = await latLngToAddress(position);
    _searchBarController.text = _location.address;
  }

  void searchLocation(String location)async
  {
    Coordinates coordinates= (await Geocoder.local.findAddressesFromQuery(location)).first.coordinates;
    _location.address = location;
    _location.latitude = coordinates.latitude;
    _location.longitude = coordinates.longitude;
    _updateMarker();
  }

  Future<String> latLngToAddress(Position position) async{
    List<Address> addresses=await Geocoder.local.findAddressesFromCoordinates(MapHelper.positionToCoordinates(position));
    return addresses.first.addressLine;
  }

  void _updateMarker() async{
    await moveCameraToLocation();
    setState(() {
      markerSet.clear();
      markerSet.add(Marker(
        markerId: MarkerId(_MARKER_ORIGIN_ID),
        position: _location.getLatLng(),
        infoWindow: InfoWindow(title: _MARKER_TITLE),
        draggable: true,
        onDragEnd: (value)async{
           await _updateLocation(MapHelper.latLngToPosition(value));
           setState(() {});
        }
      ));
    });
  }

  Widget _buildMap(BuildContext context) {
    return Stack(children: [
      GoogleMap(
        mapType: MapType.normal,
        markers: markerSet,
        zoomControlsEnabled: false,
        onMapCreated: setGoogleMapController,
        initialCameraPosition: CameraPosition(
          target:_location.getLatLng(),
          zoom: _INITIAL_CAMERA_ZOOM_RATIO,
        ),
      ),

      Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.all(10),
            onPressed: (){
              Navigator.of(context).pop();
            },
            color: primaryColor,
            child: Text(
              "SELECT",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      )
    ]);
  }

  Future<void> moveCameraToLocation()async
  {
    GoogleMapController controller= await _mapControllerCompleter.future;
    controller.animateCamera(CameraUpdate.newLatLng(_location.getLatLng()));
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            Text(_location.address.isEmpty? _MARKER_TITLE: _location.address),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchBarController,
      autofocus: true,
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: _MARKER_TITLE,
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      // onChanged: updateSearchQuery,
      onSubmitted: (text){
        searchLocation(text);
      },
    );
  }

  void setGoogleMapController(GoogleMapController controller) {
    _mapControllerCompleter.complete(controller);
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if(_searchBarController.text.isEmpty)
              setState(() {_isSearching = false;});
            else
              _searchBarController.clear();
          },
        )
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: (){
          setState(() {_isSearching = true;});
        },
      ),
      new IconButton(icon: Icon(Icons.my_location), onPressed: _getCurrentLocation)
    ];
  }
}
