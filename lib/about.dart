import 'package:flutter/material.dart';
import 'interactive_map.dart';
import "articles.dart";
import 'main.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  int currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: const Color.fromARGB(255, 156, 21, 21),
        automaticallyImplyLeading: false,
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
            backgroundColor: Color.fromARGB(255, 31, 41, 114),
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
              backgroundColor: Color.fromARGB(255, 156, 21, 21)),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(
            () {
              if (index == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const App()));
              } else if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InteractiveMap()));
              } else if (index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Articles()));
              } else if (index == 3) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const About()));
              }
            },
          );
        },
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(language == "english" ? "ABOUT" : "O STRANICI"),
            Text(
              language == "english"
                  ? "This website is made to introduce the beautiful country of Bosnia and Herzegovina, it's breathtaking and diverse nature, rich history and kind and welcoming people. Bosnia and Herzegovina is not being promoted enough and is often being misrepresented, so I hope this website will make a difference in representing it in a way it should be."
                  : "Ova web stranica je napravljena da predstavi prelijepu zemlju Bosnu i Hercegovinu, njenu prekrasnu i raznoliku prirodu, bogatu historiju i ljubazne i gostoljubive ljude. Bosna i Hercegovina je nedovoljno ispromovirana i često se predstavlja na pogrešan način, pa se nadam da će ova stranica napraviti promjenu u tome da se predstavlja i promoviše na način na koji bi trebala biti.",
            ),
            Text(language == "english" ? "CONTACT" : "KONTAKT"),
            Row(
              children: const [Icon(Icons.email), Text("bihexplore@gmail.com")],
            )
          ],
        ),
      ),
    );
  }
}
