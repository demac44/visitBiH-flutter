import 'package:flutter/material.dart';
import "interactive_map.dart";
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'about.dart';

class Articles extends StatefulWidget {
  const Articles({Key? key}) : super(key: key);

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  late Future<void> futureData;

  int currentIndex = 2;
  var data;

  Future<dynamic> fetchData() async {
    var url = Uri.parse('http://www.visitbosna.com/api/articles/all');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw "Network connection error!";
      }
    } catch (e) {
      throw "Network connection error!";
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
      appBar: AppBar(
        title: Text(
          language == "english" ? "Read more" : "Čitaj više",
          style: const TextStyle(fontSize: 25),
        ),
        backgroundColor: const Color.fromARGB(255, 139, 35, 35),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const Navbar(index: 2),
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
                                builder: (context) => Article(
                                  ArticleId: item["_id"],
                                  ArticleName: item?["title"]?[language] ?? "",
                                ),
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
                                      image: NetworkImage(item["card_image"] ??
                                          "https://res.cloudinary.com/de5mm13ux/image/upload/v1655060804/Website%20assets/default-thumbnail_elipwk.jpg"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Center(
                                  child: Text(
                                    item["title"]?[language] ?? "",
                                    style: const TextStyle(
                                      fontSize: 30,
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

class Article extends StatefulWidget {
  const Article({Key? key, required this.ArticleId, required this.ArticleName})
      : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final ArticleId;
  final ArticleName;

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Article get widget => super.widget;
  late Future<void> futureData;

  int currentIndex = 2;
  var data;
  int imagesIndex = 0;

  Future<dynamic> fetchData() async {
    var url = Uri.parse('http://www.visitbosna.com/api/articles/article');
    try {
      var response = await http.post(url, body: {"id": widget.ArticleId});
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw "Network connection error!";
      }
    } catch (e) {
      throw "Network connection error!";
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(widget.ArticleName),
        backgroundColor: const Color.fromARGB(255, 139, 35, 35),
      ),
      bottomNavigationBar: const Navbar(index: 2),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          width: double.infinity,
          child: FutureBuilder(
            future: futureData,
            builder: (context, snaphsot) {
              if (snaphsot.hasData) {
                if (snaphsot.data != null) data = snaphsot.data;
                var sections = data?["sections"] ?? [];

                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          foregroundDecoration: const BoxDecoration(
                            color: Colors.black38,
                          ),
                          width: double.infinity,
                          height: 350,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(data["card_image"] ??
                                    "https://res.cloudinary.com/de5mm13ux/image/upload/v1655060804/Website%20assets/default-thumbnail_elipwk.jpg"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: Center(
                            child: Text(
                              data["title"]?[language] ?? "",
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            data["intro_title"]?[language] ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 25),
                          ),
                          const SizedBox(height: 15.0),
                          Text(
                            data["intro_text"]?[language] ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    for (var section in sections)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: const Color.fromARGB(255, 242, 242, 242),
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Column(children: [
                          Text(
                            section[language]?["section_title"] ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 25),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            section[language]?["section_text"] ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 20.0),
                          Image.network(section["section_image"] ??
                              "https://res.cloudinary.com/de5mm13ux/image/upload/v1655060804/Website%20assets/default-thumbnail_elipwk.jpg"),
                          const SizedBox(height: 10.0),
                          Text(
                            section[language]?["section_image_description"] ??
                                "",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ]),
                      ),
                    const SizedBox(height: 30.0)
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
