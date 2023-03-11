import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_scapi/Screens/Select/accident.dart';
import 'package:new_scapi/Screens/Select/alert.dart';
import 'package:new_scapi/Screens/Select/components/body.dart';
import 'package:pie_chart/pie_chart.dart';

import 'StatModel.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final screens = [
    Body(
      key: key,
    ),
    etranger(),
    Search(),
    Accident()
  ];
  int currentIndex = 0;

  static get key => null;
  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: screens[currentIndex],
      bottomNavigationBar: isKeyboardOpen
          ? null
          : BottomNavigationBar(
              showUnselectedLabels: true,
              currentIndex: currentIndex,
              selectedFontSize: 16,
              unselectedFontSize: 15,
              onTap: (index) => setState(() => currentIndex = index),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.qr_code_scanner_rounded),
                    label: 'Controle',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.directions_car),
                    label: 'V-Etranger',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.warning),
                    label: 'Alerte',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(Icons.taxi_alert),
                    label: 'Accident',
                    backgroundColor: Colors.blue),
              ],
            ),
    );
  }
}

getStat() async {
  final url = "http://dev-scapi.4fagroup.com/api/stat/pieces";
  final response = await http.get(url);
  print(response);
  //final response = await http.get(Uri.encodeFull(url));
  //debugPrint(response.statusCode.toString());
  if (response.statusCode == 200) {
    final jsonStudent = jsonDecode(response.body);
    return Users.fromJson(jsonStudent);
  } else {
    throw Exception();
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, double> dataMap = {
    "A jour": 521,
    "Expire": 280,
    "Expiré": 224,
  };

  Map<String, double> dataMap1 = {
    "Valide": 521,
    "Invalide": 280,
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
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Statistiques"),
      ),
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
                  dataMap: dataMap1,
                  colorList: colorList,
                  chartRadius: MediaQuery.of(context).size.width / 3,
                  centerText: "TVM",
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
