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
