import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';

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
    target: LatLng(37.52096133580664, -122.085749655962),
    zoom: 14.4746,
  );
  List<LatLng> heatmapLocations = [ LatLng(37.527961335806, -122.0857496559), LatLng(37.527861335806, -122.0857496559),LatLng(37.524861335806, -122.0857496559),LatLng(37.524861335806, -122.0827496559) ];
  LatLng _heatmapLocation = LatLng(37.527961335806, -122.0857496559);
  LatLng _heatmapLocation1 = LatLng(37.526861335806, -122.0857496559);



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: centreCameraOn,
        heatmaps: _heatmaps,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left:31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                onPressed: _addHeatmap,
                label: Text('Add Heatmap'),
                icon: Icon(Icons.add_box),
              ),
            ),),

          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: _centerMap,
              tooltip: 'Get Location',
              child: Icon(Icons.flag),
            ),
          ),
        ],
      ),

    );
  }
  Future<void> _centerMap() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 14.4746,
    )));
        print(currentLocation);
        setState(() {
          centreCameraOn =  CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 14.4746,
          );
        });

//    setState(() {
//      _markers.clear();
//      final marker = Marker(
//        markerId: MarkerId("curr_loc"),
//        position: LatLng(currentLocation.latitude, currentLocation.longitude),
//        infoWindow: InfoWindow(title: 'Your Location'),
//      );
//      _markers["Current Location"] = marker;
//    });
  }

  void _addHeatmap(){
    setState(() {
//
      _heatmaps.add(
          Heatmap(
              heatmapId: HeatmapId(_heatmapLocation.toString()),
              points: _createPoints(heatmapLocations),
              radius: 50,
              visible: true,
              gradient:  HeatmapGradient(
                  colors: <Color>[Colors.green, Colors.red], startPoints: <double>[0.2, 0.8]
              )
          )
      );
    });
  }
  //heatmap generation helper functions
  List<WeightedLatLng> _createPoints(List<LatLng> locations) {
    final List<WeightedLatLng> points = <WeightedLatLng>[];
    //Can create multiple points here

    locations.forEach((location){
      points.add(_createWeightedLatLng(location.latitude,location.longitude, 1));
      points.add(_createWeightedLatLng(location.latitude-1,location.longitude, 1));
    });

    return points;
  }

  WeightedLatLng _createWeightedLatLng(double lat, double lng, int weight) {
    return WeightedLatLng(point: LatLng(lat, lng), intensity: weight);
  }

}