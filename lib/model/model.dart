import 'package:flutter/material.dart';

class User {
  final String username;
  final double balance;

  const User({
    required this.username,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'balance': balance,
    };
  }
}

class History {
  final DateTime time;
  final double balanceusage;
  final String category;

  const History({
    required this.time,
    required this.balanceusage,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'balanceusage': balanceusage,
      'category': category,
    };
  }
}

class ReaderData {
  final String title;
  final String subtitle;
  final String link;
  final String imglink;

  ReaderData({
    required this.title,
    required this.subtitle,
    required this.link,
    required this.imglink,
  });
  @override
  String toString() {
    return '$title - $subtitle - $link - $imglink';
  }
}

List dropdownCategories = [
  "Groceries",
  "Housing & Utilities",
  "Transportation",
  "Healthcare",
  "Personal / Other",
  "Online services",
];

const Map<String, IconData> trailingIcon = {
  "Groceries": Icons.local_grocery_store_sharp,
  "Housing & Utilities": Icons.house_outlined,
  "Transportation": Icons.emoji_transportation,
  "Healthcare": Icons.health_and_safety_outlined,
  "Personal / Other": Icons.category_rounded,
  "Online services": Icons.wifi,
};
