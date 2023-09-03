import 'package:flutter/material.dart';
import 'package:wallet_app/model/model.dart';
import 'package:url_launcher/url_launcher.dart';

class Reader extends StatelessWidget {
  final List<ReaderData> readerData;

  const Reader({
    super.key,
    required this.readerData,
  });

  _redirectURL(String url) async {
    Uri uri = Uri.parse(url);
    launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var data in readerData) ...{
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white)),
            child: ListTile(
              onTap: () {
                _redirectURL(data.link);
              },
              contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              titleAlignment: ListTileTitleAlignment.top,
              subtitle: GestureDetector(
                child: Image.network(
                  data.imglink,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
              title: Column(
                children: [
                  Text(data.title, style: const TextStyle(fontSize: 24)),
                  const Padding(padding: EdgeInsets.all(10)),
                  Text(data.subtitle, style: const TextStyle(fontSize: 13)),
                  const Padding(padding: EdgeInsets.all(10)),
                ],
              ),
            ),
          ),
        }
      ],
    );
  }
}
