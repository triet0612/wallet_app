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
      version: 3,
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
    const populateHistory = '''INSERT INTO History(time, balanceusage, category)
VALUES
	('2023-08-20 00:01:00', 500000, "Housing & Utilities"),
	('2023-08-22 00:02:00', 200000, "Groceries"),
	('2023-08-24 00:03:00', 2000000, "Healthcare"),
	('2023-08-24 00:04:00', 50000, "Transportation"),
	('2023-08-25 00:05:00', 1000000, "Groceries"),
	('2023-08-25 00:06:00', 100000, "Online services"),
	('2023-08-30 00:07:00', 500000, "Personal / Other"),
	('2023-08-30 00:08:00', 200000, "Groceries"),
	('2023-08-31 00:09:00', 10000, "Transportation");''';

    try {
      await db.execute(createUser);
      await db.execute(createHistory);
      await db.execute(populateUser);
      await db.execute(populateHistory);
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

  Future submitUser(User user) async {
    var dbClient = await db;
    dbClient.rawUpdate('UPDATE User SET username = ?, balance = ?;',
        [user.username, user.balance]);
    dbClient.rawDelete('DELETE FROM History;');
    return;
  }

  Future addBalance(double add) async {
    var dbClient = await db;
    dbClient.rawUpdate('UPDATE User SET balance = balance + ?', [add]);
    return;
  }

  Future createHistory(History history) async {
    if (history.balanceusage <= 0) {
      return;
    }
    var dbClient = await db;
    await dbClient.execute(
        'UPDATE User SET balance = balance - ?', [history.balanceusage]);
    await dbClient.execute(
        'INSERT INTO History(time, balanceusage, category) VALUES(?, ?, ?);', [
      history.time.toString(),
      history.balanceusage,
      history.category.toString()
    ]);
    return;
  }

  Future<List<History>> readHistory() async {
    var dbClient = await db;
    var rows = await dbClient
        .query('History', columns: ['time', 'balanceusage', 'category']);
    return rows
        .map((row) => History(
            time: DateTime.parse(row['time'].toString()),
            balanceusage: double.parse(row['balanceusage'].toString()),
            category: row['category'].toString()))
        .toList();
  }

  Future<List<History>> readAllTimeReport() async {
    var dbClient = await db;
    var rows = await dbClient.rawQuery(
        'SELECT h.time AS time, SUM(h.balanceusage) AS balanceusage, category FROM History h GROUP BY DATE(h.time);');
    return rows
        .map((row) => History(
            time: DateTime.parse(row['time'].toString()),
            balanceusage: double.parse(row['balanceusage'].toString()),
            category: row['category'].toString()))
        .toList();
  }

  Future<List<History>> readHistoryByCategory() async {
    var dbClient = await db;
    var rows = await dbClient.rawQuery(
        'SELECT h.time, SUM(h.balanceusage) AS balanceusage, category FROM History h GROUP BY h.category;');
    return rows
        .map((row) => History(
            time: DateTime.parse(row['time'].toString()),
            balanceusage: double.parse(row['balanceusage'].toString()),
            category: row['category'].toString()))
        .toList();
  }
}
