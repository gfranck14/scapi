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
width: MediaQuery.of(context).size.width *
0.01),
IconButton(
icon: Icon(Icons.send, color: Colors.blue),
iconSize: 25.0,
onPressed: () {
var qrString = _plateValue.text;
getStudent(qrString).then((result) {
print(_plateValue.text);
//debugPrint(result);
var total = 0;
if (result.assurance == "A jour")
total = total + 1;
if (result.visite == "A jour")
total = total + 1;
if (result.vignette == "A jour")
total = total + 1;
Navigator.of(context).push(
MaterialPageRoute(
builder: (context) =>
BodyLayout(result, total)));
});
},
),
SizedBox(
width: 8,
),
],
),
),
],
),
),
"""""""""""""""""""""""""""""""""""""""


SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "CHOISSISSEZ UNE OPTION DE CONTROLE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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

                  TabBarView(
                    children: [local(), etranger()],
                  ),

                  // ElevatedButton.icon(                onPressed: () {                 _read(context);               },               icon: Text('Ocr'),                label: Icon(Icons.qr_code_sharp, color: Colors.white)  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                ]),
          ),
        ),
      ),

      ///////////////////////////body

      ListView(
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
                    Column(
                      children: [
                        Flexible(
                            child: Text("Nom",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                        Flexible(
                            child: Text("Adresse",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                        Flexible(
                            child: Text("Tel",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)))
                      ],
                    ),
                    SizedBox(width: 80),
                    Column(
                      children: [
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
                        Column(
                          children: [
                            Text(widget.ans.vehicule.proprio.adresse.toString(),
                                style: TextStyle(fontSize: 16)),
                            SizedBox(
                              width: 5,
                            ),
                            Text(widget.ans.vehicule.proprio.tel,
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
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
                                image:
                                    AssetImage('assets/icons/visit techn.JPG'),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                        ),
                      ),
                    ),
                    Text("Visite technique",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Flexible(child: SizedBox(width: 30)),
                    Container(
                        //padding: EdgeInsets.all(30.0),
                        child: Chip(
                      label: Text(widget.ans.visite),
                      backgroundColor: widget.ans.visite == "Expiré"
                          ? Colors.red
                          : widget.ans.visite == "Expire"
                              ? Colors.orange
                              : Colors.green,
                      elevation: 5,
                      autofocus: true,
                    )),
                    SizedBox(width: 40),
                    //if (widget.total >= 1 && widget.ans.assurance == "Expire" || widget.total >= 1 && widget.ans.assurance == "Expiré")

                    if ((widget.total > 1) &&
                        (widget.ans.visite == "Expire" ||
                            widget.ans.visite == "Expiré"))
                      IconButton(
                        icon: Icon(Icons.message, color: Colors.blue),
                        iconSize: 30.0,
                        onPressed: () {},
                      ),

                    if ((widget.total <= 1) &&
                        (widget.ans.visite == "Expire" ||
                            widget.ans.visite == "Expiré"))
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                          ),
                        ),
                      ),
                    ),
                    Text("TVM",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Flexible(child: SizedBox(width: 85)),
                    Container(
                        //padding: EdgeInsets.all(30.0),
                        child: Chip(
                      label: Text(widget.ans.vignette),
                      backgroundColor: widget.ans.vignette == "Expiré"
                          ? Colors.red
                          : widget.ans.vignette == "Expire"
                              ? Colors.orange
                              : Colors.green,
                      elevation: 5,
                      autofocus: true,
                    )),
                    SizedBox(width: 40),
                    //if (widget.total >= 1 && widget.ans.assurance == "Expire" || widget.total >= 1 && widget.ans.assurance == "Expiré")

                    if ((widget.total > 1) &&
                        (widget.ans.vignette == "Expire" ||
                            widget.ans.vignette == "Expiré"))
                      IconButton(
                        icon: Icon(Icons.message, color: Colors.blue),
                        iconSize: 30.0,
                        onPressed: () {},
                      ),

                    if ((widget.total <= 1) &&
                        (widget.ans.vignette == "Expire" ||
                            widget.ans.vignette == "Expiré"))
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

                      if (widget.total <= 1)
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