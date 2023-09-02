import 'dart:convert';

import 'package:html/parser.dart' as parser;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet_app/model/model.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

import '../components/appbar.dart';

class BookShopping extends StatefulWidget {
  const BookShopping({super.key});
  @override
  State<StatefulWidget> createState() => _BookShoppingState();
}

class _BookShoppingState extends State<BookShopping> {
  final Xml2Json xml2json = Xml2Json();
  List<Books> books = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future fetchNews() async {
    final url = Uri.parse('https://www.fahasa.com/sach-trong-nuoc.html');
    final res = await http.get(url);
    List<Books> tempBooks = [];
    if (res.statusCode == 200) {
      var document = parser.parse(res.body);
      var bookDivs = document.getElementsByClassName("ma-box-content");
      for (int i = 0; i < bookDivs.length; i++) {
        var imgdiv = bookDivs[i]
            .getElementsByClassName('product images-container')[0]
            .querySelectorAll('a')[0];

        tempBooks.add(Books(
          title: imgdiv.attributes['title'].toString(),
          price: bookDivs[i]
              .getElementsByClassName('price-label')[0]
              .querySelectorAll('span > span > p > span')[0]
              .innerHtml
              .replaceAll('&nbsp;đ', ''),
          link: imgdiv.attributes['href'].toString(),
          imglink: imgdiv
              .querySelectorAll('span > img')[0]
              .attributes['data-src']
              .toString(),
        ));
        print(tempBooks[0].imglink);
        setState(() {
          books = tempBooks;
        });
      }
    }
  }

  _redirectURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    }
  }

  @override
  Widget build(Object context) {
    return SafeArea(
      child: GestureDetector(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Top books from Fahasa"),
          ),
          body: ListView(
            children: [
              for (var e in books) ...{
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white)),
                  child: ListTile(
                    onTap: () {
                      _redirectURL(e.link);
                    },
                    contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    titleAlignment: ListTileTitleAlignment.top,
                    subtitle: GestureDetector(
                      child: Image.network(
                        e.imglink,
                        height: 300,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    title: Column(
                      children: [
                        Text(e.title.toString(),
                            style: const TextStyle(fontSize: 18)),
                        const Padding(padding: EdgeInsets.all(10)),
                        Text(
                          "VND ${e.price}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                      ],
                    ),
                  ),
                ),
              }
            ],
          ),
          bottomNavigationBar: const BottomBar(index: 3),
        ),
      ),
    );
  }
}
