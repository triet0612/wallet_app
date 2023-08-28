import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wallet_app/model/model.dart';

class DBProvider {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDB();
    return _db!;
  }

  Future initDB() async {
    String path = join(await getDatabasesPath(), 'wallet.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      singleInstance: true,
    );
    return db;
  }

  Future _onCreate(Database db, int version) async {
    const createUser = 'CREATE TABLE User(username TEXT, balance REAL);';
    const createHistory =
        'CREATE TABLE History(time TEXT, balanceusage REAL, category TEXT);';
    const populateUser =
        '''INSERT INTO User(username, balance) VALUES('user0', 0);''';

    try {
      await db.execute(createUser);
      await db.execute(createHistory);
      await db.execute(populateUser);
    } catch (e) {
      rethrow;
    }
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future<User> readUser() async {
    var dbClient = await db;
    List users = await dbClient.query("User");
    return User(
      username: users.first['username'],
      balance: users.first['balance'],
    );
  }

  List<History> mockHistory() {
    return [
      History(
        time: DateTime.now().subtract(const Duration(days: 6)),
        balanceusage: Random().nextInt(100000) + 100000,
        category: "Groceries",
      ),
      History(
        time: DateTime.now().subtract(const Duration(days: 5)),
        balanceusage: Random().nextInt(100000) + 100000,
        category: "Groceries",
      ),
      History(
        time: DateTime.now().subtract(const Duration(days: 4)),
        balanceusage: Random().nextInt(100000) + 100000,
        category: "Groceries",
      ),
      History(
        time: DateTime.now().subtract(const Duration(days: 3)),
        balanceusage: Random().nextInt(100000) + 100000,
        category: "Groceries",
      ),
      History(
        time: DateTime.now().subtract(const Duration(days: 2)),
        balanceusage: Random().nextInt(100000) + 100000,
        category: "Groceries",
      ),
      History(
        time: DateTime.now().subtract(const Duration(days: 1)),
        balanceusage: Random().nextInt(100000) + 100000,
        category: "Groceries",
      ),
      History(
        time: DateTime.now(),
        balanceusage: Random().nextInt(100000) + 100000,
        category: "Groceries",
      ),
    ];
  }
}
