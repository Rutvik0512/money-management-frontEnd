import 'package:flutter/material.dart';
import 'package:money_management/Payload/Authentication.dart';
import 'package:money_management/Widget/AddTransaction.dart';
import 'package:money_management/Widget/Drawer.dart';
import 'package:provider/provider.dart';
import '../Providers/CreditData.dart';
import '../Providers/DebitData.dart';
import 'CreditScreen.dart';
import 'DebitScreen.dart';

class Home extends StatefulWidget {

    const Home({Key? key}) : super(key: key);
    static const routeName ='/homeScreen';
  @override
  State<Home> createState() => _HomeState();
}

enum DisplayMode {
    homeScreen,
    debitScreen
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    var credit = Provider.of<CreditData>(context,listen: false);
    credit.fetchCreditDataFromDatabase();
    Provider.of<DebitData>(context,listen: false).fetchDebitDataFromDatabase();
    super.initState();
    print("i'm Recalled");
  }

  DisplayMode currentMode = DisplayMode.homeScreen;

  updateSelectIndex(int updateTheMode){
    setState(() {
      currentMode = updateTheMode == 0? DisplayMode.homeScreen : DisplayMode.debitScreen;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage your money"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () { Provider.of<Authentication>(context,listen: false).logOut();},
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: currentMode == DisplayMode.homeScreen ? HomeScreen(): Debit(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: updateSelectIndex,
        currentIndex: currentMode.index,
        selectedItemColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            label: 'Debit',
            icon: Icon(Icons.credit_card),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text('+',style: TextStyle(
            fontSize: 25
        ),),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (bctx) {
                return AddTransaction(displayMode: currentMode);
              }
          );
        },
      ),
    );
  }
}


