import 'package:flutter/material.dart';
import 'package:money_management/Screen/HomeScreen.dart';
import 'package:money_management/Widget/AddTransaction.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Payload/MonthlyData.dart';
import '../Providers/DataAnalysis.dart';
import '../Providers/DebitData.dart';
import '../Widget/DebitOrder.dart';
import '../Payload/Debit.dart' as myDebit;

class Debit extends StatefulWidget {
  const Debit({Key? key}) : super(key: key);

  static const routeName = '/debitScreen';

  @override
  State<Debit> createState() => _DebitState();
}

class _DebitState extends State<Debit> {

  @override
  void initState() {
    Provider.of<DebitData>(context,listen: false).fetchAnalysisData('Month');
    super.initState();
  }

  void updateDebit(myDebit.Debit debit){
    showModalBottomSheet(
        context: context,
        builder:(bctx){
          return AddTransaction(
              displayMode: DisplayMode.debitScreen,
              transactionId: debit.transactionId,
              onEditing: true,
              amount: debit.amount,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final DebitData debitData = Provider.of<DebitData>(context);
    var media = MediaQuery.of(context);
    return SingleChildScrollView(
        child: Column(
          children :[
            SizedBox(
              height: media.size.height/2.85,
              child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: DebitChartWidget(debitData: debitData,)
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:[
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Text('Total Transactions: ${debitData.data.length}',style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500
                  ),),
                )
              ],
            ),
            SizedBox(
              height: media.size.height/3,
              child: ListView.separated(
                itemCount: debitData.data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () => {
                          updateDebit(debitData.data[index])
                      },
                      child: DebitWidget(debitData.data[index])
                  );
                },
                separatorBuilder: (bctx, _) {
                  return const Divider();
                },
              ),
            ),
          ],
        )
    );
  }
}

class DebitChartWidget extends StatelessWidget {
  const DebitChartWidget({
    Key? key,
    required this.debitData,
  }) : super(key: key);

  final DebitData debitData;


  @override
  Widget build(BuildContext context) {
    final DataAnalysis dataAnalysis = Provider.of<DataAnalysis>(context);
    return SfCartesianChart(
        title: ChartTitle(text: 'Monthly Debits'),
        primaryXAxis: CategoryAxis(
            title: AxisTitle(
                text: 'Cost'
            )
        ),

        margin: const EdgeInsets.all(15),
        legend: Legend(
            isVisible: true
        ),
        series: <ChartSeries>[
          ColumnSeries<MonthlyData,int>(
              dataSource: dataAnalysis.getMonthlyDebitData(debitData.analysisData),
              xValueMapper: (MonthlyData monthlyData,_)  => monthlyData.day,
              yValueMapper: (MonthlyData monthlyData,_) => monthlyData.amount.round(),
              animationDuration: 2000,
              name: 'Debits'
          ),
        ]
    );
  }
}
