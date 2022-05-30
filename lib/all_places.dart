import 'package:flutter/material.dart';
import "interactive_map.dart";
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<dynamic> fetchData() async {
  var url = Uri.parse('http://www.visitbosna.com/api/places/region');
  var response = await http.post(url, body: {"region": "Sarajevo"});
  print(response.statusCode);
  return json.decode(response.body);
}

class AllPlaces extends StatefulWidget {
  const AllPlaces({Key? key, required this.reg}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final reg;

  @override
  State<AllPlaces> createState() => _AllPlacesState();
}

class _AllPlacesState extends State<AllPlaces> {
  @override
  AllPlaces get widget => super.widget;
  late Future<void> futureData;

  int currentIndex = 1;

  var data;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Explore",
            icon: Icon(Icons.explore),
          ),
          BottomNavigationBarItem(
            label: "Info",
            icon: Icon(Icons.info),
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
              return Column(
                children: [
                  for (var item in data) Text(item["name"]["english"])
                ],
              );
            } else if (snaphsot.hasError) {
              return Text("${snaphsot.error}");
            }
            return Text("data");
          },
        ),
      ),
    );
  }
}
