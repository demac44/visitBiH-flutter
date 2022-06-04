import 'package:flutter/material.dart';
import 'interactive_map.dart';
import "articles.dart";
import 'about.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: App(),
  ));
}

String language = "english";

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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            label: "Explore",
            icon: Icon(
              Icons.explore,
              size: 25,
            ),
            backgroundColor: Color.fromARGB(255, 48, 83, 49),
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
            backgroundColor: Color.fromARGB(255, 48, 83, 49),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
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
          });
        },
      ),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                foregroundDecoration:
                    const BoxDecoration(color: Colors.black54),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/cilim.jpg"),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  language == "english"
                                      ? language = "bosnian"
                                      : language = "english";
                                });
                              },
                              child: Text(
                                language == "english" ? "BOSANSKI" : "ENGLISH",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        language == "english"
                            ? "The Heart-Shaped Land: Bosnia and Herzegovina"
                            : "Zemlja srcolikog oblika: Bosna i Hercegovina",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 35),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        language == "english"
                            ? "Bosnia and Herzegovina lies in the heart of Southeast Europe. It is here that eastern and western civilizations met, sometimes clashed, but more often enriched and reinforced each other throughout its long and fascinating history. Here, the most interesting and attractive sites are a wonderful mix of this tiny country's cultural and natural heritage."
                            : "Bosna i Hercegovina se nalazi u srcu jugoistočne Evrope. Tu su se susrele istočna i zapadna civilizacija, ponekad sukobljavale, ali češće obogaćivale i pojačavale jedna drugu kroz svoju dugu i fascinantnu historiju. Ovdje su najzanimljivije i najatraktivnije lokacije divan spoj kulturnog i prirodnog nasljeđa ove male zemlje.",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        language == "english"
                            ? 'Perhaps what is most important for the visitor to know today, though, is that Bosnia and Herzegovina is a stunningly beautiful country with a vast array of landscapes, cultures, traditions and people. And as the old cliche goes "people make the place" - and BiH prides itself on its hospitality and treating our guests as if they were family members. And family we take to heart.'
                            : 'Najvažnije je istaći da je Bosna i Hercegovina zapanjujuće lijepa zemlja sa širokim spektrom pejzaža, kultura, tradicija i ljudi. I kako stara izreka kaže "ljudi čine mjesto" - i Bosna i Hercegovina se ponosi svojim gostoprimstvom i gledanjem naših gostiju kao da su članovi porodice. A porodicu uzimamo k srcu.',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 40),
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
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 255, 162, 0))),
                          child: Text(
                            language == "english"
                                ? "START EXPLORING"
                                : "ZAPOČNI ISTRAŽIVANJE",
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 71, 94, 157))),
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
