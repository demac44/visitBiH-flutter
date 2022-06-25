import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  int currentIndex = 3;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool messageSent = false;

  void _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) throw 'Error opening $_url';
  }

  Future<dynamic> _sendMessage(message) async {
    var url = Uri.parse('http://www.visitbosna.com/api/message/new');
    try {
      var response = await http.post(url, body: {"msg": message});
      if (response.statusCode == 200) {
        setState(() {
          messageSent = true;
        });
      } else {
        throw "Network connection error!";
      }
    } catch (e) {
      throw "Network connection error!";
    }
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.web, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          language == "english" ? "WEBSITE" : "WEB STRANICA",
                          style: const TextStyle(
                              fontSize: 26, color: Colors.white),
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
                                style: const TextStyle(fontSize: 16),
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          Text(
                            language == "english"
                                ? "SEND MESSAGE"
                                : "POŠALJI PORUKU",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          if (messageSent)
                            Text(
                              language == "english"
                                  ? "Message sent!"
                                  : "Poruka poslana!",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          const SizedBox(height: 10),
                          Container(
                            color: Colors.black12,
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  hintText: language == "english"
                                      ? 'Message'
                                      : "Poruka",
                                  contentPadding: const EdgeInsets.all(5.0),
                                ),
                                style: const TextStyle(color: Colors.white),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return;
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (String value) {
                                  _sendMessage(value);
                                  Timer(const Duration(seconds: 3), () {
                                    setState(() {
                                      messageSent = false;
                                    });
                                  });
                                  _formKey.currentState?.reset();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
