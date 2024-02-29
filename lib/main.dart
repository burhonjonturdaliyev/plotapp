import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Random Number Analysis'),
        ),
        body: const RandomNumberAnalysis(),
      ),
    );
  }
}

class RandomNumberAnalysis extends StatefulWidget {
  const RandomNumberAnalysis({Key? key}) : super(key: key);

  @override
  _RandomNumberAnalysisState createState() => _RandomNumberAnalysisState();
}

class _RandomNumberAnalysisState extends State<RandomNumberAnalysis> {
  List<double> randomNumbers =
      List.generate(1000, (index) => Random().nextDouble());
  List<String> roundedNumbers = [];

  @override
  void initState() {
    super.initState();
    roundNumbers();
  }

  void roundNumbers() {
    roundedNumbers =
        randomNumbers.map((num) => (num).toStringAsFixed(1)).toList();
  }

  Map<String, int> countOccurrences() {
    Map<String, int> occurrences = {};
    for (String number in roundedNumbers) {
      occurrences[number] =
          occurrences.containsKey(number) ? occurrences[number]! + 1 : 1;
    }
    return occurrences;
  }

  String findMostFrequentNumber() {
    Map<String, int> occurrences = countOccurrences();
    String mostFrequentNumber = occurrences.keys
        .reduce((a, b) => occurrences[a]! > occurrences[b]! ? a : b);
    return mostFrequentNumber;
  }

  @override
  Widget build(BuildContext context) {
    String mostFrequentNumber = findMostFrequentNumber();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Most Frequent Number: $mostFrequentNumber'),
        const SizedBox(height: 20),
        Expanded(child: BarPlot(data: countOccurrences())),
      ],
    );
  }
}

class BarPlot extends StatelessWidget {
  final List<charts.Series<OrdinalSales, String>> seriesList;
  final bool animate;

  BarPlot({super.key, required Map<String, int> data, this.animate = true})
      : seriesList = _createData(data);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
    );
  }

  static List<charts.Series<OrdinalSales, String>> _createData(
      Map<String, int> data) {
    List<OrdinalSales> barData = [];
    data.forEach((key, value) {
      barData.add(OrdinalSales(key, value));
    });

    barData.sort((a, b) => a.number.compareTo(b.number));

    return [
      charts.Series<OrdinalSales, String>(
        id: 'Occurrences',
        domainFn: (OrdinalSales sales, _) => sales.number,
        measureFn: (OrdinalSales sales, _) => sales.occurrences,
        data: barData,
      )
    ];
  }
}

class OrdinalSales {
  final String number;
  final int occurrences;

  OrdinalSales(this.number, this.occurrences);
}
