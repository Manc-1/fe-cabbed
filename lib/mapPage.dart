import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

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
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: centreCameraOn,
        markers: Set<Marker>.of(markers.values),
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
                heroTag: "btn1",
                onPressed: toggleCurrent,
                child: Text('current'),
              ),
            ),
          ),
          Align(
            alignment: Alignment(-.9, .8),
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: _centerMap,
              tooltip: 'Get Location',
              child: Icon(Icons.trip_origin),
            ),
          ),
          Align(
            alignment: Alignment(.9, -.8),
            child: FloatingActionButton(
              heroTag: "btn3",
              onPressed: togglePast,
              child: Text('past'),
              backgroundColor: Colors.green,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
                heroTag: "btn4",
                onPressed: sendPickUpLocation,
                child: Text("pickup")),
          ),
          Align(
            alignment: Alignment(0, -.8),
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
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    getCurrent();
    getPasts();
    getMarkers();

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

  Future<void> sendMarkerUpLocation(String type) async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    var body = jsonEncode({
      'user': userId,
      'type': type,
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
