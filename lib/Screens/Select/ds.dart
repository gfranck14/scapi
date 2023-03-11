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
          Uri.parse(
              "http://scapi.4fagroup.com/api/vehicule/rapport/${widget.ans.vehicule.matricule}"),
          headers: {
            "Authorization": "Bearer 4|VoxCao9bdPwEI2PWYm6nM7FYR334nFWwbsedSus3"
          },
          body: {
            'lieux': address,
            'coordonnées': "[$longitude,$latitude]",
            'description': description,
            // 'visite': 0,
            //'vignette': 0,
            //'assurance':0,
            //'avertissement':0,
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
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: height / 9,
              child: Card(
                elevation: 10,
                child: Center(
                  child: Text(widget.ans.vehicule.matricule,
                      style: TextStyle(fontSize: 51)),
                ),
              ),
            ),
            Container(
              height: height / 9,
              child: Card(
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
                    SizedBox(width: 120),
                    Row(
                      children: [
                        Text(widget.ans.vehicule.proprio.nom,
                            style: TextStyle(fontSize: 16)),
                        SizedBox(
                          width: 5,
                        ),
                        Text(widget.ans.vehicule.proprio.prenom,
                            style: TextStyle(fontSize: 16)),
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
                                  image: AssetImage('assets/icons/marque.png'),
                                  fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(75.0)),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text("Marque",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Flexible(
                        child: SizedBox(width: 90),
                      ),
                      Text(widget.ans.vehicule.marque,
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
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
                      Text(widget.ans.vehicule.chassis,
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: height / 9,
              child: Card(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                        ),
                      ),
                    ),
                    Text("Assurance",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Flexible(child: SizedBox(width: 60)),
                    Container(
                        //padding: EdgeInsets.all(30.0),
                        child: Chip(
                      label: Text(widget.ans.assurance),
                      backgroundColor: widget.ans.assurance == "Expiré"
                          ? Colors.red
                          : widget.ans.assurance == "Expire"
                              ? Colors.orange
                              : Colors.green,
                      elevation: 5,
                      autofocus: true,
                    )),
                    SizedBox(width: 40),
                    //if (widget.total >= 1 && widget.ans.assurance == "Expire" || widget.total >= 1 && widget.ans.assurance == "Expiré")

                    if ((widget.total > 1) &&
                        (widget.ans.assurance == "Expire" ||
                            widget.ans.assurance == "Expiré"))
                      IconButton(
                        icon: Icon(Icons.message, color: Colors.blue),
                        iconSize: 30.0,
                        onPressed: () {},
                      ),

                    if ((widget.total <= 1) &&
                        (widget.ans.assurance == "Expire" ||
                            widget.ans.assurance == "Expiré"))
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
          ],
        ),
      ),
    );
  }
}
