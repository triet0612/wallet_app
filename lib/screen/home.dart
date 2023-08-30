import 'package:flutter/material.dart';
import 'package:wallet_app/components/appbar.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/userpage');
              },
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(flex: 1, child: _BalanceCard(user: _user)),
          ],
        ),
        bottomNavigationBar: const BottomBar(index: 0),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final User? user;
  const _BalanceCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.teal.shade900,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            user!.balance.toString(),
            style: const TextStyle(fontSize: 30),
          ),
          const Text("VND"),
          Text("${user!.username}'s balance"),
        ],
      ),
    );
  }
}
