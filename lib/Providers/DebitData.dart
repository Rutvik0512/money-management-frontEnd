import 'package:flutter/cupertino.dart';
import 'package:money_management/Payload/Debit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class DebitData with ChangeNotifier{

  final String token;
  final String userId;
  final String baseUrl = 'https://money-management-production.up.railway.app/api/debit';
  //10.0.2.2:9090


  List<Debit> _debits = [];

  DebitData(this.token,this._debits,this.userId);

  List<Debit> get data{
    return [..._debits];
  }

  List<Debit> _analysisData = [];

  List<Debit> get analysisData{
    return _analysisData;
  }

  Future<void> fetchDebitDataFromDatabase() async {
    _debits = [];
    final url = Uri.parse("$baseUrl/all/$userId");
    final response = await http.get(url,
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': 'Bearer $token'
        }
    );
    try{
      (jsonDecode(response.body) as List<dynamic>).forEach((element) {
        _debits.add(Debit(
            transactionId: element['transactionId'],
            amount: element['amount'],
            createdDate: DateTime.parse(element['createdDate']),
        ));
      });
    }catch(exception) { print(exception);}
    notifyListeners();
  }

  Future<void> deleteDebit(int transactionId) async{
    try{
      final url = Uri.parse('$baseUrl/$transactionId/delete');
      await http.delete(url,
          headers: {
            'Content-Type' : 'application/json',
            'Authorization': 'Bearer $token'
          }
      );
    }catch(exception) {print(exception);}
    var index = _debits.indexWhere((element) => element.transactionId == transactionId);
    _debits.removeAt(index);
    notifyListeners();
  }

  Future<void> fetchAnalysisData(String typeOfAnalysis) async {
    _analysisData = [];
    final url = Uri.parse("$baseUrl/weekData/$userId");
    final date = DateTime.now();
    final subtractTime = typeOfAnalysis == 'Month'? date.day : 7;
    final response = await http.post(url,
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
            {
              'date' : date.subtract(Duration(days: subtractTime,
                  seconds:date.second,
                  hours: date.hour,
                  microseconds: date.microsecond,
                  milliseconds: date.millisecond,
                  minutes: date.minute)).toIso8601String()
            })
    );
    try{
      (jsonDecode(response.body) as List<dynamic>).forEach((element) {
        _analysisData.add(Debit(
            transactionId: element['transactionId'],
            amount: element['amount'],
            createdDate: DateTime.parse(element['createdDate']),
        ));
      });
    }catch(exception) { rethrow;}
    notifyListeners();
  }

  Future<void> addDebit (Debit debit) async{
    try{
      final url = Uri.parse('$baseUrl/create?userId=$userId');
      final response = await http.post(url,
          headers: {
            'Content-Type' : 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(
              {
                'amount'         : debit.amount,
              }
          ));
      final responseData = jsonDecode(response.body);
      _debits.insert(0, Debit(
          transactionId: responseData['transactionId'],
          amount: responseData['amount'],
          createdDate: DateTime.parse(responseData['createdDate']),
      ));
    }catch(e) {
      print("oops exception");
    }
    notifyListeners();
  }

  Future<void> updateDebit(Debit debit,int transactionId) async {
    final url = Uri.parse('$baseUrl/update/$transactionId');
    try {
      await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(
              {
                'amount' : debit.amount
              }
          )
      );
      for (var element in _debits) {
        if (element.transactionId == transactionId) {
          element.amount = debit.amount;
          break;
        }
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}