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
  List<History> _hist = [];
  List<History> _categoryHist = [];
  @override
  void initState() {
    _readHistory();
    _readCategoryHist();
    super.initState();
  }

  void _readHistory() async {
    var temp = await DBProvider().readAllTimeReport();
    setState(() {
      _hist = temp;
    });
  }

  void _readCategoryHist() async {
    var temp = await DBProvider().readHistoryByCategory();
    setState(() {
      _categoryHist = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Report")),
        body: Column(
          children: [
            Expanded(flex: 3, child: _BalanceChart(history: _hist)),
            Expanded(flex: 3, child: _CategoryBarChart(history: _categoryHist)),
            Text("Details"),
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
