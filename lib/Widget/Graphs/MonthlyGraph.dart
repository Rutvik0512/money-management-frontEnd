import 'package:flutter/material.dart';
import 'package:money_management/Payload/MonthlyData.dart';
import 'package:money_management/Providers/DataAnalysis.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Providers/CreditData.dart';
import '../../Providers/DebitData.dart';
import '../DetailedData.dart';

class MonthlyGraph extends StatefulWidget {
  const MonthlyGraph({Key? key}) : super(key: key);

  @override
  State<MonthlyGraph> createState() => _MonthlyGraphState();
}

class _MonthlyGraphState extends State<MonthlyGraph> {

  @override
  void initState() {
    Provider.of<CreditData>(context,listen: false).fetchAnalysisData('Month');
    Provider.of<DebitData>(context,listen: false).fetchAnalysisData('Month');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CreditData credit = Provider.of<CreditData>(context);
    final DebitData debit = Provider.of<DebitData>(context);
    final DataAnalysis dataAnalysis = Provider.of<DataAnalysis>(context);
    final media = MediaQuery.of(context);
    return Column(
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
                      text: 'Monthly Expenditure'
                  )
              ),
              margin: const EdgeInsets.all(15),
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: Legend(
                  isVisible: true
              ),
              series: <ChartSeries>[
                StackedLineSeries<MonthlyData,int>(
                    dataSource: dataAnalysis.getMonthlyCreditData(credit.analysisData),
                    xValueMapper: (MonthlyData monthlyData,_)  => monthlyData.day,
                    yValueMapper: (MonthlyData monthlyData,_)  => monthlyData.amount.round(),
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                    ),
                    name: 'Credits'
                ),
                StackedLineSeries<MonthlyData,int>(
                    dataSource: dataAnalysis.getMonthlyDebitData(debit.analysisData),
                    xValueMapper: (MonthlyData monthlyData,_)  => monthlyData.day,
                    yValueMapper: (MonthlyData monthlyData,_)  => monthlyData.amount.round(),
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                    ),
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
    );
  }
}
