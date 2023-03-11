import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController immat;

  get key => null;
  @override
  void initState() {
    requestPermission();
    getToken();
    immat = TextEditingController();
  }

  @override
  void dispose() {
    immat.dispose();
    super.dispose();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("permission granted");
    } else {
      print("permission declined");
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        var mtoken = token;
        print("myyyyyyyyyyyyyyyyyyyyyyyyyy   $mtoken");
      });
    });
  }

  void sendPushMessage() async {
    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAASBmMD2s:APA91bHNX3cDtJ5lodQgalHuogEMWY2yH1pzOfNA4xOS_uq55tYfVJSRWD5RqNNxeOqZNqEfB3F1mq1x-L_Wtgtb1jieHXS-v-xPEwgu05YM7VavUK7U8lDr9aveaE_zttBoTLxQpsdo'
              },
              body: jsonEncode(<String, dynamic>{
                'priority': 'high',
                'data': <String, String>{
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'status': 'done',
                  'body': 'AR5014 Conduite en etat...',
                  'title': 'Alerte-SCAPI'
                },
                "notification": <String, String>{
                  'title': 'Alerte-SCAPI',
                  'body': 'AR5014 Conduite en etat...',
                },
                "to":
                    'd2DuB5GkQYOOxMOf2Vc4sv:APA91bGOLvuy-lV-SNY6xrgHKcu8Soj_dmiKwIj2ih0dGKvmKH0JSrTrE1Esc8oOx8xQUULOW6BXRBrarkZ_leTBMrksF98J6ksajnJOcUr2YFOf4cUtPfArAb7q9S4hgP3xqrQ-r8as',
                "direct_boot_ok": true,
              }));

      if (response.statusCode == 200) {
        print("Sentttttttttttttttttttttttttttttttttttttttt");
      } else {
        print("erroooooooooooooooooooooooooooooooooooooooooor");
      }
    } catch (e) {
      if (kDebugMode) {
        print("error push notification");
      }
    }
  }

  String _value = '';
  @override
  Widget build(BuildContext context) {
    Future openDialog() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text("Alerte"),
            content: Container(
              height: 200,
              width: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.s,
                children: [
                  Expanded(
                      child: TextFormField(
                    decoration:
                        InputDecoration(hintText: "Plaque d'immatriculation"),
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 'non-negotiable',
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              print(_value);
                            });
                          }),
                      Text(
                        "Refus d'optemperer",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 'non-negotiable',
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              print(_value);
                            });
                          }),
                      Text("Conduite sous l'influence \n de stupefiants",
                          style: TextStyle(fontSize: 15))
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 'non-negotiable',
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              print(_value);
                            });
                          }),
                      Text("Conduite en etat d'ivresse",
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    sendPushMessage();
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

    Size size = MediaQuery.of(context).size;
    var value = '';
    String qrString = '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "                Envoyer une alerte",
          textAlign: TextAlign.center,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(32),
              child: ElevatedButton(
                onPressed: () {
                  openDialog();
                },
                child: Text("Signaler"),
              ),
            ),
          ),
          /* ElevatedButton(
              onPressed: () async {
                await FirebaseMessaging.instance
                    .subscribeToTopic("subscription");
              },
              child: Text("Souscrire")),
          ElevatedButton(onPressed: () async {}, child: Text("Notif"))*/
        ],
      ),
    );
  }
}
