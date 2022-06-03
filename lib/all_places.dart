import 'package:flutter/material.dart';
import "interactive_map.dart";
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import "place.dart";

class AllPlaces extends StatefulWidget {
  const AllPlaces({Key? key, required this.region}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final region;

  @override
  State<AllPlaces> createState() => _AllPlacesState();
}

class _AllPlacesState extends State<AllPlaces> {
  @override
  AllPlaces get widget => super.widget;
  late Future<void> futureData;

  int currentIndex = 1;
  var data;

  Future<dynamic> fetchData() async {
    var url = Uri.parse('http://www.visitbosna.com/api/places/region');
    var response = await http.post(url, body: {"region": widget.region});
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 226, 226, 226),
      appBar: AppBar(
        title: Text(
          widget.region,
          style: const TextStyle(fontSize: 25),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 51, 100),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(
              Icons.home,
              size: 25,
            ),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            label: "Explore",
            icon: Icon(
              Icons.explore,
              size: 30,
            ),
            backgroundColor: Color.fromARGB(255, 28, 51, 100),
          ),
          BottomNavigationBarItem(
            label: "Read more",
            icon: Icon(
              Icons.newspaper,
              size: 25,
            ),
          ),
          BottomNavigationBarItem(
            label: "Info",
            icon: Icon(
              Icons.info,
              size: 25,
            ),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            if (index == 0) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => App()));
            } else if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InteractiveMap()));
            }
          });
        },
      ),
      body: Center(
        child: FutureBuilder(
          future: futureData,
          builder: (context, snaphsot) {
            if (snaphsot.hasData) {
              if (snaphsot.data != null) data = snaphsot.data;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    for (var item in data)
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Place(
                                    placeId: item["_id"],
                                    placeName: item["name"]["english"],
                                    appBarName: item["name"][language]),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                foregroundDecoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(20.0)),
                                width: double.infinity,
                                height: 300,
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  image: DecorationImage(
                                      image: NetworkImage(item["card_img"]),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Center(
                                  child: Text(
                                    item["name"][language],
                                    style: const TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else if (snaphsot.hasError) {
              return Text("${snaphsot.error}");
            }
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Image.asset(
                  'assets/images/loader-waiting.gif',
                  width: 200,
                  height: 200,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
