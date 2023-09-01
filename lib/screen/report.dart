
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wallet_app/components/appbar.dart';
import 'package:wallet_app/model/database.dart';
import 'package:wallet_app/model/model.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  List<History> _allTime = [];
  List<History> _categoryHist = [];
  List<History> _hist = [];
  @override
  void initState() {
    _readAllTime();
    _readCategoryHist();
    _readHist();
    super.initState();
  }

  void _readAllTime() async {
    var temp = await DBProvider().readAllTimeReport();
    setState(() {
      _allTime = temp;
    });
  }

  void _readCategoryHist() async {
    var temp = await DBProvider().readHistoryByCategory();
    setState(() {
      _categoryHist = temp;
    });
  }

  void _readHist() async {
    var temp = await DBProvider().readHistory();
    temp.sort((a, b) => b.time.compareTo(a.time));
    setState(() {
      _hist = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Report")),
        body: ListView(
          children: [
            _BalanceChart(history: _allTime),
            _CategoryBarChart(history: _categoryHist),
            const Text("Details"),
            _Details(history: _hist)
          ],
        ),
        bottomNavigationBar: const BottomBar(index: 1),
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
      title: ChartTitle(text: 'All time balance usage'),
      series: <LineSeries<History, String>>[
        LineSeries(
            markerSettings:
                MarkerSettings(isVisible: true, color: Colors.pink.shade300),
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

class _CategoryBarChart extends StatelessWidget {
  final List<History>? history;
  const _CategoryBarChart({required this.history});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(text: 'Per categories'),
      legend: const Legend(isVisible: true),
      series: <CircularSeries<History, String>>[
        PieSeries(
          dataSource: history!,
          xValueMapper: (History hs, _) => hs.category,
          yValueMapper: (History hs, _) => hs.balanceusage,
        )
      ],
    );
  }
}

class _Details extends StatelessWidget {
  final List<History>? history;
  final Map<String, IconData> trailingIcon = {
    "Groceries": Icons.local_grocery_store_sharp,
    "Housing & Utilities": Icons.house_outlined,
    "Transportation": Icons.emoji_transportation,
    "Healthcare": Icons.health_and_safety_outlined,
    "Personal / Other": Icons.category_rounded,
    "Online services": Icons.wifi,
  };

  _Details({this.history});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var e in history!) ...{
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              leading: Icon(trailingIcon[e.category]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              trailing: Text(
                e.category.toString(),
                style: const TextStyle(fontSize: 15),
              ),
              title: Text("${e.time.year}-${e.time.month}-${e.time.day}"),
              subtitle: Text('VND ${e.balanceusage}'),
              tileColor: Colors.cyan.shade900,
            ),
          ),
        }
      ],
    );
  }
}
