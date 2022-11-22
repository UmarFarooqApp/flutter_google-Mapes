

import 'dart:async';
import 'dart:collection';


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

// This widget is the root of your application.
@override
Widget build(BuildContext context) {
return MaterialApp(

title: 'Flutter Demo',
theme: ThemeData(

primarySwatch: Colors.blue,
),
home: const Google_Map(),
);
}
}

class Google_Map extends StatefulWidget {
const Google_Map({Key? key}) : super(key: key);

@override
Google_MapState createState() => Google_MapState();
}

class Google_MapState extends State<Google_Map> {
Completer<GoogleMapController> _controller = Completer();

static const CameraPosition _kGooglePlex = CameraPosition(
target: LatLng(37.42796133580664, -122.085749655962),
zoom: 14.4746,
);

static const CameraPosition _kLake = CameraPosition(
bearing: 192.8334901395799,
target: LatLng(37.43296265331129, -122.08832357078792),
tilt: 59.440717697143555,
zoom: 14.151926040649414);
List<Marker> _Marker=[];
List<Marker> markers=const[
Marker(

markerId: MarkerId("1"),
position: LatLng(33.343,7.2344,
),
infoWindow: InfoWindow(
title: "location 1"
),


),
Marker(

markerId: MarkerId("2"),
position: LatLng(33.7343,7.64544,
),
infoWindow: InfoWindow(
title: "location 1"
),


),
Marker(

markerId: MarkerId("3"),
position: LatLng(33.343555,7.2366,
),
infoWindow: InfoWindow(
title: "location 1"
),


),
Marker(


markerId: MarkerId("4"),
position: LatLng(33.344,7.2347,
),
infoWindow: InfoWindow(
title: "location 1"
),


),

];
Future<bool> _handleLocationPermission() async {
bool serviceEnabled;
LocationPermission permission;

serviceEnabled = await Geolocator.isLocationServiceEnabled();
if (!serviceEnabled) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
content: Text('Location services are disabled. Please enable the services')));
return false;
}
permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
permission = await Geolocator.requestPermission();
if (permission == LocationPermission.denied) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('Location permissions are denied')));
return false;
}
}
if (permission == LocationPermission.deniedForever) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
content: Text('Location permissions are permanently denied, we cannot request permissions.')));
return false;
}
return true;
}
String? _currentAddress;
Position? _currentPosition;
Future<void> _getCurrentPosition() async {
final hasPermission = await _handleLocationPermission();
if (!hasPermission) return;
await Geolocator.getCurrentPosition(
desiredAccuracy: LocationAccuracy.high)
    .then((Position position)async {
double lat=position.latitude;
double lang=position.longitude;
GoogleMapController controller=await _controller.future;
controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(33.443176, 73.208325),
zoom: 14.32

)));

setState(() => _currentPosition = position);
}).catchError((e) {
debugPrint(e);
});
}
List <LatLng>points=
[
LatLng(33.443176, 73.208325),
LatLng(33.550826, 73.084728),
LatLng(33.580005, 73.136913),
LatLng(33.655484, 73.077175),
LatLng(33.559981, 72.816250),
LatLng(33.713762, 72.793591),
LatLng(33.792547, 73.255703),
LatLng(33.656627, 73.337414),
LatLng(33.443176, 73.208325),

];
Set<Polygon> _polygon=HashSet<Polygon>();
@override
void initState() {
_Marker.addAll(markers);
setState(() {
_getCurrentPosition();
loadData();
changeTheam();

});
super.initState();
}
loadData(){
_polygon.add(
Polygon(polygonId: PolygonId("1"),
points: points,
geodesic: true,
fillColor: Colors.transparent,
strokeColor: Colors.green,
strokeWidth: 4,
)
);
for (int i=0;i<points.length;i++){
_Marker.add(Marker(markerId: MarkerId(i.toString()),
position: points[i],
infoWindow: InfoWindow(title: "location :"+i.toString())
));
}

}
/// change the theam
///
String theam='';
changeTheam(){
DefaultAssetBundle.of(context).loadString("assets/mapThem/naigtThem.json").then((value) =>
{
theam=value,
});
}

@override
Widget build(BuildContext context) {
// _Marker.addAll(markers);
return SafeArea(child: Scaffold(
body: Container(

child: GoogleMap(
polygons: _polygon,
markers: Set<Marker>.of(_Marker),
mapType: MapType.normal,
initialCameraPosition: _kGooglePlex,

onMapCreated: (GoogleMapController controller) {
controller.setMapStyle(theam);
_controller.complete(controller);
},
),
),
floatingActionButton: FloatingActionButton(onPressed: () async{
GoogleMapController controller=await _controller.future;
controller.animateCamera(CameraUpdate.newCameraPosition(const CameraPosition(target: LatLng(33.343,7.2344,
),
zoom: 12
)));

},
child: Icon(Icons.add),

),
)

);
}
}