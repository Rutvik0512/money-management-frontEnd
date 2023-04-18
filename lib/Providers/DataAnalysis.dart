import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:money_management/Payload/DataFromat.dart';

import '../Payload/Credit.dart';
import '../Payload/Debit.dart';
import '../Payload/MonthlyData.dart';
import '../Payload/WeeklyData.dart';


class DataAnalysis with ChangeNotifier{

  double _creditExpenditures = 0;
  double _debitExpenditures = 0;

  double get creditExpenditures{
    return _creditExpenditures;
  }

  double get debitExpenditures{
    return _debitExpenditures;
  }

  List<WeeklyData> getWeeklyCreditData(List<Credit> credits){
    List<WeeklyData> data= DataFormat.formattedWeeklyData();
    _creditExpenditures = 0;
    data.forEach((weeklyData) {
      for(int i=0;i < credits.length;i++){
        if(weeklyData.weekDay == DateFormat.E().format(credits[i].createdDate)){
          Credit element = credits[i];
          weeklyData.amount += element.cost * element.quantity;
          weeklyData.quantity += element.quantity;
          _creditExpenditures += weeklyData.amount;
        }
      }
    });
    return data;
  }

  List<MonthlyData> getMonthlyCreditData(List<Credit> credits){
    List<MonthlyData> data = DataFormat.formattedMonthlyData();
    _creditExpenditures = 0;
    credits.forEach((element) {
      var index = element.createdDate.day;
      data[index].amount += element.quantity * element.cost;
      data[index].quantity += element.quantity;
      _creditExpenditures += data[index].amount;
    });
    return data;
  }

  List<WeeklyData> getWeeklyDebitData(List<Debit> debits){
    List<WeeklyData> data = DataFormat.formattedWeeklyData();
    _debitExpenditures = 0;
    data.forEach((weeklyData) {
      var index = debits.indexWhere((debit) => weeklyData.weekDay == DateFormat.E().format(debit.createdDate));
      if(index!=-1){
        Debit element = debits[index];
        weeklyData.amount += element.amount;
        weeklyData.quantity += 1;
        _debitExpenditures += weeklyData.amount;
      }
    });
    return data;
  }

  List<MonthlyData> getMonthlyDebitData(List<Debit> debits){
    List<MonthlyData> data = DataFormat.formattedMonthlyData();
    _debitExpenditures = 0;
    debits.forEach((element) {
      var index = element.createdDate.day;
      data[index].amount += element.amount;
      data[index].quantity += 1;
      _debitExpenditures += data[index].amount;
    });
    return data;
  }
}