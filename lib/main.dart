import 'package:flutter/material.dart';
import 'package:money_management/Providers/CreditData.dart';
import 'package:money_management/Payload/Authentication.dart';
import 'package:money_management/Providers/DataAnalysis.dart';
import 'package:money_management/Providers/DebitData.dart';
import 'package:money_management/Screen/DebitScreen.dart';
import 'package:money_management/Screen/GoogleMapScreen.dart';
import 'package:money_management/Screen/GraphScreen.dart';
import 'package:money_management/Screen/MapScreen.dart';
import 'package:money_management/Widget/DisplayWithMap.dart';
import 'package:money_management/Widget/splash_screen.dart';
import 'package:provider/provider.dart';
import 'Screen/AuthenticationScreen.dart';
import 'Screen/HomeScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: Authentication()),
        ChangeNotifierProxyProvider<Authentication,CreditData>(
            create: (_) => CreditData('', [],''),
            update: (ctx, authentication, prevCreditData) =>
                CreditData(
                    authentication.authToken,prevCreditData == null ? [] : prevCreditData.data,
                    authentication.userId
            ),
        ),
        ChangeNotifierProxyProvider<Authentication,DebitData>(
          create: (ctx) => DebitData("", [], ''),
          update: (ctx,authentication, prevDebitData) =>
                DebitData(
                  authentication.authToken,
                    prevDebitData==null ? []: prevDebitData.data,
                    authentication.userId
                )
        ),
        ChangeNotifierProvider.value(
            value: DataAnalysis()
        )
      ],
      child: Consumer<Authentication>(
        builder: (ctx, auth, _) => MaterialApp(
          title: "Money Management",
          debugShowCheckedModeBanner: false,
          home: auth.isTokenValid ? const Home() : FutureBuilder(future: auth.tryAutoLogin(),builder: (ctx,authResultSnapShot) => authResultSnapShot.connectionState == ConnectionState.waiting ? SplashScreen() : const AuthenticationScreen()),
          routes: {
            Home.routeName: (ctx) => const Home(),
            Debit.routeName: (ctx) => const Debit(),
            GraphScreen.routeName: (ctx) =>const GraphScreen(),
            MapScreen.routeName: (ctx) =>  MapScreen(),
            GoogleMapScreen.routeName: (ctx) => const GoogleMapScreen(),
          },
        ),
      )
    );
  }
}



