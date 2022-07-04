import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class LatestArticles extends StatefulWidget {
  const LatestArticles({Key? key}) : super(key: key);

  @override
  State<LatestArticles> createState() => _LatestArticlesState();
}

class _LatestArticlesState extends State<LatestArticles> {
  late Future<void> futureData;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int currentIndex = 2;
  String category = "latest";
  var data;

  Future<dynamic> fetchData() async {
    var url = Uri.parse('http://www.visitbosna.com/api/articles/latest');
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
        title: Text(language == "english" ? "Latest" : "Najnovije"),
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
                    Container(
                      color: Colors.black12,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText:
                                language == "english" ? 'Search' : "Pretraga",
                            contentPadding: const EdgeInsets.all(5.0),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return;
                            }
                            return null;
                          },
                          onFieldSubmitted: (String value) {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          SearchArticles(query: value),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ));
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const LatestArticles(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ));
                            },
                            child: Container(
                              color: const Color.fromARGB(255, 71, 128, 123),
                              width: MediaQuery.of(context).size.width / 2 - 5,
                              height: 40,
                              child: Center(
                                child: Text(
                                  language == "english"
                                      ? "Latest"
                                      : "Najnovije",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const PopularArticles(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ));
                            },
                            child: Container(
                              color: const Color.fromARGB(255, 217, 217, 217),
                              width: MediaQuery.of(context).size.width / 2 - 5,
                              height: 40,
                              child: Center(
                                child: Text(
                                  language == "english"
                                      ? "Most read"
                                      : "Najčitanije",
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const ArticlesAd(),
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
                                        image: NetworkImage(item[
                                                "card_image"] ??
                                            "https://res.cloudinary.com/de5mm13ux/image/upload/v1655060804/Website%20assets/default-thumbnail_elipwk.jpg"),
                                        fit: BoxFit.cover)),
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

class PopularArticles extends StatefulWidget {
  const PopularArticles({Key? key}) : super(key: key);

  @override
  State<PopularArticles> createState() => _PopularArticlesState();
}

class _PopularArticlesState extends State<PopularArticles> {
  late Future<void> futureData;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int currentIndex = 2;
  String category = "popular";
  var data;

  Future<dynamic> fetchData() async {
    var url = Uri.parse('http://www.visitbosna.com/api/articles/popular');
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
          language == "english" ? "Most read" : "Najčitanije",
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
                    Container(
                      color: Colors.black12,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText:
                                language == "english" ? 'Search' : "Pretraga",
                            contentPadding: const EdgeInsets.all(5.0),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return;
                            }
                            return null;
                          },
                          onFieldSubmitted: (String value) {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          SearchArticles(query: value),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ));
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const LatestArticles(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ));
                            },
                            child: Container(
                              color: const Color.fromARGB(255, 217, 217, 217),
                              width: MediaQuery.of(context).size.width / 2 - 5,
                              height: 40,
                              child: Center(
                                child: Text(
                                  language == "english"
                                      ? "Latest"
                                      : "Najnovije",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const PopularArticles(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ));
                            },
                            child: Container(
                              color: const Color.fromARGB(255, 71, 128, 123),
                              width: MediaQuery.of(context).size.width / 2 - 5,
                              height: 40,
                              child: Center(
                                child: Text(
                                  language == "english"
                                      ? "Most read"
                                      : "Najčitanije",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const ArticlesAd(),
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
                                        image: NetworkImage(item[
                                                "card_image"] ??
                                            "https://res.cloudinary.com/de5mm13ux/image/upload/v1655060804/Website%20assets/default-thumbnail_elipwk.jpg"),
                                        fit: BoxFit.cover)),
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

class SearchArticles extends StatefulWidget {
  const SearchArticles({Key? key, required this.query}) : super(key: key);

  final query;

  @override
  State<SearchArticles> createState() => _SearchArticlesState();
}

class _SearchArticlesState extends State<SearchArticles> {
  late Future<void> futureData;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  SearchArticles get widget => super.widget;

  int currentIndex = 2;
  var data;

  Future<dynamic> fetchData() async {
    var url = Uri.parse('http://www.visitbosna.com/api/articles/search');
    try {
      var response = await http.post(url, body: {"query": widget.query});
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
          language == "english" ? "Search" : "Pretraga",
          style: const TextStyle(fontSize: 25),
        ),
        backgroundColor: const Color.fromARGB(255, 139, 35, 35),
        automaticallyImplyLeading: true,
      ),
      bottomNavigationBar: const Navbar(index: 2),
      body: FutureBuilder(
        future: futureData,
        builder: (context, snaphsot) {
          if (snaphsot.hasData) {
            if (snaphsot.data != null) data = snaphsot.data;
            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: 0, left: 5.0, right: 5.0, bottom: 10.0),
              child: Column(
                children: [
                  Container(
                    color: Colors.black12,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText:
                              language == "english" ? 'Search' : "Pretraga",
                          contentPadding: const EdgeInsets.all(5.0),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return;
                          }
                          return null;
                        },
                        initialValue: widget.query,
                        onFieldSubmitted: (String value) {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        SearchArticles(query: value),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ));
                        },
                      ),
                    ),
                  ),
                  const ArticlesAd(),
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
                                      fit: BoxFit.cover)),
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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
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
                                  image: NetworkImage(data?["card_image"] ??
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
                      ArticleAd(ad: data?["ad"]),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 5.0, right: 5.0, bottom: 20.0),
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
                          padding: const EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                          margin: const EdgeInsets.only(
                              bottom: 2.5, top: 2.5, left: 5.0, right: 5.0),
                          child: Column(children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 10,
                              color: Colors.black12,
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                section[language]?["section_title"] ?? "",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              section[language]?["section_text"] ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 20.0),
                            Image.network(
                              section["section_image"] ??
                                  "https://res.cloudinary.com/de5mm13ux/image/upload/v1655060804/Website%20assets/default-thumbnail_elipwk.jpg",
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox(height: 0);
                              },
                            ),
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
      ),
    );
  }
}

class ArticlesAd extends StatefulWidget {
  const ArticlesAd({Key? key}) : super(key: key);

  @override
  State<ArticlesAd> createState() => _ArticlesAdState();
}

class _ArticlesAdState extends State<ArticlesAd> {
  @override
  late Future<void> futureData;

  var data;

  Future<dynamic> fetchData() async {
    var url = Uri.parse('http://www.visitbosna.com/api/ads/ad/article');
    try {
      var response = await http.post(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw "Network connection error!";
      }
    } catch (e) {
      throw "Network connection error!";
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
    return FutureBuilder(
      future: futureData,
      builder: (context, snaphsot) {
        if (snaphsot.hasData) {
          if (snaphsot.data != null) data = snaphsot.data;
          if (data?["image"] != null && data?["image"] != "") {
            return GestureDetector(
              onTap: () {
                _launchUrl(data?["url"] ?? "http://www.visitbosna.com");
              },
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    color: const Color.fromARGB(255, 245, 245, 245),
                    child: Image.network(
                      data?["image"],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(height: 0);
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    color: const Color.fromARGB(255, 255, 208, 0),
                    padding: const EdgeInsets.all(3.0),
                    child: const Text("AD"),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        } else if (snaphsot.hasError) {
          return Text("${snaphsot.error}");
        } else {
          return const SizedBox(height: 0);
        }
      },
    );
  }
}

class ArticleAd extends StatefulWidget {
  const ArticleAd({Key? key, required this.ad}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final ad;

  @override
  State<ArticleAd> createState() => _ArticleAdState();
}

class _ArticleAdState extends State<ArticleAd> {
  @override
  ArticleAd get widget => super.widget;

  void _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ad?["image"] != null &&
        widget.ad?["image"] != "" &&
        widget.ad?["showAd"] == true) {
      return GestureDetector(
        onTap: () {
          _launchUrl(widget.ad?["url"] ?? "http://www.visitbosna.com");
        },
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: MediaQuery.of(context).size.width - 10,
              height: 100,
              color: const Color.fromARGB(255, 245, 245, 245),
              child: Image.network(
                widget.ad?["image"],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(height: 0);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              color: const Color.fromARGB(255, 255, 208, 0),
              padding: const EdgeInsets.all(3.0),
              child: const Text("AD"),
            )
          ],
        ),
      );
    } else {
      return const SizedBox(height: 0);
    }
  }
}
