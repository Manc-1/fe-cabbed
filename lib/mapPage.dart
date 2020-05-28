import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hexcolor/hexcolor.dart';

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
  List<Marker> markers = [];

  bool isCurrentMapSelected = false;
  bool isPastMapSelected = false;
  var url = 'https://be-cabbed.herokuapp.com/api/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: centreCameraOn,
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
                    onPressed: toggleCurrent,
                    backgroundColor: Hexcolor('#FFB600'),
                    label: Text(
                      'Profile',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment(-.9, .8),
              //   child: FloatingActionButton(
              //     heroTag: "btn2",
              //     onPressed: _centerMap,
              //     tooltip: 'Get Location',
              //     child: Icon(Icons.trip_origin),
              //   ),
              // ),
              Align(
                alignment: Alignment.topCenter,
                child: FloatingActionButton.extended(
                    heroTag: "btn4",
                    onPressed: sendPickUpLocation,
                    backgroundColor: Hexcolor('#FFB600'),
                    label: Text(
                      "centre",
                      style: TextStyle(color: Colors.black),
                    )),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: FloatingActionButton.extended(
                  heroTag: "btn3",
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
                    heroTag: "btn1",
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
                  heroTag: "btn3",
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
    http.get(url + 'pickup').then((response) {
      print(jsonDecode(response.body)['pickup']);
      List<LatLng> newLocations = [];

      jsonDecode(response.body)['pickup'].forEach((entry) {
        newLocations.add(LatLng(entry['latitude'], entry['longitude']));
      });
      currentHeatmapLocations = newLocations;
    });

    http.get(url + 'pickup/hour').then((response) {
      print(jsonDecode(response.body)['pickup']);
      List<LatLng> newLocations = [];

      jsonDecode(response.body)['pickup'].forEach((entry) {
        newLocations.add(LatLng(entry['latitude'], entry['longitude']));
      });
      pastHeatmapLocations = newLocations;
    });

    http.get(url + '/');
  }

  Future<void> _centerMap() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 7,
    )));
    print(currentLocation);
    setState(() {
      centreCameraOn = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 4,
      );
    });
  }

  Future<void> sendPickUpLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    var body = jsonEncode({
      'latitude': currentLocation.latitude,
      'longitude': currentLocation.longitude
    });
    http
        .post(url + 'pickup',
            headers: {"Content-Type": "application/json"}, body: body)
        .then((response) => print(response.body));
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
