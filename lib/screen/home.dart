import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wallet_app/model/database.dart';
import 'package:wallet_app/model/model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User _user = const User(username: "", balance: 0.0);
  List<History> _hist = [];
  @override
  void initState() {
    super.initState();
    _readUser();
    _readHistory();
  }

  void _readUser() async {
    var temp = await DBProvider().readUser();
    setState(() {
      _user = temp;
    });
  }

  void _readHistory() {
    setState(() {
      _hist = DBProvider().mockHistory();
    });
  }

  void _onTapped(int index) {
    if (index == 0) {
      return;
    }
    switch (index) {
      case 1:
        Navigator.of(context).popAndPushNamed('/');
        break;
    }
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
              onPressed: () {},
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(flex: 1, child: _BalanceCard(user: _user)),
            Expanded(
              flex: 3,
              child: _BalanceChart(history: _hist),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          ],
          currentIndex: 0,
          onTap: _onTapped,
        ),
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
        color: const Color.fromARGB(255, 0, 78, 3),
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

class _BalanceChart extends StatelessWidget {
  final List<History>? history;
  const _BalanceChart({required this.history});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(labelRotation: 45),
      primaryYAxis: NumericAxis(
        rangePadding: ChartRangePadding.round,
      ),
      title: ChartTitle(text: 'Balance history'),
      series: <LineSeries<History, String>>[
        LineSeries(
            markerSettings:
                MarkerSettings(isVisible: true, color: Colors.pink[300]),
            dataSource: history!,
            xValueMapper: (History hs, _) {
              var t = hs.time;
              return "${t.year}-${t.month}-${t.day}";
            },
            yValueMapper: (History hs, _) => hs.balanceusage)
      ],
    );
  }
}
