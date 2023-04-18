import 'package:flutter/material.dart';
import 'package:money_management/Payload/Credit.dart';
import 'package:money_management/Payload/Debit.dart';
import 'package:money_management/Providers/CreditData.dart';
import 'package:money_management/Providers/DebitData.dart';
import 'package:money_management/Screen/HomeScreen.dart';
import 'package:money_management/Screen/MapScreen.dart';
import 'package:provider/provider.dart';

import '../Payload/Place.dart';

class AddTransaction extends StatefulWidget {

  final DisplayMode displayMode;

  String? productName;
  double? price;
  int? quantity;
  bool? onEditing;
  int? transactionId;
  double? amount;

  AddTransaction({
    required this.displayMode,
    this.productName,
    this.price,
    this.quantity,
    this.onEditing,
    this.transactionId,
    this.amount
  });

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {

  final _priceFocusNode = FocusNode();
  final _quantityFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String? productName;
  double? price;
  int? quantity;
  double? amount;
  Place? place;
  bool isUpdate = false;

  @override
  void dispose(){
    super.dispose();
    _priceFocusNode.dispose();
  }

  saveForm(){
    _form.currentState?.save();
    CreditData creditData = Provider.of<CreditData>(context,listen: false);
    DebitData debitData = Provider.of<DebitData>(context,listen: false);
    if(widget.onEditing!=null){
      if(widget.displayMode == DisplayMode.homeScreen) {
        place ??= const Place(longitude: 0, latitude: 0, address: '');
        creditData.updateCredit(
            Credit(transactionId: creditData.data.length+1,
                cost: price!,
                quantity: quantity!,
                createdDate: DateTime.now(),
                productName: productName!,
                place: place
            ),
            widget.transactionId!
        );

      }
      else{
        debitData.updateDebit(
          Debit(
          transactionId: debitData.data.length+1,
          createdDate: DateTime.now(),
          amount: amount!),
          widget.transactionId!);
      }
    }
    else{
      widget.displayMode == DisplayMode.debitScreen?
      debitData.addDebit(Debit(
          transactionId: debitData.data.length+1,
          createdDate: DateTime.now(),
          amount: amount!))
          : creditData.addCredit(Credit(transactionId: creditData.data.length+1,
          cost: price!,
          quantity: quantity!,
          createdDate: DateTime.now(),
          productName: productName!,
          place: place
      ),);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(5.0),
      child: Form(
        key: _form,
        child: ListView(
          children: [
            if(widget.displayMode == DisplayMode.debitScreen)...[
              TextFormField(
                decoration: const InputDecoration(
                    label : Text('Enter Transaction amount')
                ),
                initialValue: widget.amount!=null? widget.amount.toString():'',
                onFieldSubmitted: (_) => saveForm(),
                onSaved: (value) => amount = double.parse(value!),
              )
          ]
            else...[
              TextFormField(
                decoration:const InputDecoration(
                  label: Text('Product Name'),
                ),
                textInputAction: TextInputAction.next,
                initialValue: widget.productName ?? '',
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  productName = value;
                },
              ),
              TextFormField(
                decoration:const InputDecoration(
                  label: Text('Price'),
                ),
                initialValue: widget.price !=null? widget.price.toString():'',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_quantityFocusNode);
                },
                onSaved: (value){
                  price = double.parse(value!);
                },
              ),
              TextFormField(
                decoration:const InputDecoration(
                  label: Text('Quantity'),
                ),
                initialValue: widget.quantity !=null? widget.quantity.toString():'',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                focusNode: _quantityFocusNode,
                onFieldSubmitted: (_){
                  saveForm();
                },
                onSaved: (value){
                  quantity = int.parse(value!);
                },
              ),
              TextButton.icon(
                  onPressed: () async => {

                      place = await Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const MapScreen()))
                  },
                  icon: const Icon(Icons.room_outlined),
                  label: const Text('Get Location')
              )
            ],
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    saveForm();
                  },
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
