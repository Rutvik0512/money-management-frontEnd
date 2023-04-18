import 'package:flutter/material.dart';
import 'package:money_management/Payload/Credit.dart';
import 'package:money_management/Widget/StaticMapWidget.dart';

import '../Screen/GoogleMapScreen.dart';

class DisplayWithMap extends StatelessWidget {
  const DisplayWithMap({Key? key,required this.credit}) : super(key: key);

  final Credit credit;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    print(credit.place!.latitude);
    return Scaffold(
      appBar: AppBar(
        title: Text(credit.productName),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.edit)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => GoogleMapScreen(place: credit.place!,isSelecting: false,)),
              )},
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: media.size.height/2,
                child: credit.place!.address == ''?
                      const Text('Address Unavailable')  :StaticMapWidget(place: credit.place)
              ),
            ),
            const Card(
              child: Text('Product Details',style: TextStyle(
                  fontSize: 20
              ),),
            ),
            Card(

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('Product Name: ${credit.productName}',style: const TextStyle(
                          fontSize: 16
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('Transaction Id: ${credit.transactionId}',style: const TextStyle(
                          fontSize: 16
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('Quantity: ${credit.quantity}',style: const TextStyle(
                          fontSize: 16
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('Total Cost: ${credit.cost * credit.quantity}',style: const TextStyle(
                          fontSize: 16
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text('Address: ${credit.place!.address}',style: const TextStyle(
                          fontSize: 16
                      ),),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
