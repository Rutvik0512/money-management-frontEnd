import 'package:flutter/material.dart';
import 'package:money_management/Screen/DebitScreen.dart';
import 'package:money_management/Screen/GraphScreen.dart';

import '../Screen/HomeScreen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            color: Colors.blueAccent,
            child: Row(
              children:const [
                SizedBox(),
                Text('Menu',style: TextStyle(
                  color: Colors.white,fontSize: 20,
                )
                ),
              ],
            )
          ),
         Build(icon: Icons.home,text: 'Home',fun: () {Navigator.of(context).pop();},),
         Build(icon: Icons.analytics_sharp, text: 'Graphs', fun: () {
           Navigator.of(context).popAndPushNamed(GraphScreen.routeName);
         },),
         Build(icon: Icons.settings, text: 'Settings',fun: () {},)
        ],
      )
    );
  }
}

class Build extends StatelessWidget {

  final IconData icon;
  final String text;
  final Function() fun;

  Build({required this.icon, required this.text, required this.fun});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,size: 30),
      title: Text(text),
      onTap: fun,
    );
  }
}

