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

class Books {
  final String title;
  final String price;
  final String link;
  final String imglink;

  Books({
    required this.title,
    required this.price,
    required this.link,
    required this.imglink,
  });
  @override
  String toString() {
    return '$title - $price - $link - $imglink';
  }
}
