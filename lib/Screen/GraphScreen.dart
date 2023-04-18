import 'package:flutter/material.dart';
import 'package:money_management/Widget/Graphs/MonthlyGraph.dart';
import 'package:provider/provider.dart';
import '../Providers/CreditData.dart';
import '../Widget/Graphs/WeeklyGraph.dart';


class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  static const routeName = "/graphScreen";

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {

  Map<String,Widget> multipleGraphs = {
    "Week Analysis":WeeklyGraph(),
    "Month Analysis": const MonthlyGraph()
  };

  Widget? displayingWidget = WeeklyGraph();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Credit vs Debit"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton(
              hint: const Text('Analysis'),
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(10),left: Radius.circular(10)),
                items: multipleGraphs.entries.map((e) => DropdownMenuItem(
                    value: e.value,
                    child: Text(e.key)
                )).toList(),
              onChanged: (Widget? value) {
                  setState(() {
                    displayingWidget = value;
                  });
              },
            ),
            displayingWidget!,

          ],
        ),
      ),
    );
  }
}

