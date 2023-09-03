import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wallet_app/components/reader.dart';
import 'package:wallet_app/model/model.dart';
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
  List<ReaderData> readerData = [];

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
    var news = data['rss']['channel']['item'];
    for (var n in news) {
      String temp = n['description']['__cdata'];
      temp = temp.substring(temp.indexOf('src="'), temp.indexOf('></a>'));
      temp = temp.substring(temp.indexOf('"') + 1, temp.indexOf('" '));

      setState(() {
        readerData.add(ReaderData(
          title: utf8.decode(n['title']['\$t'].toString().codeUnits),
          subtitle: utf8.decode(n['pubDate']['\$t'].toString().codeUnits),
          link: n['link']['\$t'].toString(),
          imglink: temp,
        ));
      });
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
          body: Reader(readerData: readerData),
          bottomNavigationBar: const BottomBar(index: 2),
        ),
      ),
    );
  }
}
