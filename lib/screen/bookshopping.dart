import 'package:html/parser.dart' as parser;

import 'package:flutter/material.dart';
import 'package:wallet_app/components/reader.dart';
import 'package:wallet_app/model/model.dart';
import 'package:http/http.dart' as http;

import '../components/appbar.dart';

class BookShopping extends StatefulWidget {
  const BookShopping({super.key});
  @override
  State<StatefulWidget> createState() => _BookShoppingState();
}

class _BookShoppingState extends State<BookShopping> {
  List<ReaderData> readerData = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future fetchNews() async {
    final url = Uri.parse('https://www.fahasa.com/sach-trong-nuoc.html');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      var document = parser.parse(res.body);
      var bookDivs = document.getElementsByClassName("ma-box-content");
      for (int i = 0; i < bookDivs.length; i++) {
        var imgdiv = bookDivs[i]
            .getElementsByClassName('product images-container')[0]
            .querySelectorAll('a')[0];
        setState(() {
          readerData.add(ReaderData(
            title: imgdiv.attributes['title'].toString(),
            subtitle: bookDivs[i]
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
        });
      }
    }
  }

  @override
  Widget build(Object context) {
    return SafeArea(
      child: GestureDetector(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("Top books this weeks"),
          ),
          body: Reader(readerData: readerData),
          bottomNavigationBar: const BottomBar(index: 3),
        ),
      ),
    );
  }
}
