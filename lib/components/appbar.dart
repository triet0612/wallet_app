import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int index;

  const BottomBar({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined_outlined), label: "Report"),
        BottomNavigationBarItem(
            icon: Icon(Icons.newspaper), label: "Financial news"),
      ],
      currentIndex: index,
      onTap: (pressed) {
        if (pressed == index) {
          return;
        }
        switch (pressed) {
          case 0:
            Navigator.of(context).popAndPushNamed('/');
            break;
          case 1:
            Navigator.of(context).popAndPushNamed('/report');
            break;
          case 2:
            Navigator.of(context).popAndPushNamed('/news');
        }
      },
    );
  }
}
