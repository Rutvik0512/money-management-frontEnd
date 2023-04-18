import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'MonthlyData.dart';
import 'WeeklyData.dart';

class DataFormat{

  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear = (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return daysInMonth[month - 1];
  }

  static List<WeeklyData> formattedWeeklyData(){
    List<WeeklyData> data= [];
    DateTime dateTime = DateTime.now();
    for(int i=0;i<7;i++){
      var date = dateTime.subtract(Duration(days: i));
      data.add(WeeklyData(0,
          DateFormat.E().format(date), 0));
    }
    return data;
  }

  static List<MonthlyData> formattedMonthlyData(){
    List<MonthlyData> data = [];
    int month = getDaysInMonth(DateTime.now().year, DateTime.now().month);
    for(int i=1;i<=month;i++){
      data.add(MonthlyData(0, i, 0));
    }
    return data;
  }

}