import 'package:flutter/material.dart';
import 'interactive_map.dart';
import "articles.dart";
import 'about.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Raleway'),
    home: const App(),
  ));
}

String language = "";

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          child: Image.asset("assets/images/logo-visitbih.png"),
        ),
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: const Navbar(index: 0),
      body: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  _setLanguage(lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("language", lang);

    setState(() {
      language = lang;
    });
  }

  _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("language") != null) {
      setState(() {
        _setLanguage(prefs.getString("language")!);
      });
    } else {
      setState(() {
        _setLanguage("english");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
          colors: [
            Colors.black,
            Color.fromARGB(255, 29, 29, 29),
          ],
        ),
      ),
      padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      _setLanguage(
                          language == "english" ? "bosnian" : "english");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 0.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          color: Colors.black45),
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        language == "english" ? "BOSANSKI" : "ENGLISH",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Text(
              language == "english"
                  ? "The Heart-Shaped Land: Bosnia and Herzegovina"
                  : "Zemlja srcolikog oblika: Bosna i Hercegovina",
              style: const TextStyle(color: Colors.white, fontSize: 32),
            ),
            const SizedBox(height: 30),
            Text(
              language == "english"
                  ? "Bosnia and Herzegovina lies in the heart of Southeast Europe. It is here that eastern and western civilizations met, sometimes clashed, but more often enriched and reinforced each other throughout its long and fascinating history. Here, the most interesting and attractive sites are a wonderful mix of this tiny country's cultural and natural heritage."
                  : "Bosna i Hercegovina se nalazi u srcu jugoistočne Evrope. Tu su se susrele istočna i zapadna civilizacija, ponekad sukobljavale, ali češće obogaćivale i pojačavale jedna drugu kroz svoju dugu i fascinantnu historiju. Ovdje su najzanimljivije i najatraktivnije lokacije divan spoj kulturnog i prirodnog nasljeđa ove male zemlje.",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width - 30,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InteractiveMap(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(0, 255, 255, 255),
                    side: const BorderSide(width: 1.0, color: Colors.white)),
                child: Text(
                  language == "english"
                      ? "START EXPLORING"
                      : "ZAPOČNI ISTRAŽIVANJE",
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width - 30,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Articles(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(0, 255, 255, 255),
                    side: const BorderSide(width: 1.0, color: Colors.white)),
                child: Text(
                  language == "english"
                      ? "READ ABOUT BOSNIA AND HERZEGOVINA"
                      : "ČITAJ VIŠE O BOSNI I HERCEGOVINI",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Navbar extends StatefulWidget {
  const Navbar({Key? key, required this.index}) : super(key: key);

  final index;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  Navbar get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      items: [
        BottomNavigationBarItem(
          label: language == "english" ? "Home" : "Početna",
          icon: const Icon(
            Icons.home,
            size: 25,
          ),
          backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        ),
        BottomNavigationBarItem(
          label: language == "english" ? "Explore" : "Istraži",
          icon: const Icon(
            Icons.explore,
            size: 25,
          ),
          backgroundColor: const Color.fromARGB(255, 28, 51, 100),
        ),
        BottomNavigationBarItem(
            label: language == "english" ? "Read more" : "Čitaj više",
            icon: const Icon(
              Icons.newspaper,
              size: 25,
            ),
            backgroundColor: const Color.fromARGB(255, 105, 40, 101)),
        const BottomNavigationBarItem(
          label: "Info",
          icon: Icon(
            Icons.info,
            size: 25,
          ),
          backgroundColor: Color.fromARGB(255, 29, 29, 29),
        ),
      ],
      currentIndex: widget.index,
      onTap: (int index) {
        setState(() {
          if (index == widget.index) {
            return;
          }
          ;
          if (index == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const App()));
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
        });
      },
    );
  }
}
