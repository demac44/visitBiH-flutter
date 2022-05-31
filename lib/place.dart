import 'package:flutter/material.dart';
import "main.dart";
import "interactive_map.dart";

class Place extends StatefulWidget {
  const Place({Key? key, required this.placeName, this.placeRegion})
      : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final placeName;
  // ignore: prefer_typing_uninitialized_variables
  final placeRegion;

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  int currentIndex = 1;

  @override
  Place get widget => super.widget;

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(
              Icons.home,
              size: 25,
            ),
          ),
          BottomNavigationBarItem(
            label: "Explore",
            icon: Icon(
              Icons.explore,
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
      body: Center(child: Text(widget.placeName + " " + widget.placeRegion)),
    );
  }
}
