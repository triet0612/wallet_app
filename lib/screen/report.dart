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
  @override
  void initState() {
    super.initState();
    _readHistory();
  }

  void _readHistory() {
    setState(() {
      _hist = DBProvider().mockHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Report")),
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: _BalanceChart(history: _hist),
            ),
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
      title: ChartTitle(text: '7-days report'),
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
