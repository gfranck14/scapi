import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:searchfield/searchfield.dart';

//import '../../main.dart';

class Accident extends StatefulWidget {
  const Accident({Key? key}) : super(key: key);
  @override
  _AccidentState createState() => _AccidentState();
}

class _AccidentState extends State<Accident> {
  //get key => null;

  List<TextEditingController> _controllerInput = [];
  List<TextField> _textFieldInput = [];
  var total = '';
  var qrString = "";
  late String address = '';
  late String longitude = '';
  late String latitude = '';

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

  Future<Null> _read(var context, int i) async {
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
            _controllerInput[i].text = text.value;
          });
        }
      });
    } on Exception {
      texts.add(OcrText('Failed to recognize text.'));
    }

    if (!mounted) return;

    setState(() => _textsOcr = texts);
  }

  scanQR(
    var context,
    int i,
  ) async {
    try {
      FlutterBarcodeScanner.scanBarcode("#2A99CF", "Cancel", true, ScanMode.QR)
          .then((value) async {
        setState(() {
          _controllerInput[i].text = value;
        });
      });
    } catch (e) {
      qrString = "unable to read the qr";
    }
  }

  Widget deleteBgItem() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  sendAccident(List<String> vehicules) async {
    var response = await http.post(
        Uri.parse("http://dev-scapi.4fagroup.com/api/newAccident"),
        // headers: {
        // "Authorization": "Bearer 4|VoxCao9bdPwEI2PWYm6nM7FYR334nFWwbsedSus3"
        //} ,
        body: {
          'vehicules': jsonEncode(vehicules),
          'coordonnees': "[$longitude,$latitude]",
          'quartier': "qartier de test 1",
          'user_id': "1",
          'ville': address,
          'niveau': "2",
        });
    return jsonDecode(response.body)["message"];
  }

  List<String> suggestions = [
    'Alibori',
    'Atacora',
    'Atlantique',
    'Borgou',
    'Collines',
    'Couffo',
    'Donga',
    'Littoral',
  ];
  String? _selectedItem;

  /* List<String> pickCommune(String Departement) {

  if (Departement = )

  }*/

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size ;

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
          ' ${place.name}, ${place.administrativeArea}, ${place.subAdministrativeArea},    ${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
      print(_address);

      setState(() {
        longitude = position.longitude.toString();
        latitude = "${position.latitude}";
        address = _address;
      });
    }

    Future openDialog() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text("Informations"),
            content: Container(
              height: 200,
              width: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.s,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SearchField(
                        hint: 'Choississez la commune',
                        searchInputDecoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade200,
                              //width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              //width: 2,
                              color: Colors.blue.withOpacity(0.8),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxSuggestionsInViewPort: 6,
                        itemHeight: 5,
                        suggestionsDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        validator: (value) {
                          setState(() {
                            _selectedItem = value!;
                          });

                          // print(value);
                        },
                        hasOverlay: false,
                        suggestionState: Suggestion.expand,
                        suggestions: suggestions
                            .map((e) => SearchFieldListItem(e))
                            .toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    final snackBar = SnackBar(
                      content: Text(
                        "Alerte envoyée",
                        style: TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.green,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Text("Envoyer"))
            ],
          ),
        );

    return SafeArea(
      maintainBottomViewPadding: true,
      // key: ValueKey(key),
      // resizeToAvoidBottomInset: true,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: SizedBox(
            height: 400,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "SIGNALER UN ACCIDENT ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                  width: 300,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        //fixedSize: const Size(470, 30),
                        //primary: Colors.deepOrange
                        ),
                    onPressed: () {
                      _addInputField(context);
                      print(total);
                    },
                    icon: Text('Ajouter un vehicule'),
                    label: Icon(Icons.add, color: Colors.white),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Expanded(
                  child: ListView.builder(
                      itemCount: _controllerInput.length,
                      itemBuilder: (context, index) {
                        return Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                border: Border.all(width: 1),
                                color: Colors.grey[200],
                              ),
                              child: _textFieldInput.elementAt(index),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                child: IconButton(
                                  icon: Icon(Icons.qr_code_scanner_rounded,
                                      color: Colors.blue),
                                  iconSize: 25.0,
                                  onPressed: () async {
                                    await scanQR(
                                      context,
                                      index,
                                    );
                                  },
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                child: IconButton(
                                  icon: Icon(Icons.vignette_sharp,
                                      color: Colors.blue),
                                  iconSize: 25.0,
                                  onPressed: () async {
                                    await _read(
                                      context,
                                      index,
                                    );
                                  },
                                )),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    iconSize: 25.0,
                                    onPressed: () {
                                      setState(() {
                                        _controllerInput.removeAt(index);
                                        _textFieldInput.removeAt(index);
                                      });
                                    }),
                              ),
                            )
                          ],
                        );
                      }),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                  width: 300,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        // fixedSize: const Size(470, 30),
                        //primary: Colors.deepOrange
                        ),
                    onPressed: () async {
                      List<String> vehicules = [];
                      for (var value in _controllerInput) {
                        vehicules.add(value.text);
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InfoAccident(
                                vehicules: vehicules,
                              )));

                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (context) => MyApp()));
                      //openDialog();
                      /* List<String> vehicules = [];
                      for (var value in _controllerInput) {
                        vehicules.add(value.text);
                      }
                      var position = await _getGeoLocationPosition();
                      await GetAddressFromLatLong(position);
                      var response = await sendAccident(vehicules);
                      print(response);
                      final snackBar = SnackBar(
                        content: Text(
                          "Accident signalé",
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.green,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Accident(
                                key: ObjectKey(2),
                              ))); */
                    },
                    icon: Text('Suivant'),
                    label: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  void submit() {
    Navigator.of(context).pop();
    final snackBar = SnackBar(
      content: Text(
        "Alerte envoyée",
        style: TextStyle(fontSize: 16),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _addInputField(context) {
    var inputController = TextEditingController();

    setState(() {
      _controllerInput.add(inputController);
      _textFieldInput.add(
          _generateInputField(_controllerInput[_controllerInput.length - 1]));
      total = _controllerInput.toString();
    });
  }

  _generateInputField(inputController) {
    return TextField(
      controller: inputController,
      decoration:
          InputDecoration(border: InputBorder.none, hintText: "Inserez plaque"),
    );
  }
}

class InfoAccident extends StatefulWidget {
  InfoAccident({Key? key, required this.vehicules}) : super(key: key);
  List<String> vehicules;

  @override
  _InfoAccidentState createState() => _InfoAccidentState();
}

class _InfoAccidentState extends State<InfoAccident> {
  String _selectedCountry = "Atlantique";
  var country = {
    'Atlantique': "AT",
    'Littoral': "LI",
    'Plateau': "PL",
    'Zou': "ZO",
  };

  List _countries = [];
  CountryDependentDropDown() {
    country.forEach((key, value) {
      _countries.add(key);
    });
  }

  String _selectedState = "";
  var state = {
    'Abomey-Calavi': "AT",
    'Allada': "AT",
    'Cotonou': "LI",
    'Ketou': "PL",
    'Pobè': "PL",
    'Abomey': "ZO",
    'Djidja': "ZO",
  };

  List _states = [];
  StateDependentDropDown(countryShortName) {
    state.forEach((key, value) {
      if (countryShortName == value) {
        _states.add(key);
      }
    });
    _selectedState = _states[0];
  }

  String _selectedCity = "";
  var city = {
    'Ouedo': "Abomey-Calavi",
    'Zinvie': "Abomey-Calavi",
    'Godomey': "Abomey-Calavi",
    'Agbanou': "Allada",
    'Ayou': "Allada",
    'Avakpa': "Allada",
    'Cotonou': "Cotonou",
    'Kpankou': "Ketou",
    'Odometa': "Ketou",
    'Okpemata': "Ketou",
    'Igana': "Pobè",
    'Issaba': "Pobè",
    'Ahoyéyé': "Pobè",
    'Agbokpa': "Abomey",
    'Dètohou': "Abomey",
    'Djègbè': "Abomey",
    'Agondji': "Djidja",
    'Mougnon': "Djidja",
    'Zoukon': "Djidja",
  };

  List _cities = [];
  CityDependentDropDown(stateShortName) {
    city.forEach((key, value) {
      if (stateShortName == value) {
        _cities.add(key);
      }
    });
    _selectedCity = _cities[0];
  }

  List<String> suggestionsN = [
    'Niveau 1',
    'Niveau 2',
    'Niveau 3',
  ];

  List<String> types = [
    'Materiel',
    'Corporel',
    'Mortel',
  ];

  late String address = '';
  late String longitude = '';
  late String latitude = '';
  late List<String> vehicules = [];

  TextEditingController controllerC = TextEditingController();
  TextEditingController controllerA = TextEditingController();
  TextEditingController controllerType = TextEditingController();
  TextEditingController controllerRoute = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CountryDependentDropDown();
  }

  @override
  Widget build(BuildContext context) {
    sendAccident() async {
      var response = await http.post(
          Uri.parse("http://dev-scapi.4fagroup.com/api/newAccident"),
          // headers: {
          // "Authorization": "Bearer 4|VoxCao9bdPwEI2PWYm6nM7FYR334nFWwbsedSus3"
          //} ,
          body: {
            'vehicules': jsonEncode(vehicules),
            'coordonnees': "[$longitude,$latitude]",
            'quartier': "qartier de test 1",
            'user_id': "1",
            'ville': address,
            'niveau': controllerType.text,
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
          ' ${place.name}, ${place.administrativeArea}, ${place.subAdministrativeArea},    ${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
      print(_address);

      setState(() {
        longitude = position.longitude.toString();
        latitude = "${position.latitude}";
        address = _address;
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Informations"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  //height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Text(
                          'Choisir le departement',
                          style: style1,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton(
                            value: _selectedCountry,
                            onChanged: (newValue) {
                              setState(() {
                                _cities = [];
                                _states = [];
                                StateDependentDropDown(country[newValue]);
                                _selectedCountry = "$newValue";
                              });
                            },
                            items: _countries.map((country) {
                              return DropdownMenuItem(
                                child: new Text(country),
                                value: country,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Text(
                          'Choisir la commune',
                          style: style1,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 400,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DropdownButton(
                              value: _selectedState,
                              onChanged: (newValue) {
                                print(newValue);
                                setState(() {
                                  print(newValue);
                                  _cities = [];
                                  CityDependentDropDown(newValue);

                                  _selectedState = "$newValue";
                                });
                              },
                              items: _states.map((state) {
                                return DropdownMenuItem(
                                  child: new Text(state),
                                  value: state,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Text(
                          "Choisir l'arrondissement",
                          style: style1,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 50,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton(
                            value: _selectedCity,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCity = "$newValue";
                              });
                            },
                            items: _cities.map((city) {
                              return DropdownMenuItem(
                                child: new Text(city),
                                value: city,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SearchField(
                      controller: controllerType,
                      hint: "Type d'Accident",
                      searchInputDecoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey.shade200,
                            //width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            //width: 2,
                            color: Colors.blue.withOpacity(0.8),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxSuggestionsInViewPort: 6,
                      itemHeight: 50,
                      suggestionsDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      validator: (value) {
                        setState(() {
                          //_selectedItem = value!;
                        });

                        // print(value);
                      },
                      hasOverlay: false,
                      suggestionState: Suggestion.expand,
                      suggestions:
                          types.map((e) => SearchFieldListItem(e)).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: controllerRoute,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Route',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          controller: controllerDescription,
                          decoration: InputDecoration(hintText: "Description"),
                          minLines: 4,
                          maxLines: 7,
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: 400,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            vehicules = vehicules;
                          });
                          var position = await _getGeoLocationPosition();
                          await GetAddressFromLatLong(position);
                          var response = await sendAccident();
                          print(response);
                          final snackBar = SnackBar(
                            content: Text(
                              "Accident signalé",
                              style: TextStyle(fontSize: 16),
                            ),
                            backgroundColor: Colors.green,
                          );
                        },
                        child: Text(
                          "Envoyer",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          //minimumSize: const Size.fromHeight(45)
                        ),
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

const style1 = TextStyle(fontSize: 16, fontStyle: FontStyle.normal);
