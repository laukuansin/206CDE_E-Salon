import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_tracking_system/Model/Location.dart';
import 'package:gps_tracking_system/Utility/rest_api.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:geocoder/geocoder.dart';

class AddAppointmentSelectLocation extends StatefulWidget {
  Location location;
  AddAppointmentSelectLocationState createState() =>
      AddAppointmentSelectLocationState(location);

  AddAppointmentSelectLocation({Key key,@required this.location}):super(key:key);
}

class AddAppointmentSelectLocationState
    extends State<AddAppointmentSelectLocation> {

  static const double _INITIAL_CAMERA_ZOOM_RATIO = 14.0;
  Position currentLocation;
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  TextEditingController _searchQuery;
  bool _isSearching = false;
  String address="";

  double longitude=0, latitude=0;
  final Map<String, Marker> _markers = {};

  AddAppointmentSelectLocationState(Location location){
    this.address=location.address;
    this.latitude=location.latitude;
    this.longitude=location.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          key: scaffoldKey,
          leading: _isSearching ? const BackButton() : null,
          actions: _buildActions(),
          title: _isSearching ? _buildSearchField() : _buildTitle(context),
        ),
        body: _buildMap(context));
  }

  void _getLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      moveCameraToLocation();
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
      this.latitude = position.latitude;
      this.longitude = position.longitude;
      this.currentLocation=position;

    });
  }
  void _getSelectLocation(){
    Position position=new Position(longitude: longitude,latitude: latitude);
    setState(() {
      moveCameraToLocation();
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
      this.latitude = position.latitude;
      this.longitude = position.longitude;
      this.currentLocation=position;

    });
  }
  @override
  void initState() {
    super.initState();

    _searchQuery = new TextEditingController();
    if(address.isEmpty&&longitude==0&&latitude==0)
    {
      _getLocation();

    }
    else{
      _getSelectLocation();
    }
  }

  Widget _buildMap(BuildContext context) {
    if (this.currentLocation!=null) {
      getAddressByLatLng(this.currentLocation);

      return Stack(children: [
        GoogleMap(
          mapType: MapType.normal,
          markers: _markers.values.toSet(),
          zoomControlsEnabled: false,
          onMapCreated: setGoogleMapController,
          onTap: _handleTap,
          initialCameraPosition: CameraPosition(
            target: LatLng(latitude, longitude),
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
                Navigator.pop(context,new Location(address, latitude, longitude));

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
  }
  void _handleTap(LatLng point)
  {
    setState(() {

      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(point.latitude, point.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
      this.latitude = point.latitude;
      this.longitude = point.longitude;
      Position position=new Position(latitude:this.latitude,longitude:this.longitude );
      this.currentLocation=position;
      moveCameraToLocation();

    });
  }
  void moveCameraToLocation()async
  {
    GoogleMapController controller=await  _mapControllerCompleter.future;
    LatLng latLng=new LatLng(latitude, longitude);
    controller.moveCamera(CameraUpdate.newLatLng(latLng));
  }
    void getAddressByLatLng(Position position)async{

     Coordinates coordinates=new Coordinates(position.latitude,position.longitude);

     var addresses=await Geocoder.local.findAddressesFromCoordinates(coordinates);
     var first = addresses.first;
    setState(() {
      this.address=first.addressLine;
    });
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
            _checkDefaultAddress(),
          ],
        ),
      ),
    );
  }

  Text _checkDefaultAddress() {
    if (address.isEmpty) {
      return Text('Select Location');
    } else {
      return Text(address);
    }
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: 'Search location',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
      onSubmitted: (text){
        searchLocation(text);
      },
    );
  }

  void setGoogleMapController(GoogleMapController controller) {
    _mapControllerCompleter.complete(controller);
  }
  void searchLocation(String location)async
  {
      var query=location;
      var address=await Geocoder.local.findAddressesFromQuery(query);
      var first=address.first;
      Coordinates coordinates=first.coordinates;
      setState(() {
        _markers.clear();
        final marker = Marker(
          markerId: MarkerId("curr_loc"),
          position: LatLng(coordinates.latitude, coordinates.longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
        );
        _markers["Current Location"] = marker;
        this.latitude = coordinates.latitude;
        this.longitude = coordinates.longitude;
        Position position=new Position(latitude:this.latitude,longitude:this.longitude );
        this.currentLocation=position;
        moveCameraToLocation();
      });
  }
  void _startSearch() {
    print("open search box");
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("");
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      address = newQuery;
    });
    print("search query " + newQuery);
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              setState(() {
                address=""
                   ;
              });

              Navigator.pop(context);


              return;
            }
            _clearSearchQuery();
          },
        )
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
      new IconButton(icon: Icon(Icons.my_location), onPressed: _getLocation)
    ];
  }

}
