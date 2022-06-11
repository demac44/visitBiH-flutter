import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
    try {
      var response = await http.post(url, body: {"region": widget.region});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw "Connection error!";
      }
    } catch (e) {
      throw "Connection error!";
    }
  }

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      appBar: AppBar(
        title: Text(
          widget.region,
          style: const TextStyle(fontSize: 25),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 51, 100),
      ),
      bottomNavigationBar: const Navbar(index: 1),
      body: Center(
        child: FutureBuilder(
          future: futureData,
          builder: (context, snaphsot) {
            if (snaphsot.hasData) {
              if (snaphsot.data != null) data = snaphsot.data;
              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: 0, left: 5.0, right: 5.0, bottom: 10.0),
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
                                    borderRadius: BorderRadius.circular(10.0)),
                                width: double.infinity,
                                height: 300,
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
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
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Place get widget => super.widget;
  late Future<void> futureData;

  int currentIndex = 1;
  var data;

  Future<dynamic> fetchData() async {
    var url = Uri.parse('http://www.visitbosna.com/api/places/place');
    try {
      var response = await http.post(url, body: {"id": widget.placeId});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw "Connection error!";
      }
    } catch (e) {
      throw "Connection error!";
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
        backgroundColor: const Color.fromARGB(255, 28, 51, 100),
      ),
      bottomNavigationBar: const Navbar(index: 1),
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

                List<String> imgs = [];

                for (var image in images) {
                  imgs.add(image["image"]);
                }

                return Column(
                  children: [
                    const SizedBox(height: 10),
                    CarouselSlider(
                      carouselController: _controller,
                      items: imgs
                          .map((img) => Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: AlignmentDirectional.topEnd,
                                  end: AlignmentDirectional.bottomStart,
                                  colors: [
                                    Color.fromARGB(255, 211, 211, 211),
                                    Color.fromARGB(255, 241, 241, 241),
                                  ],
                                ),
                                color: Colors.white,
                                image: DecorationImage(
                                    image: NetworkImage(img),
                                    fit: BoxFit.cover),
                              )))
                          .toList(),
                      options: CarouselOptions(
                          height: 300,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.97,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 6),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 1000),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgs.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.6 : 0.2)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
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
                        child: Text(language == "english"
                            ? "OPEN IN GOOGLE MAPS"
                            : "OTVORI U GOOGLE MAPS"),
                      ),
                    )
                  ],
                );
              } else if (snaphsot.hasError) {
                return Text("${snaphsot.error}");
              }
              return Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height - 150,
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
