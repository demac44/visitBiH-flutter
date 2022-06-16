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
    if (!await launchUrl(_url)) throw 'Error opening $_url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Navbar(index: 3),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight),
          color: const Color.fromARGB(255, 61, 123, 177),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(language == "english" ? "ABOUT" : "O STRANICI",
                          style: const TextStyle(
                              fontSize: 26, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    language == "english"
                        ? "This website is made to introduce the beautiful country of Bosnia and Herzegovina, it's breathtaking and diverse nature, rich history and kind and welcoming people. Bosnia and Herzegovina is not being promoted enough and is often being misrepresented, so I hope this website will make a difference in representing it in a way it should be."
                        : "Ova web stranica je napravljena da predstavi prelijepu zemlju Bosnu i Hercegovinu, njenu prekrasnu i raznoliku prirodu, bogatu historiju i ljubazne i gostoljubive ljude. Bosna i Hercegovina je nedovoljno ispromovirana i često se predstavlja na pogrešan način, pa se nadam da će ova stranica napraviti promjenu u tome da se predstavlja i promoviše na način na koji bi trebala biti.",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.web, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "WEBSITE",
                          style: TextStyle(fontSize: 26, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "www.visitbosna.com",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 150,
                            child: ElevatedButton(
                              onPressed: () =>
                                  {_launchUrl("http://www.visitbosna.com/")},
                              child: Text(
                                language == "english"
                                    ? "OPEN IN BROWSER"
                                    : "OTVORI U PRETRAŽIVAČU",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(
                    top: 20.0, bottom: 20.0, left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.contact_page_outlined,
                            color: Colors.white),
                        const SizedBox(width: 15),
                        Text(language == "english" ? "CONTACT" : "KONTAKT",
                            style: const TextStyle(
                                fontSize: 26, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
        ),
      ),
    );
  }
}
