import 'package:flutter/material.dart';
import 'interactive_map.dart';
import "articles.dart";
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  int currentIndex = 3;

  void _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const Navbar(index: 3),
      body: Container(
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info, color: Colors.white),
                const SizedBox(width: 15),
                Text(language == "english" ? "ABOUT" : "O STRANICI",
                    style: const TextStyle(fontSize: 26, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              language == "english"
                  ? "This website is made to introduce the beautiful country of Bosnia and Herzegovina, it's breathtaking and diverse nature, rich history and kind and welcoming people. Bosnia and Herzegovina is not being promoted enough and is often being misrepresented, so I hope this website will make a difference in representing it in a way it should be."
                  : "Ova web stranica je napravljena da predstavi prelijepu zemlju Bosnu i Hercegovinu, njenu prekrasnu i raznoliku prirodu, bogatu historiju i ljubazne i gostoljubive ljude. Bosna i Hercegovina je nedovoljno ispromovirana i često se predstavlja na pogrešan način, pa se nadam da će ova stranica napraviti promjenu u tome da se predstavlja i promoviše na način na koji bi trebala biti.",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 40),
            Row(children: const [
              Icon(Icons.web, color: Colors.white),
              SizedBox(width: 15),
              Text("WEBSITE",
                  style: TextStyle(fontSize: 26, color: Colors.white)),
            ]),
            const SizedBox(height: 20),
            const Text("visitbosna.com",
                style: TextStyle(fontSize: 20, color: Colors.white)),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => {_launchUrl("http://www.visitbosna.com/")},
              child: Text(language == "english"
                  ? "OPEN IN BROWSER"
                  : "OTVORI U PRETRAŽIVAČU"),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                const Icon(Icons.contact_page_outlined, color: Colors.white),
                const SizedBox(width: 15),
                Text(language == "english" ? "CONTACT" : "KONTAKT",
                    style: const TextStyle(fontSize: 26, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Icon(Icons.email, size: 20, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  "bihexplore@gmail.com",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
