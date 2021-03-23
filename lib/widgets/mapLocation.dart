import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
// import 'package:background_locator/location_settings.dart';
import 'package:delivery_boy_app/helpers/locationHelper/locationCallbackHandler.dart';
import 'package:delivery_boy_app/helpers/locationHelper/locationServiceRepo.dart';
import 'package:delivery_boy_app/screens/order_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MapLocation extends StatefulWidget {
  final WayPoint destination;
  final bool isFromDetail;
  MapLocation({Key key, this.destination, this.isFromDetail}) : super(key: key);

  @override
  MapLocationState createState() => MapLocationState();
}

class MapLocationState extends State<MapLocation> {
  Completer<GoogleMapController> _controller =
      Completer(); // this set will hold my markers
  Set<Marker> _markers = {}; // this will hold the generated polylines
  Set<Polyline> _polylines =
      {}; // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates =
      []; // this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  String googleAPIKey = "AIzaSyAsT1Q3MrucK_Y9a-Kzx3fIc_1c6_ekpCw";
  String _platformVersion = 'Unknown';
  bool isRunning = false;
  var permission;
  LocationDto lastLocation;
  DateTime lastTimeLocation;
  var _origin =
      WayPoint(name: "hamburg", latitude: 42.71589, longitude: -78.82948);
  var _destination =
      WayPoint(name: "sus", latitude: 41.2098, longitude: -74.6077);
  ReceivePort port = ReceivePort();
  MapboxNavigation _directions;
  bool _arrived = false;
  double _distanceRemaining, _durationRemaining;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(18.031371, -66.587884),
    zoom: 14.4746,
  );
  @override
  void initState() {
    super.initState();
    if (widget.destination != null) _destination = widget.destination;
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
      (dynamic data) async {
        if (data != null)
          await updateUI(latitude1: data.latitude, longitude1: data.longitude);
      },
    );
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void onStop() {
    BackgroundLocator.unRegisterLocationUpdate();
    setState(() {
      isRunning = false;
//      lastTimeLocation = null;
//      lastLocation = null;
    });
  }

  onStart() async {
    await _checkLocationPermission();
    print(permission);
    if (permission == PermissionStatus.granted) {
      _startLocator();
      setState(() {
        isRunning = true;
        lastTimeLocation = null;
        lastLocation = null;
      });
    } else {
      // show error
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_arrived);
    return Container();
  }

  Future<void> updateUI(
      {@required double latitude1, @required double longitude1}) async {
    print("data is updating\n\n\n\n");

    var tmpLoc = WayPoint(
        name: _origin.name,
        latitude: _origin.latitude,
        longitude: _origin.longitude);
    _origin = WayPoint(
        name: "Origin", latitude: latitude1, longitude: longitude1);
    globalOrginLocation = _origin;

    if (tmpLoc.latitude != _origin.latitude &&
        tmpLoc.longitude != _origin.longitude)
      setState(() {
        if (latitude1 != null && longitude1 != null) {
          lastLocation = LocationDto.fromJson(
              {"latitude": latitude1, "longitude": longitude1});
          lastTimeLocation = DateTime.now();
        }
      });

    if (widget.isFromDetail != null && widget.isFromDetail == true) {
      await _directions.startNavigation(
          origin: _origin,
          destination: _destination,
          simulateRoute: true,
          mode: MapBoxNavigationMode.drivingWithTraffic,
          language: "German",
          units: VoiceUnits.metric);
    }
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isRegisterLocationUpdate();
    setState(() {
      isRunning = _isRunning;
    });
    print('Running ${isRunning.toString()}');
    _directions = MapboxNavigation(onRouteProgress: (arrived) async {
      _distanceRemaining = await _directions.distanceRemaining;
      _durationRemaining = await _directions.durationRemaining;

      setState(() {
        _arrived = arrived;
      });
      if (arrived) {
        await Future.delayed(Duration(seconds: 3));
        //await _directions.finishNavigation();
      }
    });

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _directions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<bool> _checkLocationPermission() async {
    permission = await LocationPermissions().checkPermissionStatus();
    var _serviceEnabled = await LocationPermissions().checkServiceStatus();
    if (_serviceEnabled == ServiceStatus.disabled) {
      showLocationAlert();
    }
    switch (permission) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        permission = await LocationPermissions().requestPermissions();
        if (permission == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
        break;
      case PermissionStatus.granted:
        return true;
        break;
      default:
        return false;
        break;
    }
  }

  void _startLocator() {
    Map<String, dynamic> data = {'countInit': 1};
    print("registerrred");
    BackgroundLocator.registerLocationUpdate(
      LocationCallbackHandler.callback,
      initCallback: LocationCallbackHandler.initCallback,
      initDataCallback: data,
/*
        Comment initDataCallback, so service not set init variable,
        variable stay with value of last run after unRegisterLocationUpdate
 */
      disposeCallback: LocationCallbackHandler.disposeCallback,
      // androidNotificationCallback: LocationCallbackHandler.notificationCallback,
      // settings: LocationSettings(
      //     notificationTitle: "Location Tracking",
      //     notificationMsg: "Tracking location in background",
      //     wakeLockTime: 20,
      //     autoStop: false,
      //     interval: 5),
    );
  }

  showLocationAlert() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Enable Location",
      desc: "Please Enable Location On your Smartphone.",
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Go to Setting",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => LocationPermissions()
              .openAppSettings()
              .then((value) => Navigator.pop(context)),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  setPolylines() async {
    var result = await Dio().get(
        "https://api.mapbox.com/v4/directions/mapbox.driving/${_origin.longitude},${_origin.latitude};${_destination.longitude},${_destination.latitude}.json",
        queryParameters: {
          "access_token":
              "pk.eyJ1IjoiY2lzLWRldjE4MjIiLCJhIjoiY2tiMjVnMXJkMDZmaDMwczNzeTVhNzE5aCJ9.0Aca-s1saRSE7q12htLadg",
          "alternatives": false,
          "steps": false,
        });
    List<dynamic> resultFinal;
    if (result.data != null &&
        result.data['routes'] != null &&
        result.data['routes'].isNotEmpty &&
        result.data['routes'][0]['geometry']['coordinates'] != null)
      resultFinal = result.data['routes'][0]['geometry']['coordinates'];
    if (resultFinal != null && resultFinal.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      polylineCoordinates.clear();
      resultFinal.forEach((point) {
        polylineCoordinates.add(LatLng(double.parse(point[1].toString()),
            double.parse(point[0].toString())));
      });
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          width: 7,
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }
}
