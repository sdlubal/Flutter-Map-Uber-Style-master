//https://stackoverflow.com/questions/62925044/unhandled-exception-type-listdynamic-is-not-a-subtype-of-type-mapstring/62926377#62926377

// ignore_for_file: prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'navigation_screen.dart';
import 'dart:convert';

List<BreweryModel> breweryModelFromJson(String str) =>
    List<BreweryModel>.from(
        json.decode(str).map((x) => BreweryModel.fromJson(x)));

String breweryModelToJson(List<BreweryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BreweryModel {
  String srlno = "";
  String busy = "";
  String deviceID = "";
  String deviceType = "";
  String fuel = "";
  String fuelinlitere = "";
  String fuelqty = "";
  String ignitionStatus = "";
  String latitude = "";
  String loaded = "";
  String loadedMtons = "";
  String longitude = "";
  String datetimestamp = "";
  BreweryModel({
    required this.srlno,
    required this.busy,
    required this.deviceID,
    required this.deviceType,
    required this.fuel,
    required this.fuelinlitere,
    required this.fuelqty,
    required this.ignitionStatus,
    required this.latitude,
    required this.loaded,
    required this.loadedMtons,
    required this.longitude,
    required this.datetimestamp
  });

  factory BreweryModel.fromJson(Map<String, dynamic> json) {
    return BreweryModel(
        srlno: json['srlno'],
        busy: json['busy'],
        deviceID: json['deviceID'],
        deviceType: json['deviceType'],
        fuel: json['fuel'],
        fuelinlitere: json['fuelinlitere'],
        fuelqty: json['fuelqty'],
        ignitionStatus: json['ignitionStatus'],
        latitude: json['latitude'],
        loaded: json['loaded'],
        loadedMtons: json['loadedMtons'],
        longitude: json['longitude'],
        datetimestamp: json['datetimestamp']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['srlno'] = srlno;
    data['busy'] = busy;
    data['deviceID'] = deviceID;
    data['deviceType'] = deviceType;
    data['fuel'] = fuel;
    data['fuelinlitere'] = fuelinlitere;
    data['fuelqty'] = fuelqty;
    data['ignitionStatus'] = ignitionStatus;
    data['latitude'] = latitude;
    data['loaded'] = loaded;
    data['loadedMtons'] = loadedMtons;
    data['longitude'] = longitude;
    data['datetimestamp'] = datetimestamp;

    return data;
  }
}

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Brewery(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: true, // to be placed after home page
    );
  }
}

class Network {
  Future<List<BreweryModel>> getBreweryModel() async {
     var url = 'http://bigdatainfotech.com/flutter/amptoltrs1.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      //   print('response.body   = ');

      //   print(response.body);

      return breweryModelFromJson(response.body);
    } else {
      throw Exception('Error getting brewery');
    }
  }
}

class Brewery extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  Brewery({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _BreweryState createState() => _BreweryState();
}

class _BreweryState extends State<Brewery> {
  late Future<List<BreweryModel>> breweryObject;

  @override
  void initState() {
    super.initState();

    breweryObject = Network().getBreweryModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Date/timewise fuel & latitude/longitude"),
        ),
        body: FutureBuilder(
            future: breweryObject,
            builder: (context, AsyncSnapshot<List<BreweryModel>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('none');
                case ConnectionState.waiting:
                  // ignore: unnecessary_const
                  return const Center(child: const CircularProgressIndicator());
                case ConnectionState.active:
                  return const Text('');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 1.0,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 1.0,
                                  bottom: 1.0,
                                  left: 1.0,
                                  right: 1.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data![index].srlno.toString(),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      snapshot.data![index].datetimestamp
                                          .toString(),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      snapshot.data![index].fuelqty.toString(),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      snapshot.data![index].latitude.toString(),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      snapshot.data![index].longitude
                                          .toString(),
                                    ),
                                    const SizedBox(width: 10),

                                    SizedBox(
                                        width: 50.0,
                                        height: 25.0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => NavigationScreen(
                                                double.parse(snapshot.data![index].latitude),
                                                double.parse(snapshot.data![index].longitude),
                                              ),
                                            ));
                                          },
                                          child: const Icon(
                                            Icons.location_pin,
                                          ),
                                        ),
                                      ),
                                  ],
                                  ),
                                ),
                              ),
                            );

                        });
                  }
              }
            }));
  }
}