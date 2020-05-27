import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  bool isCurrentMapSelected = false;
  bool isPastMapSelected = false;
  var url = 'https://be-cabbed.herokuapp.com/api/';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: centreCameraOn,
        heatmaps: _heatmaps,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 31),
            child: Align(
              alignment: Alignment(-.9, -.8),
              child: FloatingActionButton(
                onPressed: toggleCurrent,
                child: Text('current'),
              ),
            ),
          ),
          Align(
            alignment: Alignment(-.9, .8),
            child: FloatingActionButton(
              onPressed: _centerMap,
              tooltip: 'Get Location',
              child: Icon(Icons.trip_origin),
            ),
          ),
          Align(
            alignment: Alignment(.9, -.8),
            child: FloatingActionButton(
              onPressed: togglePast,
              child: Text('past'),
              backgroundColor: Colors.green,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
                onPressed: sendPickUpLocation, child: Text("pickup")),
          )
        ],
      ),
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
