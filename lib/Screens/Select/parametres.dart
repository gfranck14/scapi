import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Compte extends StatefulWidget {
  const Compte({Key? key}) : super(key: key);

  @override
  _CompteState createState() => _CompteState();
}

class _CompteState extends State<Compte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compte"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text("Souscrire à la notification"),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseMessaging.instance
                        .subscribeToTopic("subscription");
                  },
                  child: Text("Souscrire"))
            ],
          )
        ],
      ),
    );
  }
}
