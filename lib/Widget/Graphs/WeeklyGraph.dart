import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/Payload/WeeklyData.dart';
import 'package:money_management/Providers/DataAnalysis.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Providers/CreditData.dart';
import '../../Providers/DebitData.dart';
import '../DetailedData.dart';

class WeeklyGraph extends StatefulWidget {
  @override
  State<WeeklyGraph> createState() => _WeeklyGraphState();
}

class _WeeklyGraphState extends State<WeeklyGraph> {

  void initState() {
    Provider.of<CreditData>(context,listen: false).fetchAnalysisData('Week');
    Provider.of<DebitData>(context,listen: false).fetchAnalysisData('Week');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CreditData credit = Provider.of<CreditData>(context);
    final DebitData debit = Provider.of<DebitData>(context);
    final DataAnalysis dataAnalysis = Provider.of<DataAnalysis>(context);
    final media = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: media.size.height/2,
            child: Card(
              shadowColor: Colors.blueAccent,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
              ),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                    title: AxisTitle(
                        text: 'Weekly Expenditure'
                    )
                ),
                margin: const EdgeInsets.all(15),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(
                  isVisible: true
                ),
                series: <ChartSeries>[
                  ColumnSeries<WeeklyData,String>(
                      dataSource: dataAnalysis.getWeeklyCreditData(credit.analysisData),
                      xValueMapper: (WeeklyData weeklyData,_)  => weeklyData.weekDay,
                      yValueMapper: (WeeklyData weeklyData,_) => weeklyData.amount.round(),
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                      ),
                      animationDuration: 2000,
                      name: 'Credits'
                  ),
                  ColumnSeries<WeeklyData,String>(
                      dataSource: dataAnalysis.getWeeklyDebitData(debit.analysisData),
                      xValueMapper: (WeeklyData weeklyData,_)  => weeklyData.weekDay,
                      yValueMapper: (WeeklyData weeklyData,_) => weeklyData.amount.round(),
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                      ),
                      animationDuration: 2000,
                      name: "Debits"
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          DetailedData(credit: credit, dataAnalysis: dataAnalysis, debit: debit)
        ],
      ),
    );
  }
}

