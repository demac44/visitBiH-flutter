import 'package:flutter/material.dart';
import 'interactive_map.dart';
import "articles.dart";
import 'about.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin fltNotification;

  // void pushFCMtoken() async {
  //   String? token = await messaging.getToken();
  // }

  @override
  void initState() {
    super.initState();
    initMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          child: Center(
              child:
                  Image.asset("assets/images/logo-visitbih.png", height: 50)),
        ),
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: const Navbar(index: 0),
      body: const Home(),
    );
  }

  void initMessaging() {
    var androidInit =
        const AndroidInitializationSettings('mipmap/launcher_icon');
    var iosInit = const IOSInitializationSettings();
    var initSetting =
        InitializationSettings(android: androidInit, iOS: iosInit);
    fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification.initialize(initSetting);
    var androidDetails = const AndroidNotificationDetails(
        '1', 'notification-channel',
        channelDescription: 'channelDescription');
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          fltNotification.show(notification.hashCode, notification.title,
              notification.body, generalNotificationDetails);
        }
      },
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
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight * 2),
        color: const Color.fromARGB(255, 61, 123, 177),
        padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 30,
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
            const SizedBox(height: 30),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const InteractiveMap(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ));
                },
                child: Image.asset("assets/images/map-3d-connect.png",
                    width: MediaQuery.of(context).size.width)),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width - 60,
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
                    side: const BorderSide(
                        width: 1.0, color: Color.fromARGB(255, 49, 49, 49))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.explore),
                    const SizedBox(width: 5),
                    Text(
                      language == "english"
                          ? "START EXPLORING"
                          : "ZAPOČNI ISTRAŽIVANJE",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width - 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LatestArticles(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(0, 255, 255, 255),
                    side: const BorderSide(
                        width: 1.0, color: Color.fromARGB(255, 50, 50, 50))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.newspaper),
                    const SizedBox(width: 5),
                    Text(
                      language == "english"
                          ? "READ MORE ABOUT B&H"
                          : "ČITAJ VIŠE O BIH",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
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
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
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
            backgroundColor: const Color.fromARGB(255, 139, 35, 35)),
        const BottomNavigationBarItem(
          label: "Info",
          icon: Icon(
            Icons.info,
            size: 25,
          ),
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
        ),
      ],
      currentIndex: widget.index,
      onTap: (int index) {
        setState(() {
          if (index == 0) {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const App(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ));
          } else if (index == 1) {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const InteractiveMap(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ));
          } else if (index == 2) {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const LatestArticles(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ));
          } else if (index == 3) {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const About(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ));
          }
        });
      },
    );
  }
}
