import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Payload/Debit.dart';
import '../Providers/DebitData.dart';

class DebitWidget extends StatelessWidget {

  final Debit debit;

  const DebitWidget(this.debit);

  @override
  Widget build(BuildContext context) {
    var dismiss = Provider.of<DebitData>(context,listen: false);
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
        dismiss.deleteDebit(debit.transactionId);
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
              backgroundColor: Colors.indigo,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text("₹${debit.amount}"),
              ),
            ),
            title: Text(DateFormat.yMEd().format(debit.createdDate)),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Transaction Id: ${debit.transactionId}"),
                Text("Date: ${DateFormat.yMMMEd().format(debit.createdDate)}"),
              ],
            ),
            trailing: IconButton(
              icon:const Icon(Icons.delete_forever,color: Colors.red),
              onPressed: () {
                dismiss.deleteDebit(debit.transactionId);
              },
            ),
          ),
        ),
      ),
    );
  }
}
