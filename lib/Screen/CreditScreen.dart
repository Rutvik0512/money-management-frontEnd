import 'package:flutter/material.dart';
import 'package:money_management/Payload/MonthlyData.dart';
import 'package:money_management/Screen/HomeScreen.dart';
import 'package:money_management/Widget/AddTransaction.dart';
import 'package:money_management/Widget/DisplayWithMap.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Payload/Credit.dart';
import '../Providers/CreditData.dart';
import '../Providers/DataAnalysis.dart';
import '../Widget/CreditOrder.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    Provider.of<CreditData>(context,listen: false).fetchAnalysisData('Month');
    Provider.of<CreditData>(context,listen: false).fetchAnalysisData('Week');
    super.initState();
  }

  void updateCredit(Credit credit){
      showModalBottomSheet(context: context, builder: (_){
          return AddTransaction(
            displayMode: DisplayMode.homeScreen,
            price: credit.cost,
            productName: credit.productName,
            quantity: credit.quantity,
            onEditing: true,
            transactionId: credit.transactionId,
          );
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    final CreditData creditData = Provider.of<CreditData>(context);
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
                child: CreditChartWidget(creditData: creditData)
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:[
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Text('Total Transactions: ${creditData.data.length}',style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500
                  ),),
                )
              ],
            ),
            SizedBox(
              height: media.size.height/3,
              child: ListView.separated(
                itemCount: creditData.data.length,
                separatorBuilder: (bctx, _) {
                    return const Divider();
                  },
                itemBuilder: (context, index){
                  return InkWell(
                      child: CreditWidget(creditData.data[index]),
                       onTap: () async {
                        bool res = await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                        DisplayWithMap(credit: creditData.data[index]),
                          ),);
                        if(res) updateCredit(creditData.data[index]);
                       },//
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Text('Total Credits: ${creditData.totalCredits.toStringAsFixed(2)}',style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500
              ),),
            ),
          ]
        )
    );
  }
}

class CreditChartWidget extends StatelessWidget {

  const CreditChartWidget({
    Key? key,
    required this.creditData,
  }) : super(key: key);

  final CreditData creditData;


  @override
  Widget build(BuildContext context) {
    final DataAnalysis dataAnalysis = Provider.of<DataAnalysis>(context);
    return SfCartesianChart(
      title: ChartTitle(text: 'Monthly Credits'),
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
            dataSource: dataAnalysis.getMonthlyCreditData(creditData.analysisData),
            xValueMapper: (MonthlyData monthlyData,_)  => monthlyData.day,
            yValueMapper: (MonthlyData monthlyData,_) => monthlyData.amount.round(),
          animationDuration: 2000,
          name: 'Credits'
        ),
      ]
    );
  }
}