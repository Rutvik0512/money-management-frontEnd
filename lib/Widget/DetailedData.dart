import 'package:flutter/material.dart';

import '../Providers/CreditData.dart';
import '../Providers/DataAnalysis.dart';
import '../Providers/DebitData.dart';

class DetailedData extends StatelessWidget {
  const DetailedData({
    Key? key,
    required this.credit,
    required this.dataAnalysis,
    required this.debit,
  }) : super(key: key);

  final CreditData credit;
  final DataAnalysis dataAnalysis;
  final DebitData debit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text('Weekly Detailed Transactions:',style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold
          ),),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text('Total Credits Transactions: ${credit.analysisData.length}',style: const TextStyle(
              fontSize: 16
          ),),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text('Total Credits Expenditure: ${dataAnalysis.creditExpenditures.toStringAsFixed(2)}',style: const TextStyle(
              fontSize: 16
          ),),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text('Total Debits Transactions: ${debit.analysisData.length}',style: const TextStyle(
              fontSize: 16
          ),),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text('Total Credits Expenditure: ${dataAnalysis.debitExpenditures.toStringAsFixed(2)}',style: const TextStyle(
              fontSize: 16
          ),),
        ),
      ],
    );
  }
}