import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Authentication with ChangeNotifier{

  String _authToken='';
  String _userId= '';
  DateTime? _expirationTime = DateTime.now();
  Timer? _authTime;
  final String baseUrl = 'https://money-management-production.up.railway.app/api/v1/auth';
  //money-management-production.up.railway.app

  String get authToken{

    return _authToken;
  }

  String get userId{
    return _userId;
  }

  bool get isTokenValid{
    return _authToken.isNotEmpty && _expirationTime!.isAfter(DateTime.now());
  }

  Future<void> signIn(Map<String,Object> payload) async {
    final url = Uri.parse("$baseUrl/register");
    try{
      final response= await http.post(url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(
                {
                  'firstName': payload['firstName'],
                  'email': payload['email'],
                  'password': payload['password'],
                }
              ),);
        final responseData = json.decode(response.body);
        _authToken = responseData['token'];
        _userId = responseData['userId'].toString();
        _expirationTime = DateTime.parse(responseData['expirationDate']);
    }catch(exception){
      rethrow;
    }
    _autoLogout();
    notifyListeners();
  }


  Future<void> logIn(Map<String,Object> payload) async {
    final url = Uri.parse("$baseUrl/authenticate");
    try{
      final response= await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {
              'email': payload['email'],
              'password': payload['password'],
            }
        ),);
      final responseData = json.decode(response.body);
      _authToken = responseData['token'];
      _userId = responseData['userId'].toString();
      _expirationTime = DateTime.parse(responseData['expirationDate']);
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          "token": _authToken,
          "userId": _userId,
          "expirationDate" : _expirationTime!.toIso8601String()
        });
      prefs.setString("userData", userData);
    }catch(exception){
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(prefs.getString("userData").toString()) as Map<String,dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expirationDate']);

    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _authToken = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expirationTime = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logOut() async{
    _authToken = '';
    _userId = '';
    _expirationTime = null;
    if(_authTime != null ){
      _authTime!.cancel();
    }
    _authTime = null;
    try{
      final sharedPrefences = await SharedPreferences.getInstance();
      sharedPrefences.remove("userData");
    }catch(Exception ){ print(Exception);}

    notifyListeners();
  }

  void _autoLogout(){
    if(_authTime != null ){
      _authTime!.cancel();
      _authTime = null;
    }
    final timeToExpiry = _expirationTime!.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: timeToExpiry),logOut);
  }

}