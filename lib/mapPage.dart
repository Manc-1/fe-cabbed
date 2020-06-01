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
  final String userID;
  MapSample({Key key, @required this.userID}) : super(key: key);
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
    MarkerId("test"): Marker(
        markerId: MarkerId("test"),
        position: LatLng(53.4808, -2.2426),
        visible: false)
  };

  bool isCurrentMapSelected = false;
  bool isPastMapSelected = false;
  final String url = 'https://be-cabbed.herokuapp.com/api/';
  String userID;
  Object userData;
  final timeout = const Duration(seconds: 3);
  final ms = const Duration(milliseconds: 1);
  BitmapDescriptor beerIcon;
  BitmapDescriptor scheduleIcon;
  BitmapDescriptor carIcon;
  BitmapDescriptor clockIcon;

  @override
  Widget build(BuildContext context) {
    print('in widget ${widget.userID}');
    userID = widget.userID;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserProfile(
                        userID: userID,
                      )),
            ),
          ),
          title: PopupMenuButton<String>(
            icon:
                Icon(Icons.control_point, color: Hexcolor('#2a2a2a'), size: 30),
            color: Colors.black,
            onSelected: choiceAction,
            offset: Offset(-50, 100),
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Hexcolor('#FFB600'),
                      decorationThickness: 3,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList();
            },
          ),
          // }),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.adjust, color: Colors.black),
                onPressed: () => _centerMap()),
          ],
          backgroundColor: Hexcolor('#FFB600'),
        ),
      ),
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
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20),
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
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton.extended(
                      heroTag: "btn4",
                      onPressed: sendPickUpLocation,
                      backgroundColor: Hexcolor('#ef7d4c'),
                      label: Text(
                        "Pick-up",
                        style: TextStyle(color: Colors.black),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20, right: 10),
                child: Align(
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
    getBitmapImages();
    getCurrent();
    getPasts();
    getMarkers();
    _centerMap();
    //startTimeout(1000 * 120);
  }

  void getBitmapImages() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/beer.png')
        .then((onValue) {
      beerIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/clock.png')
        .then((onValue) {
      clockIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/calendar.png')
        .then((onValue) {
      scheduleIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(48, 48)), 'assets/car.png')
        .then((onValue) {
      carIcon = onValue;
    });
  }

  startTimeout([int milliseconds]) {
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    return new Timer.periodic(duration, (Timer t) => handleTimeout());
  }

  void handleTimeout() {
    getCurrent();
    getPasts();
    getMarkers();
    _centerMap();
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

    final Map<String, String> typeConverter = {
      'Police Incident': 'police',
      'Closing Soon': 'closing',
      'Drunk Crowd': 'drunk',
      'Social Event': 'social event'
    };

    var body = jsonEncode({
      'user': userID,
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
      'user': userID,
      'latitude': currentLocation.latitude,
      'longitude': currentLocation.longitude
    });
    http
        .post(url + 'pickup',
            headers: {"Content-Type": "application/json"}, body: body)
        .then((response) => print(response.body));
  }

  void addMarker(entry) {
    final Map<String, BitmapDescriptor> stringToBitmapDesctiptor = {
      'drunk': beerIcon,
      'social event': scheduleIcon,
      'closing': clockIcon,
      'police': carIcon
    };
    final Map<String, String> typeConverter = {
      'police': 'Police Incident',
      'closing': 'Closing Soon',
      'drunk': 'Drunk Crowd',
      'social event': 'Social Event'
    };

    final MarkerId markerId = MarkerId(entry["_id"]);
    final Marker marker = Marker(
      icon: stringToBitmapDesctiptor[entry['type']],
      markerId: markerId,
      position: LatLng(entry['latitude'], entry['longitude']),
      infoWindow: InfoWindow(
          title: typeConverter[entry['type']], snippet: entry['time']),
    );
    print('creating marker' + entry['type']);

    setState(() {
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
              colors: <Color>[Colors.orange, Colors.red],
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

  List<WeightedLatLng> _createPoints(List<LatLng> locations) {
    final List<WeightedLatLng> points = <WeightedLatLng>[];

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
