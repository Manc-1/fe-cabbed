import 'dart:async';
import 'package:flutter_login_ui/userProfile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';
import 'package:hexcolor/hexcolor.dart';
import 'userProfile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Heatmap Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Heatmap> _heatmaps = {};
  CameraPosition centreCameraOn = CameraPosition(
    target: LatLng(53.4704294754323, -2.241631994539886),
    zoom: 7,
  );
  List<LatLng> currentHeatmapLocations = [];
  List<LatLng> pastHeatmapLocations = [];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{
    MarkerId("test"):
        Marker(markerId: MarkerId("test"), position: LatLng(53.4808, -2.2426))
  };

  bool isCurrentMapSelected = false;
  bool isPastMapSelected = false;
  final String url = 'https://be-cabbed.herokuapp.com/api/';
  final String userId = '5ece886ea47bbd739d45750a';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: centreCameraOn,
            markers: Set<Marker>.of(markers.values),
            heatmaps: _heatmaps,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        // TOP ROW -----------------------------------------
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton.extended(
                    heroTag: "btn1",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserProfile()),
                      );
                    },
                    backgroundColor: Hexcolor('#FFB600'),
                    label: Text(
                      'Profile',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.red,
                  width: 70.0,
                  height: 48.0,
                  child: Center(
                    child: PopupMenuButton<String>(
                      child: Text("report incident"),
                      onSelected: choiceAction,
                      itemBuilder: (BuildContext context) {
                        return Constants.choices.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: FloatingActionButton.extended(
                  heroTag: "btn2",
                  onPressed: _centerMap,
                  backgroundColor: Hexcolor('#FFB600'),
                  label: Text(
                    ' Location ',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        // BOTTOM ROW ----------------------------------------
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    heroTag: "btn3",
                    onPressed: toggleCurrent,
                    backgroundColor: Hexcolor('#FFB600'),
                    label: Text(
                      'Current',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton.extended(
                    heroTag: "btn4",
                    onPressed: sendPickUpLocation,
                    backgroundColor: Hexcolor('#FFB600'),
                    label: Text(
                      "Pick-up",
                      style: TextStyle(color: Colors.black),
                    )),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton.extended(
                  heroTag: "btn5",
                  onPressed: togglePast,
                  backgroundColor: Hexcolor('#FFB600'),
                  label: Text(
                    ' Past ',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();

    getCurrent();
    getPasts();
    getMarkers();
    _centerMap();

    http.get(url + '/');
  }

  void choiceAction(String choice) {
    sendMarkerUpLocation(choice);
  }

  void getCurrent() {
    http.get(url + 'pickup').then((response) {
      //print(jsonDecode(response.body)['pickup']);
      List<LatLng> newLocations = [];

      jsonDecode(response.body)['pickup'].forEach((entry) {
        newLocations.add(LatLng(entry['latitude'], entry['longitude']));
      });
      currentHeatmapLocations = newLocations;
    });
  }

  void getPasts() {
    http.get(url + 'pickup/hour').then((response) {
      //print(jsonDecode(response.body)['pickup']);
      List<LatLng> newLocations = [];

      jsonDecode(response.body)['pickup'].forEach((entry) {
        newLocations.add(LatLng(entry['latitude'], entry['longitude']));
      });
      pastHeatmapLocations = newLocations;
    });
  }

  void getMarkers() {
    http.get(url + 'marker').then((response) {
      print('getting markers');
      print(jsonDecode(response.body));
      jsonDecode(response.body)["marker"].forEach((entry) {
        addMarker(entry);
      });
    });
  }

  Future<void> _centerMap() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 11,
    )));
    print(currentLocation);
    setState(() {
      centreCameraOn = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 11,
      );
    });
  }

  Future<void> sendMarkerUpLocation(String type) async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    Map<String, String> typeConverter = {
      'police incident': 'police',
      'closing soon': 'closing',
      'drunk crowd': 'drunk',
      'social event': 'social event'
    };

    var body = jsonEncode({
      'user': userId,
      'type': typeConverter[type],
      'latitude': currentLocation.latitude,
      'longitude': currentLocation.longitude,
    });
    http
        .post(url + 'marker',
            headers: {"Content-Type": "application/json"}, body: body)
        .then((response) => print(response.body));
  }

  Future<void> sendPickUpLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    var body = jsonEncode({
      'user': userId,
      'latitude': currentLocation.latitude,
      'longitude': currentLocation.longitude
    });
    http
        .post(url + 'pickup',
            headers: {"Content-Type": "application/json"}, body: body)
        .then((response) => print(response.body));
  }

  void addMarker(entry) {
    // BitmapDescriptor mapIcon = await BitmapDescriptor.fromAssetImage(
    //     createLocalImageConfiguration(context), 'assets/beer.png');
    final MarkerId markerId = MarkerId(entry["_id"]);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(entry['latitude'], entry['longitude']),
      infoWindow: InfoWindow(title: entry['type'], snippet: entry['time']),
    );
    print('creating marker' + entry['type']);

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void toggleCurrent() {
    if (!isCurrentMapSelected) {
      setState(() {
        _heatmaps.add(Heatmap(
            heatmapId: HeatmapId(currentHeatmapLocations.toString()),
            points: _createPoints(currentHeatmapLocations),
            radius: 50,
            visible: true,
            gradient: HeatmapGradient(
              colors: <Color>[Colors.green, Colors.red],
              startPoints: <double>[0.005, 0.8],
            )));
        isCurrentMapSelected = true;
      });
    } else {
      setState(() {
        _heatmaps.removeWhere((heatmap) =>
            heatmap.heatmapId == HeatmapId(currentHeatmapLocations.toString()));
        isCurrentMapSelected = false;
      });
    }
  }

  void togglePast() {
    if (!isPastMapSelected) {
      setState(() {
        _heatmaps.add(Heatmap(
            heatmapId: HeatmapId(pastHeatmapLocations.toString()),
            points: _createPoints(pastHeatmapLocations),
            radius: 50,
            visible: true,
            gradient: HeatmapGradient(
                colors: <Color>[Colors.blue, Colors.red],
                startPoints: <double>[0.005, 0.8])));
        isPastMapSelected = true;
      });
    } else {
      setState(() {
        _heatmaps.removeWhere((heatmap) =>
            heatmap.heatmapId == HeatmapId(pastHeatmapLocations.toString()));
        isPastMapSelected = false;
      });
    }
  }

  //heatmap generation helper functions
  List<WeightedLatLng> _createPoints(List<LatLng> locations) {
    final List<WeightedLatLng> points = <WeightedLatLng>[];
    //Can create multiple points here

    locations.forEach((location) {
      points
          .add(_createWeightedLatLng(location.latitude, location.longitude, 1));
      points.add(
          _createWeightedLatLng(location.latitude - 1, location.longitude, 1));
    });

    return points;
  }

  WeightedLatLng _createWeightedLatLng(double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }
}
