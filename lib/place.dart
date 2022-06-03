import 'package:flutter/material.dart';
import "main.dart";
import "interactive_map.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class Place extends StatefulWidget {
  const Place(
      {Key? key, required this.placeId, this.placeName, this.appBarName})
      : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final placeId;
  final placeName;
  final appBarName;

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  @override
  Place get widget => super.widget;
  late Future<void> futureData;

  int currentIndex = 1;
  var data;
  int imagesIndex = 0;

  Future<dynamic> fetchData() async {
    var url = Uri.parse('http://www.visitbosna.com/api/places/place');
    var response = await http.post(url, body: {"id": widget.placeId});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error fetching data!");
    }
  }

  void _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(widget.appBarName),
        backgroundColor: const Color.fromARGB(255, 37, 98, 62),
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
            backgroundColor: Color.fromARGB(255, 37, 98, 62),
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
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          width: double.infinity,
          child: FutureBuilder(
            future: futureData,
            builder: (context, snaphsot) {
              if (snaphsot.hasData) {
                if (snaphsot.data != null) data = snaphsot.data;

                var images = data[0]["images"];

                return Column(
                  children: [
                    Container(
                      height: 350,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        image: DecorationImage(
                            image: NetworkImage(
                              data[0]["images"][imagesIndex]["image"],
                            ),
                            fit: BoxFit.cover),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (imagesIndex == 0) {
                                  imagesIndex = images.length - 1;
                                } else {
                                  imagesIndex--;
                                }
                              });
                            },
                            child: Container(
                              height: 350,
                              width: 40,
                              color: const Color.fromARGB(100, 0, 0, 0),
                              child: const Icon(
                                Icons.arrow_left,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 80),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (imagesIndex == images.length - 1) {
                                  imagesIndex = 0;
                                } else {
                                  imagesIndex++;
                                }
                              });
                            },
                            child: Container(
                              height: 350,
                              width: 40,
                              color: const Color.fromARGB(100, 0, 0, 0),
                              child: const Icon(
                                Icons.arrow_right,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        data[0]["description"][language],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 31, 31, 31)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 242, 190, 0))),
                        onPressed: () => {
                          _launchUrl(data[0]["location"]["google_maps_link"])
                        },
                        child: const Text("OPEN IN GOOGLE MAPS"),
                      ),
                    )
                  ],
                );
              } else if (snaphsot.hasError) {
                return Text("${snaphsot.error}");
              }
              return Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height - 100,
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
      ),
    );
  }
}
