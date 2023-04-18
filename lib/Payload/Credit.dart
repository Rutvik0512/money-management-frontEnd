import 'Place.dart';

class Credit{

  final int transactionId;
  double cost;
  int quantity;
  DateTime createdDate;
  String productName;

  Place? place;

  Credit({required this.transactionId,required this.cost, required this.quantity, required this.createdDate, required this.productName,required this.place});

}
