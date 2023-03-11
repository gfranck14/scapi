import 'package:bottomnavigationbar/search.dart';
import 'package:bottomnavigationbar/settings.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PageController pageController=PageController();
  List<Widget>pages=[HomePage(),Settings(),Search()];

  int selectIndex=0;
  void onPageChanged(int index){
    setState(() {
      selectIndex=index;
    });
  }

  void onItemTap(int selectedItems){
    pageController.jumpToPage(selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffd9ffbf),
        onTap: onItemTap,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,color: selectIndex==0?Colors.green:Colors.grey,),
              title: Text("Home",
                style: TextStyle(color: selectIndex==0?Colors.green:Colors.grey),)),

          BottomNavigationBarItem(
              icon: Icon(Icons.settings,color: selectIndex==1?Colors.green:Colors.grey,),
              title: Text("Settings",
                style: TextStyle(color: selectIndex==1?Colors.green:Colors.grey),)),


          BottomNavigationBarItem(
              icon: Icon(Icons.search,color: selectIndex==2?Colors.green:Colors.grey,),
              title: Text("Search",
                style: TextStyle(color: selectIndex==2?Colors.green:Colors.grey),)),
        ],
      ),
    );
  }
}




++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
import 'dart:convert';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:new_scapi/Screens/Login/components/background.dart';
import 'PlateModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class Body extends StatefulWidget {
  const Body({
    required Key key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState(key: key);
}

class _BodyState extends State<Body> {

  TextEditingController _plateValue = TextEditingController();
  var key;
  _BodyState({this.key});

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var value = '';
    String qrString = '';

    return Background(
      key: ValueKey(key),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Select an option to check plate",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/select.svg",
                height: size.height * 0.29,
              ),
              SizedBox(height: size.height * 0.05),
              ElevatedButton.icon(
                onPressed: () async {
                  // var result =
                  await scanQR(context);
                },
                icon: Text('Scan QR Code'),
                label: Icon(Icons.camera_alt, color: Colors.white),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                width: MediaQuery.of(context).size.width * .4,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: _plateValue,
                          decoration: InputDecoration(
                            hintText: "EX: AR2541",
                            border: OutlineInputBorder(),
                            isDense: true,
                          )),
                    ),
                    SizedBox(width: size.width * 0.01),
                    Ink(
                      decoration: ShapeDecoration(
                          color: Colors.blue, shape: BeveledRectangleBorder()),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_rounded,
                            color: Colors.white),
                        iconSize: 20.0,
                        onPressed: () {
                          var qrString = _plateValue.text;


                          getStudent(qrString).then((result) {
                            debugPrint(result);
                            var total = 0;
                            if (result.assurance == "A jour") total = total + 1;
                            if (result.visite == "A jour") total = total + 1;
                            if (result.vignette == "A jour") total = total + 1;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BodyLayout(result, total)));
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}

String qrString = "";

scanQR(var context) async {
  try {
    FlutterBarcodeScanner.scanBarcode("#2A99CF", "Cancel", true, ScanMode.QR)
        .then((value) async {
      qrString = value;
      getStudent(qrString).then((result) {
        var total = 0;
        if (result.assurance == "A jour") total = total + 1;
        if (result.visite == "A jour") total = total + 1;
        if (result.vignette == "A jour") total = total + 1;
        print(total);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BodyLayout(result, total)));
      });
    });
  } catch (e) {
    qrString = "unable to read the qr";
  }
}
//............................api request

getStudent(String qrCode) async {
  final url = "http://carsscan.4fagroup.com/api/vehicules/vehicule/?id=$qrCode";
  final response = await http.get(url);
  //final response = await http.get(Uri.encodeFull(url));
  //debugPrint(response.statusCode.toString());
  if (response.statusCode == 200) {
    final jsonStudent = jsonDecode(response.body);
    return Users.fromJson(jsonStudent);
  } else {
    throw Exception();
  }
}

class BodyLayout extends StatefulWidget {
  dynamic ans;
  var total;
  BodyLayout(this.ans, this.total);
  @override
  State<BodyLayout> createState() => _BodyLayoutState();
}

class _BodyLayoutState extends State<BodyLayout> {
  late TwilioFlutter twilioFlutter;

  @override
  void initState() {
    twilioFlutter =
        TwilioFlutter(accountSid: 'AC98ec5d9a86993d7931368ea9b7ea1729', authToken: '8f8c61336f5d9be3e2d833a23c704291', twilioNumber: '+19378586891');
    super.initState();
  }

  void sendSms() async {
    twilioFlutter.sendSMS(toNumber: '+22967864795', messageBody: 'Verifier la validite de votre piece');
  }
  @override
  Widget build(BuildContext context) {
    //Color getColor() {//  if (widget.ans.assurance == "Expire") {//   return Colors.amber;// } else if (widget.ans.assurance == "A jour") {// return Colors.green;//} else {//   return Colors.red;// }//  }

    TextEditingController _rapport = TextEditingController();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Résultat de la recherche"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: height / 9,
            child: Card(
              //         color: Colors.blue,
              elevation: 10,
              child: Center(
                child: Text(widget.ans.imma,
                    style: TextStyle(fontSize: 51)),
              ),
            ),
          ),
          Container(
            height: height / 9,
            child: Card(
              //                color: Colors.blue,
              elevation: 10,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                            image: AssetImage('assets/icons/name.JPG'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                      ),
                    ),
                  ),
                  Flexible(
                      child: Text("Nom",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))),
                  SizedBox(width: 70),
                  Row(
                    children: [
                      Text(widget.ans.nomprop , style: TextStyle(fontSize: 16)),
                      SizedBox(width:5,),
                      Text(widget.ans.preprop , style: TextStyle(fontSize: 16)),
                    ],
                  ),

                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: height / 9,
              child: Card(
                //                color: Colors.blue,
                elevation: 10,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 58.0,
                          height: 58.0,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: AssetImage('assets/icons/chassis.JPG'),
                                fit: BoxFit.cover),
                            borderRadius:
                            BorderRadius.all(Radius.circular(75.0)),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text("Chassis",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Flexible(
                      child: SizedBox(width: 128),
                    ),
                    Text(widget.ans.chassis,
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),



          Container(
            height: height / 9,
            child: Card(
              //                color: Colors.blue,
              elevation: 10,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 58.0,
                        height: 58.0,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                              image: AssetImage('assets/icons/insurance.JPG'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        ),
                      ),
                    ),
                  ),
                  Text("Assurance",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Flexible(child: SizedBox(width: 50)),
                  Container(
                    //padding: EdgeInsets.all(30.0),
                      child: Chip(
                        label: Text(widget.ans.assurance),
                        backgroundColor: widget.ans.assurance == "Expiré" ? Colors.red : widget.ans.assurance == "Expire" ? Colors.orange : Colors.green,
                        elevation: 5,
                        autofocus: true,
                      )),
                  SizedBox(width: 40),
                  //if (widget.total >= 1 && widget.ans.assurance == "Expire" || widget.total >= 1 && widget.ans.assurance == "Expiré")

                  if  ( (widget.total > 1) && (widget.ans.assurance == "Expire" || widget.ans.assurance == "Expiré")   )
                    IconButton(
                      icon: Icon(Icons.message, color: Colors.blue),
                      iconSize: 30.0,
                      onPressed: () {},
                    ),

                  if  ((widget.total <= 1) && (widget.ans.assurance == "Expire" || widget.ans.assurance == "Expiré")   )
                    IconButton(
                      icon: Icon(Icons.message, color: Colors.white),
                      iconSize: 0.0,
                      onPressed: () {},
                    ),
                ],
              ),
            ),
          ),
          Container(
            height: height / 9,
            child: Card(
              //                color: Colors.blue,
              elevation: 10,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 58.0,
                        height: 58.0,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                              image: AssetImage('assets/icons/visit techn.JPG'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        ),
                      ),
                    ),
                  ),
                  Text("Visite technique",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Flexible(child: SizedBox(width: 65)),
                  Container(
                    //padding: EdgeInsets.all(30.0),
                      child: Chip(
                        // label: Text(widget.ans.technical.technicalVisit),
                        label: Text(widget.ans.visite),
                        backgroundColor: widget.ans.visite == "Expiré" ? Colors.red : widget.ans.visite == "Expire" ? Colors.orange : Colors.green,
                        elevation: 5,
                        autofocus: true,
                      )),
                  Flexible(child: SizedBox(width: 40)),
                  //if (widget.total >= 1 && widget.ans.visite == "Expire" || widget.total >= 1 && widget.ans.visite == "Expiré")
                  //IconButton(
                  //icon: Icon(Icons.message, color: Colors.blue),
                  //iconSize: 30.0,
                  // onPressed: () {},
                  //),
                  if  ( (widget.total > 1) && (widget.ans.visite == "Expire" || widget.ans.visite == "Expiré")   )
                    IconButton(
                      icon: Icon(Icons.message, color: Colors.blue),
                      iconSize: 30.0,
                      onPressed: () {},
                    ),

                  if  ((widget.total <= 1) && (widget.ans.visite == "Expire" || widget.ans.visite == "Expiré")   )
                    IconButton(
                      icon: Icon(Icons.message, color: Colors.white),
                      iconSize: 0.0,
                      onPressed: () {
                        sendSms;
                      },
                    ),

                ],
              ),
            ),
          ),
          Container(
            height: 80,
            child: Card(
              //                color: Colors.blue,
              elevation: 10,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 58.0,
                        height: 58.0,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                              image: AssetImage('assets/icons/vignette.JPG'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        ),
                      ),
                    ),
                  ),
                  Text("Vignette",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 60),
                  Container(
                    //padding: EdgeInsets.all(30.0),
                    child: Chip(
                      label: Text(widget.ans.vignette),
                      backgroundColor: widget.ans.vignette == "Expiré" ? Colors.red : widget.ans.vignette == "Expire" ? Colors.orange : Colors.green,

                      elevation: 5,
                      autofocus: true,
                    ),
                  ),
                  Flexible(child: SizedBox(width: 80)),
                  //if (widget.total == 2 && widget.ans.vignette == "Expire" || widget.ans.vignette == "Expiré")

                  //  IconButton(
                  //icon: Icon(Icons.message, color: Colors.blue),
                  //iconSize: 30.0,
                  //onPressed: () {},
                  //),
                  if  ( (widget.total > 1) && (widget.ans.vignette == "Expire" || widget.ans.vignette == "Expiré")   )



                    IconButton(
                      icon: Icon(Icons.message, color: Colors.blue),
                      iconSize: 30.0,
                      onPressed: () { },
                    ),

                  if  ((widget.total <= 1) && (widget.ans.vignette == "Expire" || widget.ans.vignette == "Expiré")   )

                    IconButton(
                      icon: Icon(Icons.message, color: Colors.white),
                      iconSize: 0.0,
                      onPressed: () {},
                    ),


                ],
              ),
            ),
          ),
          SizedBox(height: height / 20),
          AnimatedPositioned(
            bottom: -40,
            duration: Duration(milliseconds: 100),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                height: height / 6.5,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).colorScheme.surface,
                //color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // if (widget.total <= 1)

                    if (widget.total <= 1 )
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            print("FlatButton");
                          },
                          child: Column(
                            children: [
                              Icon(Icons.warning, color: Colors.amber),
                              Text("Envoyer un avertissement"),
                            ],
                          ),
                        ),
                      ),
                    VerticalDivider(
                      color: Colors.black26,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            context: context,
                            builder: (context) {
                              var textController;
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ListView(
                                  children: [
                                    Card(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text(
                                                "Refus d'obtempérer aggravé ",
                                                style: TextStyle(fontSize: 16)),
                                          ),
                                          Flexible(child: SizedBox(width: 120)),
                                          IconButton(
                                            icon: Icon(
                                                Icons.keyboard_arrow_right,
                                                color: Colors.blue),
                                            iconSize: 30.0,
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    Card(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text(
                                                "Usurpation de plaque d'triculation",
                                                style: TextStyle(fontSize: 16)),
                                          ),
                                          Flexible(child: SizedBox(width: 120)),
                                          IconButton(
                                            icon: Icon(
                                                Icons.keyboard_arrow_right,
                                                color: Colors.blue),
                                            iconSize: 30.0,
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    Card(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text(
                                                "Conduite en état d'ivresse manifeste ",
                                                style: TextStyle(fontSize: 16)),
                                          ),
                                          Flexible(child: SizedBox(width: 120)),
                                          IconButton(
                                            icon: Icon(
                                                Icons.keyboard_arrow_right,
                                                color: Colors.blue),
                                            iconSize: 30.0,
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    Card(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Text(
                                                "Conduite sous l'influence de stupefiants ",
                                                style: TextStyle(fontSize: 16)),
                                          ),
                                          Flexible(child: SizedBox(width: 120)),
                                          IconButton(
                                            icon: Icon(
                                                Icons.keyboard_arrow_right,
                                                color: Colors.blue),
                                            iconSize: 30.0,
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 300,
                                              height: 50,
                                              child: TextFormField(
                                                controller: _rapport,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  hintText:
                                                  '[Saissisez un rapport...]',
                                                  hintStyle: TextStyle(),
                                                  enabledBorder:
                                                  OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                    const BorderRadius.only(
                                                      topLeft:
                                                      Radius.circular(4.0),
                                                      topRight:
                                                      Radius.circular(4.0),
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                  OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.lightBlue,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                    const BorderRadius.only(
                                                      topLeft:
                                                      Radius.circular(4.0),
                                                      topRight:
                                                      Radius.circular(4.0),
                                                    ),
                                                  ),
                                                  filled: true,
                                                ),
                                                style: TextStyle(),
                                                maxLines: 8,
                                                keyboardType:
                                                TextInputType.multiline,
                                              ),
                                            ),
                                            Flexible(
                                                child: SizedBox(width: 150)),
                                            IconButton(
                                              icon: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.blue),
                                              iconSize: 30.0,
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Icon(Icons.note_add_outlined),
                            Text("Ajouter un rapport"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
var date = "" ;
var time = "";
var location = "";

var nomagent = "";
var description = "";

sendReport(String date,String time,String locat,String imma,String nomagent,String description) async{
  final  apiUrl = "https://reqres.in/api/users";

  final response = await http.post("https://reqres.in/api/users", body: {
    // 'date': '10-Mar-2022',
    //'time': '15:54',
    //'location': 'Calavi, calavi',
    //'imma': 'ab3444',
    //'nomagent': 'jean',
    //'description': 'le controle a ete effectue avec succes',
    'date': date,
    'time': time,
    'location': location,
    'imma': imma,
    'nomagent': nomagent,
    'description':description
  });
}