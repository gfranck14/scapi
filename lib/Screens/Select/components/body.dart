import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:twilio_flutter/twilio_flutter.dart';

import '../select_screen.dart';
import 'PlateModel.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

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
  String _platformVersion = 'Unknown';

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await FlutterMobileVision.platformVersion ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  int? _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  bool _autoFocusOcr = true;
  bool _torchOcr = false;
  bool _multipleOcr = false;
  bool _waitTapOcr = true;
  bool _showTextOcr = true;
  Size? _previewOcr;
  List<OcrText> _textsOcr = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    FlutterMobileVision.start().then((previewSizes) => setState(() {
          _previewOcr = previewSizes[_cameraOcr]!.first;
        }));
  }

  Future<Null> _read(var context) async {
    List<OcrText> texts = [];
    Size _scanpreviewOcr = _previewOcr ?? FlutterMobileVision.PREVIEW;

    try {
      FlutterMobileVision.read(
        flash: _torchOcr,
        autoFocus: _autoFocusOcr,
        multiple: _multipleOcr,
        waitTap: _waitTapOcr,
        //OPTIONAL: close camera after tap, even if there are no detection.
        //Camera would usually stay on, until there is a valid detection
        forceCloseCameraOnTap: true,
        //OPTIONAL: path to save image to. leave empty if you do not want to save the image
        imagePath: '',
        showText: _showTextOcr,
        preview: _previewOcr ?? FlutterMobileVision.PREVIEW,
        scanArea: Size(_scanpreviewOcr.width - 20, _scanpreviewOcr.height - 20),
        camera: _cameraOcr ?? FlutterMobileVision.CAMERA_BACK,
        fps: 2.0,
      ).then((valeur) async {
        print(valeur);
        for (OcrText text in valeur) {
          print(
              'valueisuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu ${text.value}');
          setState(() {
            _plateValue.text = text.value;
          });
        }
      });
    } on Exception {
      texts.add(OcrText('Failed to recognize text.'));
    }

    if (!mounted) return;

    setState(() => _textsOcr = texts);
  }

  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: ValueKey(key),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "CHOISSISSEZ UNE OPTION DE CONTROLE",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/select.svg",
                height: MediaQuery.of(context).size.height * 0.29,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              /*ElevatedButton.icon(
                onPressed: () async {
                  // var result =
                  await scanQR(context);
                },
                icon: Text('Scanner un QR Code'),
                label: Icon(Icons.qr_code_sharp, color: Colors.white),
              ),*/

              Card(
                elevation: 5,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 25,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 22,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await scanQR(context);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 25,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.camera_enhance,
                          size: 22,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          _read(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
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
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01),
                          IconButton(
                              icon: Icon(Icons.send, color: Colors.blue),
                              iconSize: 25.0,
                              onPressed: () {
                                var qrString = _plateValue.text;
                                getStudent(qrString).then((result) {
                                  //  print(_plateValue.text);
                                  //debugPrint(result);
                                  var total = 0;
                                  if (result.assurance == "A jour")
                                    total = total + 1;
                                  if (result.visite == "A jour")
                                    total = total + 1;
                                  if (result.vignette == "A jour")
                                    total = total + 1;

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          BodyLayout(result)));

                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //   builder: (context) => BodyLayout(result)));
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ElevatedButton.icon(                onPressed: () {                 _read(context);               },               icon: Text('Ocr'),                label: Icon(Icons.qr_code_sharp, color: Colors.white)  ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            ]),
          ),
        ),
      ),
      //screens[currentIndex],
    );
  }
}

var qrString = "";

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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => BodyLayout(result)));
      });
    });
  } catch (e) {
    qrString = "unable to read the qr";
  }
}
//............................api request

getStudent(String qrCode) async {
  final url = "http://benin-scapi.4fagroup.com/api/vehicule/$qrCode";

  // final url = "http://scapi.4fagroup.com/api/vehicule/$qrCode";
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

class BodyLayout extends StatefulWidget {
  dynamic ans;

  BodyLayout(this.ans);

  @override
  State<BodyLayout> createState() => _BodyLayoutState();
}

class _BodyLayoutState extends State<BodyLayout> {
  late TwilioFlutter twilioFlutter;
  late String address;
  late String longitude;
  late String latitude;
  dynamic ans;

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC98ec5d9a86993d7931368ea9b7ea1729',
        authToken: '8f8c61336f5d9be3e2d833a23c704291',
        twilioNumber: '+19378586891');
    super.initState();
  }

  void sendSms() async {
    twilioFlutter.sendSMS(
        toNumber: '+22967864795',
        messageBody: 'Verifier la validite de votre piece');
  }

  @override
  Widget build(BuildContext context) {
    //Color getColor() {//  if (widget.ans.assurance == "Expire") {//   return Colors.amber;// } else if (widget.ans.assurance == "A jour") {// return Colors.green;//} else {//   return Colors.red;// }//  }
    TextEditingController _rapport = TextEditingController();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    sendRapport({var description = null}) async {
      var response = await http.post(
          Uri.parse("http://benin-scapi.4fagroup.com/api/vehicule/rapport/"
              //"${widget.ans.vehicule.matricule}"
              ""),
          headers: {
            "Authorization": "Bearer 4|VoxCao9bdPwEI2PWYm6nM7FYR334nFWwbsedSus3"
          },
          body: {
            'lieux': address,
            'coordonnées': "[$longitude,$latitude]",
            'description': description,
          });
      return jsonDecode(response.body)["message"];
    }

    sendRapportC(String description) async {
      var response = await http.post(
          Uri.parse("http://dev-scapi.4fagroup.com/api/vehicule/rapport/"),
          headers: {
            "Authorization": "Bearer 4|VoxCao9bdPwEI2PWYm6nM7FYR334nFWwbsedSus3"
          },
          body: {
            'lieux': address,
            'coordonnées': "[$longitude,$latitude]",
            'description': description,
          });
      return jsonDecode(response.body)["message"];
    }

    Future<Position> _getGeoLocationPosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }

    Future GetAddressFromLatLong(Position position) async {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      //print(placemarks);
      Placemark place = placemarks[0];
      var _address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
      setState(() {
        longitude = "${position.longitude}";
        latitude = "${position.latitude}";
        address = _address;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        var position = await _getGeoLocationPosition();
        await GetAddressFromLatLong(position);
        print(address);
        sendRapport();
        // var message = await sendRapport();
        //print(message);
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Résultat de la recherche"),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Center(
              child: Text(widget.ans.vehicule.matricule,
                  style: TextStyle(fontSize: 51)),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: Row(
                  children: [
                    Text("NPI:",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 80,
                    ),
                    Text("52011254788624",
                        style: TextStyle(
                          fontSize: 22,
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: Row(
                  children: [
                    Text("Nom:",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 70,
                    ),
                    Text(
                        "${widget.ans.vehicule.proprio.nom} ${widget.ans.vehicule.proprio.prenom} ",
                        style: TextStyle(
                          fontSize: 22,
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: Row(
                  children: [
                    Text("Adresse:",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 40,
                    ),
                    Text("Adresse",
                        style: TextStyle(
                          fontSize: 22,
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: Row(
                  children: [
                    Text("Tel:",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 80,
                    ),
                    Text(widget.ans.vehicule.proprio.tel,
                        style: TextStyle(
                          fontSize: 22,
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: Row(
                  children: [
                    Text("Marque:",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 40,
                    ),
                    Text(widget.ans.vehicule.marque,
                        style: TextStyle(
                          fontSize: 22,
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: Row(
                  children: [
                    Text("Chassis:",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 40,
                    ),
                    Text(widget.ans.vehicule.chassis,
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: Row(
                  children: [
                    Text("Assurance:",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 10,
                    ),
                    Text(widget.ans.assurance,
                        style: TextStyle(
                          fontSize: 22,
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: Row(
                  children: [
                    Text("Visite T:",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 40,
                    ),
                    Text(widget.ans.visite,
                        style: TextStyle(
                          fontSize: 22,
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Expanded(
                child: Row(
                  children: [
                    Text("TVM:",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 70,
                    ),
                    Text(widget.ans.vignette,
                        style: TextStyle(
                          fontSize: 22,
                        )),
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

                      // if (widget.total <= 1)
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            print("FlatButton");
                          },
                          child: Column(
                            children: [
                              Icon(Icons.warning, color: Colors.amber),
                              Text("Avertissement"),
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
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Text(
                                                  "Refus d'obtempérer aggravé ",
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            ),
                                            Flexible(
                                                child: SizedBox(width: 120)),
                                            IconButton(
                                              icon: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.blue),
                                              iconSize: 30.0,
                                              onPressed: () {
                                                sendRapportC(
                                                    "Refus d'obtempérer aggravé");
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SelectScreen()));
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Card(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Text(
                                                  "Usurpation de plaque d'triculation",
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            ),
                                            Flexible(
                                                child: SizedBox(width: 120)),
                                            IconButton(
                                              icon: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.blue),
                                              iconSize: 30.0,
                                              onPressed: () {
                                                sendRapportC(
                                                    "Usurpation de plaque d'triculation");
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SelectScreen()));
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Card(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Text(
                                                  "Conduite en état d'ivresse manifeste ",
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            ),
                                            Flexible(
                                                child: SizedBox(width: 120)),
                                            IconButton(
                                              icon: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.blue),
                                              iconSize: 30.0,
                                              onPressed: () {
                                                sendRapportC(
                                                    "Usurpation de plaque d'triculation");
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SelectScreen()));
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Card(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Text(
                                                  "Conduite sous l'influence de stupefiants ",
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            ),
                                            Flexible(
                                                child: SizedBox(width: 120)),
                                            IconButton(
                                              icon: Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.blue),
                                              iconSize: 30.0,
                                              onPressed: () {
                                                sendRapportC(
                                                    "Conduite sous l'influence de stupefiants ");
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SelectScreen()));
                                              },
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
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                        topRight:
                                                            Radius.circular(
                                                                4.0),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.lightBlue,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                        topRight:
                                                            Radius.circular(
                                                                4.0),
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
                                                onPressed: () {
                                                  sendRapportC(_rapport.text);
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SelectScreen()));
                                                },
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
      ),
    );
  }
}

class etranger extends StatefulWidget {
  const etranger({Key? key}) : super(key: key);

  @override
  _etrangerState createState() => _etrangerState();
}

class _etrangerState extends State<etranger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("Vehicule etranger"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Nom du proprietaire',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Profession',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Adresse',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Numero d'immatriculation",
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Assurance CEDEAO',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Laisser passer',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Provenance',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Type de vehicule',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Nom du conducteur',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Profession du conducteur',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () async {
                      final snackBar = SnackBar(
                        content: Text(
                          "Vehicule enregistré",
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.green,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SelectScreen()));

                      // final user = User(nameController.text, location, lat, long);
                      //  widget.addUser(user);
                      Navigator.of(context).pop();
                    },
                    child: Text('Enregistrer'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
