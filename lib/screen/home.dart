import 'package:flutter/material.dart';
import 'package:wallet_app/model/database.dart';
import 'package:wallet_app/model/model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User _user = const User(username: "", balance: 0.0);
  @override
  void initState() {
    super.initState();
    _readUser();
  }

  void _readUser() async {
    var temp = await DBProvider().readUser();
    setState(() {
      _user = temp;
    });
  }

  Widget balanceCard() {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 0, 78, 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _user.balance.toString(),
              style: const TextStyle(fontSize: 30),
            ),
            const Text("VND"),
            Text("${_user.username}'s balance"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Column(
          children: [balanceCard(), const Spacer(flex: 3)],
        ),
      ),
    );
  }
}
