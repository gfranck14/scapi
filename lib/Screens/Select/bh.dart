import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

















class Settings extends StatefulWidget {
  const Settings({ Key? key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, double> dataMap = {
    "A jour": 18.47,
    "Expire": 17.70,
    "Expiré": 4.25,
  };

  List<Color> colorList = [
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0xffFA4A42),
    const Color(0xffFE9539)
  ];

  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Statistques"),),
      body: Center(
        child: ListView(
          children: <Widget>[
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: PieChart(
                  dataMap: dataMap,
                  colorList: colorList,
                  chartRadius: MediaQuery.of(context).size.width / 3,
                  centerText: "Assurance",
                  chartType: ChartType.ring,
                  ringStrokeWidth: 28,
                  animationDuration: const Duration(seconds: 1),
                  chartValuesOptions: const ChartValuesOptions(
                      showChartValues: true,
                      showChartValuesOutside: true,
                      showChartValuesInPercentage: true,
                      showChartValueBackground: false),
                  legendOptions: const LegendOptions(
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(fontSize: 12),
                      legendPosition: LegendPosition.right,
                      showLegendsInRow: false),
                  gradientList: gradientList,

                ),
              ),
            ),
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: PieChart(
                  dataMap: dataMap,
                  colorList: colorList,
                  chartRadius: MediaQuery.of(context).size.width / 3,
                  centerText: "Visite Technique",
                  chartType: ChartType.ring,
                  ringStrokeWidth: 28,
                  animationDuration: const Duration(seconds: 1),
                  chartValuesOptions: const ChartValuesOptions(
                      showChartValues: true,
                      showChartValuesOutside: true,
                      showChartValuesInPercentage: true,
                      showChartValueBackground: false),
                  legendOptions: const LegendOptions(
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(fontSize: 12),
                      legendPosition: LegendPosition.right,
                      showLegendsInRow: false),
                  gradientList: gradientList,

                ),
              ),
            ),
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: PieChart(
                  dataMap: dataMap,
                  colorList: colorList,
                  chartRadius: MediaQuery.of(context).size.width / 3,
                  centerText: "Vignette",
                  chartType: ChartType.ring,
                  ringStrokeWidth: 28,
                  animationDuration: const Duration(seconds: 1),
                  chartValuesOptions: const ChartValuesOptions(
                      showChartValues: true,
                      showChartValuesOutside: true,
                      showChartValuesInPercentage: true,
                      showChartValueBackground: false),
                  legendOptions: const LegendOptions(
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(fontSize: 12),
                      legendPosition: LegendPosition.right,
                      showLegendsInRow: false),
                  gradientList: gradientList,

                ),
              ),
            ),
          ],

        ),
      ),
    );
  }
}