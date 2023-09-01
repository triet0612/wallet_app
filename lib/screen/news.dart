import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

import '../components/appbar.dart';

class NewsReader extends StatefulWidget {
  const NewsReader({super.key});
  @override
  State<StatefulWidget> createState() => _NewsReaderState();
}

class _NewsReaderState extends State<NewsReader> {
  final Xml2Json xml2json = Xml2Json();
  List news = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future fetchNews() async {
    final url = Uri.parse("https://vnexpress.net/rss/kinh-doanh.rss");
    final res = await http.get(url);
    xml2json.parse(res.body.toString());
    var jsonData = xml2json.toGData();
    var data = json.decode(jsonData);
    setState(() {
      news = data['rss']['channel']['item'];
      for (var n in news) {
        String temp = n['description']['__cdata'];
        temp = temp.substring(temp.indexOf('src="'), temp.indexOf('></a>'));
        temp = temp.substring(temp.indexOf('"') + 1, temp.indexOf('" '));
        n['img'] = temp;
      }
    });
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
            title: const Text("Economic News"),
          ),
          body: ListView(
            children: [
              for (var e in news) ...{
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white)),
                  child: ListTile(
                    onTap: () {
                      _redirectURL(e['link']['\$t'].toString());
                    },
                    contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    titleAlignment: ListTileTitleAlignment.top,
                    subtitle: GestureDetector(
                      child: Image.network(
                        e['img'],
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    title: Column(
                      children: [
                        Text(
                            utf8.decode(e['title']['\$t'].toString().codeUnits),
                            style: const TextStyle(fontSize: 24)),
                        const Padding(padding: EdgeInsets.all(10)),
                        Text(
                          utf8.decode(e['pubDate']['\$t'].toString().codeUnits),
                          style: const TextStyle(fontSize: 13),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                      ],
                    ),
                  ),
                ),
              }
            ],
          ),
          bottomNavigationBar: const BottomBar(index: 2),
        ),
      ),
    );
  }
}
