import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Payload/Credit.dart';
import '../Payload/Place.dart';

class CreditData with ChangeNotifier{

  final String token;
  final String userId;
  final String creditsEndpoint = 'https://money-management-production.up.railway.app/api/credits';

  List<Credit> _credits = [];
  List<Credit> _analysisData = [];

  CreditData(this.token,this._credits,this.userId);

  double totalCredits =0;

  List<Credit> get data{
    totalCredits = 0;
    _credits.forEach((element) {totalCredits+= element.quantity*element.cost;});
    return [..._credits];
  }

  List<Credit> get analysisData{
    return [..._analysisData];
  }

  Future<void> fetchAnalysisData(String typeOfAnalysis) async {
      _analysisData = [];
      final url = Uri.parse("$creditsEndpoint/weekData/$userId");
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
          _analysisData.add(Credit(
              transactionId: element['transactionId'],
              cost: element['cost'],
              quantity: element['quantity'],
              createdDate: DateTime.parse(element['createdDate']),
              productName: element['productName'],
              place: null
          ));
      });
      }catch(exception) { rethrow;}
      notifyListeners();
  }

  Future<void> fetchCreditDataFromDatabase() async {
      _credits = [];
      final url = Uri.parse("$creditsEndpoint/all/$userId");
      final response = await http.get(url,
          headers: {
            'Content-Type' : 'application/json',
            'Authorization': 'Bearer $token'
          }
      );
     try{
       (jsonDecode(response.body) as List<dynamic>).forEach((element) {
         _credits.add(Credit(
           transactionId: element['transactionId'],
           cost: element['cost'],
           quantity: element['quantity'],
           createdDate: DateTime.parse(element['createdDate']),
           productName: element['productName'],
           place: Place(
             longitude: element['longitude'],
             latitude: element['latitude'],
             address: element['address']
          ),
         ));
       });

       notifyListeners();
     }catch(exception) { print(exception);}
  }

  Future<void> deleteCredit(int transactionId) async{
    try{
      final url = Uri.parse('$creditsEndpoint/$transactionId/delete');
      await http.delete(url,
          headers: {
            'Content-Type' : 'application/json',
            'Authorization': 'Bearer $token'
          }
      );
    }catch(exception) {}
    _credits.removeWhere((element) => element.transactionId == transactionId);
    _analysisData.removeWhere((element) =>element.transactionId == transactionId);
    notifyListeners();
  }

  Future<void> addCredit (Credit credit) async{
    try{
      final url = Uri.parse('$creditsEndpoint/create?userId=$userId');
      final response = await http.post(url,
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(
      {
         'cost'         : credit.cost,
        'quantity'      : credit.quantity,
        'productName'   : credit.productName,
        'longitude'     : credit.place!.longitude,
        'latitude'      : credit.place!.latitude,
        'address'       : credit.place!.address
      }
    ));
      final responseData = jsonDecode(response.body);
      _credits.insert(0, Credit(
          transactionId: responseData['transactionId'],
          cost: credit.cost,
          quantity: credit.quantity,
          createdDate: DateTime.parse(responseData['createdDate']),
          productName: credit.productName,
          place: credit.place
      ));
      _analysisData.insert(0, _credits[0]);
    }catch(e) {
      print("oops exception");
    }
    notifyListeners();
  }

  Future<void> updateCredit(Credit credit,int transactionId) async {
    final url = Uri.parse('$creditsEndpoint/update/$transactionId');
    try {
      await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(
              {
                'cost': credit.cost,
                'quantity': credit.quantity,
                'productName': credit.productName,
                'latitude': credit.place!.latitude,
                'longitude': credit.place!.longitude,
                'address': credit.place!.address
              }
          )
      );
      for (var element in _credits) {
        if (element.transactionId == transactionId) {
          element.productName = credit.productName;
          element.quantity = credit.quantity;
          element.cost = credit.cost;
          break;
        }
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }


}