import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/Providers/CreditData.dart';
import 'package:provider/provider.dart';
import '../Payload/Credit.dart';

class CreditWidget extends StatelessWidget {

  final Credit credit;
  const CreditWidget(this.credit);
  
  @override
  Widget build(BuildContext context) {
    var dismiss = Provider.of<CreditData>(context,listen: false);
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (_) {
        return showDialog(context: context,
            builder: (_) {
          return AlertDialog(
            title:const Text('Are you Sure?'),
            content: const Text('Do you want to remove this item from cart?'),
            actions: [
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pop(true),
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pop(false),
                },
                child: const Text('No'),
                ),
              ],
            );
          }
        );
      },
      onDismissed: (_) {
         dismiss.deleteCredit(credit.transactionId);
      },
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(151, 235, 244, 0.15),
              spreadRadius: 5,
            )
          ],
        ),
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          elevation: 4,
          child: ListTile(
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.indigo,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text("₹${credit.cost * credit.quantity}",style: const TextStyle(
                  fontSize: 20
                )),
              ),
            ),

            title: Text(credit.productName),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Transaction Id: ${credit.transactionId}"),
                Text("Date: ${DateFormat.yMMMEd().format(credit.createdDate)}"),
                Text("Quantity ${credit.quantity}")
              ],
            ),
            trailing: IconButton(
              icon:const Icon(Icons.delete_forever,color: Colors.red),
              onPressed: () {
                  dismiss.deleteCredit(credit.transactionId);
              },
            ),
          ),
        ),
      ),
    );
  }
}
